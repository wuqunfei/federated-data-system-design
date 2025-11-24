import unittest
from unittest.mock import MagicMock
from src.settings import AppSettings
from src.trino_catalogs import CatalogPropertiesBuilder

class TestTrinoCatalogsLogic(unittest.TestCase):
    def test_kafka_properties_basic(self):
        settings = MagicMock(spec=AppSettings)
        settings.KAFKA_BOOTSTRAP = "kafka:9092"
        settings.KAFKA_SCHEMA_REGISTRY_URL = "http://registry:8081"
        settings.KAFKA_SECURITY_PROTOCOL = None
        settings.KAFKA_SASL_MECHANISM = None
        settings.KAFKA_SASL_USERNAME = None
        settings.KAFKA_SASL_PASSWORD = None

        builder = CatalogPropertiesBuilder(settings)
        props = builder.kafka_properties()

        expected = {
            "kafka.nodes": "kafka:9092",
            "kafka.table-description-supplier": "CONFLUENT",
            "kafka.confluent-schema-registry-url": "http://registry:8081",
        }
        self.assertEqual(props, expected)

    def test_kafka_properties_full_security(self):
        settings = MagicMock(spec=AppSettings)
        settings.KAFKA_BOOTSTRAP = "kafka:9092"
        settings.KAFKA_SCHEMA_REGISTRY_URL = "http://registry:8081"
        settings.KAFKA_SECURITY_PROTOCOL = "SASL_SSL"
        settings.KAFKA_SASL_MECHANISM = "PLAIN"
        settings.KAFKA_SASL_USERNAME = "user"
        settings.KAFKA_SASL_PASSWORD = "password"

        builder = CatalogPropertiesBuilder(settings)
        props = builder.kafka_properties()

        expected = {
            "kafka.nodes": "kafka:9092",
            "kafka.table-description-supplier": "CONFLUENT",
            "kafka.confluent-schema-registry-url": "http://registry:8081",
            "kafka.security-protocol": "SASL_SSL",
            "kafka.sasl.mechanism": "PLAIN",
            "kafka.sasl.jaas.config": 'org.apache.kafka.common.security.plain.PlainLoginModule required username="user" password="password";'
        }
        self.assertEqual(props, expected)

if __name__ == "__main__":
    unittest.main()
