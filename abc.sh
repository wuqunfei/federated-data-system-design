INSTALL tributary;
LOAD tributary;

SELECT *
  FROM tributary_scan_topic('healthy',
    "bootstrap.servers" := 'd4cvv94e45lfjaeu8nrg.any.eu-west-2.mpx.prd.cloud.redpanda.com:9092',
    "security.protocol" := 'SASL_SSL',
    "sasl.mechanism" := 'SCRAM-SHA-256',
    "sasl.username" := 'doctor',
    "sasl.password" := 'Lv52vKmAlFQYYxUWZxaQkNglRMBNky'
  );