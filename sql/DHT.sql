select now();
select 'Query' as "sql 13";
select ip_address, persistent_host_id, nc_host_persistent_host.host_id, network_id, dns_name, 
netbios_name, os_id,  matched, nc_host_persistent_host.generation_id, 
nc_host_persistent_host.matchlist, nc_host_persistent_host.matchscore 
from nc_persistent_host join nc_host_persistent_host 
using (persistent_host_id) order by ip_address;
select now();

select 'Query' as "sql 16";
select nc_persistent_host.matched as pmatched, nc_persistent_host.persistent_host_id 
as PHhost, nc_persistent_host.ip_address as phip, nc_persistent_host.network_id 
as phnetwork, nc_persistent_host.dns_name as phdns,  nc_persistent_host.netbios_name 
as phbios , nc_persistent_host.os_id as phos, nc_persistent_host.port_signature 
as phps, nc_persistent_host.os_fprint as phfp, nc_host_persistent_host.persistent_host_id 
as hphh, nc_host_persistent_host.matchlist 
as hphmatchlist, nc_host_persistent_host.matchscore, nc_persistent_host.generation_id 
as phgeneration,  nc_host_persistent_host.generation_id as hphgeneration 
from nc_persistent_host join nc_host_persistent_host 
using (persistent_host_id) order by ip_address;
select now();

