from __future__ import annotations
from typing import Any, Optional
import trino
from trino.auth import BasicAuthentication
from src.settings import AppSettings


class TrinoClient:
    def __init__(self, settings: AppSettings) -> None:
        self.s = settings
        auth = None
        if self.s.TRINO_PASSWORD:
            auth = BasicAuthentication(self.s.TRINO_USERNAME or "", self.s.TRINO_PASSWORD)
        self.conn = trino.dbapi.connect(
            host=self.s.TRINO_HOST or "localhost",
            port=int(self.s.TRINO_PORT or 8080),
            user=self.s.TRINO_USERNAME or "user",
            http_scheme=self.s.TRINO_HTTP_SCHEME or "http",
            auth=auth,
        )

    def query_one(self, sql: str, params: Optional[tuple[Any, ...]] = None) -> Optional[tuple]:
        cur = self.conn.cursor()
        if params:
            cur.execute(sql, params)
        else:
            cur.execute(sql)
        row = cur.fetchone()
        cur.close()
        return row

    def query_all(self, sql: str, params: Optional[tuple[Any, ...]] = None) -> list[tuple]:
        cur = self.conn.cursor()
        if params:
            cur.execute(sql, params)
        else:
            cur.execute(sql)
        rows = cur.fetchall()
        cur.close()
        return rows

    def execute(self, sql: str) -> None:
        cur = self.conn.cursor()
        cur.execute(sql)
        cur.close()
