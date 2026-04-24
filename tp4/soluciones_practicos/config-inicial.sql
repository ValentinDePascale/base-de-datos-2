ALTER SYSTEM SET max_parallel_workers_per_gather = 2;
SELECT pg_reload_conf();
SHOW max_parallel_workers_per_gather;