from __future__ import annotations
from typing import Optional, List, Tuple
from src.settings import AppSettings
from src.trino_client import TrinoClient


class Customer360Query:
    def __init__(self, settings: AppSettings, client: Optional[TrinoClient] = None) -> None:
        self.s = settings
        self.client = client

    def build_unified_sql(self, customer_id: int) -> str:
        pg_cat = self.s.TRINO_CATALOG_POSTGRES or ""
        sf_cat = self.s.TRINO_CATALOG_SNOWFLAKE or ""
        db_cat = self.s.TRINO_CATALOG_DATABRICKS or ""
        pg_sch = self.s.TRINO_SCHEMA_POSTGRES or "public"
        sf_sch = self.s.TRINO_SCHEMA_SNOWFLAKE or "PUBLIC"
        db_sch = self.s.TRINO_SCHEMA_DATABRICKS or "default"
        pg_customers = f"{pg_cat}.{pg_sch}.customers"
        pg_policies = f"{pg_cat}.{pg_sch}.policies"
        pg_claims = f"{pg_cat}.{pg_sch}.claims"
        sf_customers = f"{sf_cat}.{sf_sch}.DIM_CUSTOMERS"
        sf_policies = f"{sf_cat}.{sf_sch}.FACT_POLICIES"
        sf_claims = f"{sf_cat}.{sf_sch}.FACT_CLAIMS"
        db_travelers = f"{db_cat}.{db_sch}.travelers"
        db_policies = f"{db_cat}.{db_sch}.policies"
        db_claims = f"{db_cat}.{db_sch}.claims"
        return (
            f"WITH car AS (\n"
            f"  SELECT c.customer_id, c.first_name, c.last_name, c.email,\n"
            f"         COUNT(DISTINCT p.policy_id) AS policies_count,\n"
            f"         COUNT(DISTINCT cl.claim_id) AS claims_count,\n"
            f"         COALESCE(SUM(p.premium_amount), 0) AS total_premium,\n"
            f"         MAX(cl.claim_date) AS last_claim_date\n"
            f"  FROM {pg_customers} c\n"
            f"  LEFT JOIN {pg_policies} p ON p.customer_id = c.customer_id\n"
            f"  LEFT JOIN {pg_claims} cl ON cl.policy_id = p.policy_id\n"
            f"  WHERE c.customer_id = {customer_id}\n"
            f"  GROUP BY c.customer_id, c.first_name, c.last_name, c.email\n"
            f"), house AS (\n"
            f"  SELECT c.customer_id, c.first_name, c.last_name, c.email,\n"
            f"         COUNT(DISTINCT p.policy_id) AS policies_count,\n"
            f"         COUNT(DISTINCT cl.claim_id) AS claims_count,\n"
            f"         COALESCE(SUM(p.total_annual_premium), 0) AS total_premium,\n"
            f"         MAX(cl.date_of_loss) AS last_claim_date\n"
            f"  FROM {sf_customers} c\n"
            f"  LEFT JOIN {sf_policies} p ON p.customer_id = c.customer_id\n"
            f"  LEFT JOIN {sf_claims} cl ON cl.policy_id = p.policy_id\n"
            f"  WHERE c.customer_id = {customer_id}\n"
            f"  GROUP BY c.customer_id, c.first_name, c.last_name, c.email\n"
            f"), travel AS (\n"
            f"  SELECT t.traveler_id AS customer_id, t.first_name, t.last_name, t.email_primary AS email,\n"
            f"         COUNT(DISTINCT p.policy_id) AS policies_count,\n"
            f"         COUNT(DISTINCT cl.claim_id) AS claims_count,\n"
            f"         COALESCE(SUM(p.total_premium_paid), 0) AS total_premium,\n"
            f"         MAX(cl.incident_date) AS last_claim_date\n"
            f"  FROM {db_travelers} t\n"
            f"  LEFT JOIN {db_policies} p ON p.traveler_id = t.traveler_id\n"
            f"  LEFT JOIN {db_claims} cl ON cl.traveler_id = t.traveler_id\n"
            f"  WHERE t.traveler_id = {customer_id}\n"
            f"  GROUP BY t.traveler_id, t.first_name, t.last_name, t.email_primary\n"
            f")\n"
            f"SELECT 'car' AS source, * FROM car\n"
            f"UNION ALL\n"
            f"SELECT 'house' AS source, * FROM house\n"
            f"UNION ALL\n"
            f"SELECT 'travel' AS source, * FROM travel"
        )

    def query_unified(self, customer_id: int) -> Tuple[List[str], List[Tuple]]:
        if not self.client:
            if not self.s.is_trino_configured():
                return [], []
            self.client = TrinoClient(self.s)
        sql = self.build_unified_sql(customer_id)
        cur = self.client.conn.cursor()
        cur.execute(sql)
        rows = cur.fetchall()
        cols = [d[0] for d in cur.description] if cur.description else []
        cur.close()
        return cols, rows

    def print_unified(self, customer_id: int) -> None:
        cols, rows = self.query_unified(customer_id)
        if not rows:
            print("")
            return
        w = [max(len(str(c)), max((len(str(r[i])) for r in rows), default=0)) for i, c in enumerate(cols)]
        header = " | ".join(str(c).ljust(w[i]) for i, c in enumerate(cols))
        sep = "-+-".join("".ljust(w[i], "-") for i in range(len(cols)))
        print(header)
        print(sep)
        for r in rows:
            print(" | ".join(str(v).ljust(w[i]) for i, v in enumerate(r)))
