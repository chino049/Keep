select now();
select 'Query' as "sql 48";
select relname,  pg_size_pretty(pg_total_relation_size(pg_class.oid)) as total_size, pg_size_pretty(pg_relation_size(pg_class.oid)) as size, last_vacuum, last_autovacuum, last_analyze, last_autoanalyze from pg_catalog.pg_stat_all_tables join pg_class using (relname) where relname like '%nc_%';
select now();
select 'Query' as "sql 17";
SELECT pg_size_pretty(pg_database_size('ice'));
select now();

Check Current Active Sessions
SELECT * from pg_stat_activity where state = 'active';

Check Long-Running Queries
SELECT  pid, usename, query, state, age(clock_timestamp(), query_start) AS runtime FROM pg_stat_activity WHERE state != 'idle' ORDER BY runtime DESC;

Check Index Usage
SELECT relname AS table_name, seq_scan, idx_scan, (seq_scan + idx_scan) AS total_accesses, CASE WHEN seq_scan + idx_scan > 0 THEN ROUND(100.0 * idx_scan / (seq_scan + idx_scan), 2) ELSE 0 END AS index_usage_percent FROM pg_stat_user_tables ORDER BY index_usage_percent DESC;
	
Check Table Bloat
	SELECT
    schemaname,
    tblname,
    bs * tblpages AS real_size,
    (tblpages-est_tblpages_ff)*bs AS extra_size,
    CASE WHEN tblpages - est_tblpages_ff > 0
        THEN 100 * (tblpages - est_tblpages_ff)/tblpages::float
        ELSE 0
    END AS extra_ratio, fillfactor
FROM (
    SELECT
        ceil( relpages * bs / 8192 ) AS tblpages,
        relname AS tblname,
        nspname AS schemaname,
        bs,
        CASE WHEN relpages < ceil(( reltuples / fillfactor ) * bs / 8192 ) THEN
            ceil(( reltuples / fillfactor ) * bs / 8192 )
        ELSE
            ceil(( reltuples ) * bs / 8192 )
        END AS est_tblpages_ff, fillfactor
    FROM (
        SELECT
            fillfactor,
            reltuples,
            relpages,
            relname,
            nspname,
            current_setting('block_size')::numeric AS bs
        FROM
            pg_class c
            JOIN pg_namespace n ON n.oid = c.relnamespace
            LEFT JOIN (
                SELECT
                    CASE WHEN c.reloptions IS NOT NULL THEN
                        (regexp_matches((reloptions)::text, 'fillfactor=([0-9]+)'))[1]::integer
                    ELSE
                        100
                    END AS fillfactor,
                    oid
                FROM
                    pg_class c
            ) f ON c.oid = f.oid
        WHERE
            c.relkind = 'r'
    ) a
) b;

Check Disk Usage

SELECT pg_database.datname, pg_size_pretty(pg_database_size(pg_database.datname)) AS size FROM pg_database ORDER BY pg_database_size(pg_database.datname) DESC;

Check Query Execution Times
	SELECT
    query,
    calls,
    total_time,
    mean_time,
    min_time,
    max_time
FROM
    pg_stat_statements
ORDER BY
    total_time DESC
LIMIT 10;

Check Lock Conflicts
	
SELECT pg_database.datname, pg_size_pretty(pg_database_size(pg_database.datname)) AS size FROM pg_database ORDER BY pg_database_size(pg_database.datname) DESC;

	
	
	
pg_relation_size(relation regclass):

Returns the size of the specified table or index.
The result includes only the size of the main data fork of the relation, which essentially means the size of the table's or index's data file.
It does not include the size of associated TOAST tables, free space map, visibility map, and indexes.
Example usage:

sql
Copy code
SELECT pg_relation_size('my_table');

pg_total_relation_size(relation regclass):

Returns the total size of a table, including all associated objects.
The result includes the size of the main data fork, TOAST tables (if any), free space map, visibility map, and all associated indexes.
Essentially, it provides a comprehensive view of the storage used by the table and its associated objects.

In PostgreSQL, TOAST stands for The Oversized-Attribute Storage Technique. TOAST tables are a mechanism used by PostgreSQL to 
store large data efficiently. When a table column contains data that is too large to fit within a standard row, PostgreSQL uses TOAST to store the oversized data outside the main table's storage.

How TOAST Works
Threshold for Inlining:
PostgreSQL tries to store values in-line within the table row up to a certain size. The default threshold is typically around 2KB. 
If a data value exceeds this threshold, TOAST is used.

Compression and External Storage:
If the data is large, PostgreSQL will first try to compress the data. If the compressed data still exceeds the threshold, 
the system stores the data in a separate TOAST table. The main table will store a reference to this external data instead 
of the data itself.

TOAST Table:
A TOAST table is an automatically created auxiliary table that stores large values. Each main table can have its corresponding
TOAST table, created and managed by PostgreSQL.

Chunks:
The large data value is divided into smaller chunks, which are stored as rows in the TOAST table. This division into chunks allows
 efficient access and manipulation of the data.

Benefits of TOAST
Efficiency: By compressing and storing large data separately, TOAST helps reduce the size of the main table, leading to more 
efficient queries and index operations.
Handling Large Data: It allows PostgreSQL to handle very large data values that exceed the page size limit (usually 8KB).
Automatic Management: TOAST tables are automatically managed by PostgreSQL. Users typically do not need to interact with 
them directly, as all necessary operations are handled by the system.