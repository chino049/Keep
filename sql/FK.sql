select now();
select 'Query' as "sql 1";
select nc_vuln_result_packet.vuln_result_id, nc_vuln_result_head.vuln_result_id
from nc_vuln_result_packet left outer join nc_vuln_result_head
using(vuln_result_id)
where nc_vuln_result_head.vuln_result_id is NULL
or nc_vuln_result_packet.vuln_result_id is NULL;

select now();
select 'Query' as "sql 4";
select nc_app_result_banner.app_result_id, nc_app_result_head.app_result_id 
from nc_app_result_banner left outer join nc_app_result_head 
using (app_result_id)  
where nc_app_result_head.app_result_id is NULL or nc_app_result_banner.app_result_id is NULL;


select now();
select 'Query' as "sql 11";
select nc_persistent_host.persistent_host_id, nc_host_persistent_host.persistent_host_id 
from nc_persistent_host left outer join nc_host_persistent_host 
using(persistent_host_id) 
where nc_persistent_host.persistent_host_id is NULL or nc_host_persistent_host.persistent_host_id is NULL;

