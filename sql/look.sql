select now();
select 'Query' as "sql 1";
select nc_vuln_result_packet.vuln_result_id, nc_vuln_result_head.vuln_result_id from nc_vuln_result_packet 
left outer join nc_vuln_result_head using(vuln_result_id) where nc_vuln_result_head.vuln_result_id is NULL
 or nc_vuln_result_packet.vuln_result_id is NULL;

select now();
SELECT pg_size_pretty(pg_total_relation_size('nc_vuln_result_packet'))as "size of nc_vuln_result_packet";
SELECT pg_size_pretty(pg_total_relation_size('nc_vuln_result_head')) as "size of nc_vuln_result_head";

select now();
select 'Query' as "sql 2";
SELECT nc_vuln_result_head.audit_id, nc_audit.audit_id FROM nc_vuln_result_head LEFT OUTER JOIN nc_audit 
using (audit_id) WHERE nc_audit.audit_id is NULL or nc_vuln_result_head.audit_id is NULL 
or nc_audit.audit_id = 0 or nc_vuln_result_head.audit_id = 0;

select now();
select pg_size_pretty(pg_total_relation_size('nc_audit')) as "size of nc_audit";

select now();
select 'Query' as "sql 5";
select nc_host.audit_id, nc_audit.audit_id from nc_host left outer join nc_audit using (audit_id) where nc_host.audit_id is NULL or nc_audit.audit_id is NULL;
select now();
select pg_size_pretty(pg_total_relation_size('nc_host_persistent_host')) as "size of nc_host_persistent_host";
select pg_size_pretty(pg_total_relation_size('nc_persistent_host')) as "size of nc_persistent_host";

select now();
select 'Query' as "sql 33";
select relname,  pg_size_pretty(pg_total_relation_size(pg_class.oid)) as 
total_size, pg_size_pretty(pg_relation_size(pg_class.oid)) as size, 
last_vacuum, last_autovacuum, last_analyze, last_autoanalyze from 
pg_catalog.pg_stat_all_tables join pg_class using (relname) where relname like '%nc_%';

select now();
select 'Query' as "sql 23"
select persistent_host_id, ip_address, network_id, matched, last_best_score, dns_name, netbios_name, os_id, os_fprint, port_signature, generation_id from nc_persistent_host order by ip_address;

select now();
select 'Query' as "sql 16"
select 
nc_persistent_host.matched as phmatched, 
nc_host_persistent_host.persistent_host_id as hphh, 

nc_persistent_host.persistent_host_id as phhost, 
nc_persistent_host.ip_address as phip, 
nc_persistent_host.network_id as phnetwork, 
nc_persistent_host.dns_name as phdns,  
nc_persistent_host.netbios_name as phbios , 
nc_persistent_host.os_id as phos, 
nc_persistent_host.port_signature as phps, 
nc_persistent_host.os_fprint as phfp, 
nc_persistent_host.generation_id as phgeneration,  

nc_host_persistent_host.matchlist as hphmatchlist, 
nc_host_persistent_host.matchscore as hphmatchscore, 
nc_host_persistent_host.generation_id as hphgeneration 

from nc_persistent_host join nc_host_persistent_host using (persistent_host_id) order by ip_address;

