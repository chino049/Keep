Query 1 
select nc_vuln_result_packet.vuln_result_id, nc_vuln_result_head.vuln_result_id 
from nc_vuln_result_packet left outer join nc_vuln_result_head 
using(vuln_result_id) 
where nc_vuln_result_head.vuln_result_id is NULL 
or nc_vuln_result_packet.vuln_result_id is NULL;

select vuln_result_id  from nc_vuln_result_packet where vuln_result_id not in (select distinct vuln_result_id from nc_vuln_result_head);
 

select audit_id from nc_vuln_result_head where audit_id not in (select distinct audit_id from nc_audit);

2
SELECT nc_vuln_result_head.audit_id, nc_audit.audit_id FROM nc_vuln_result_head LEFT OUTER JOIN nc_audit
using (audit_id) WHERE nc_audit.audit_id is NULL or nc_vuln_result_head.audit_id is NULL

3
select nc_app_result_head.host_id, nc_host.host_id 
from nc_app_result_head left outer join nc_host 
on nc_app_result_head.host_id = nc_host.host_id where nc_host.host_id is NULL;

Query 4
select nc_app_result_banner.app_result_id, nc_app_result_head.app_result_id 
from nc_app_result_banner left outer join nc_app_result_head 
using (app_result_id) 
where nc_app_result_head.app_result_id is NULL or nc_app_result_banner.app_result_id is NULL;

5
select nc_host.audit_id, nc_audit.audit_id from nc_host left outer join nc_audit on nc_host.audit_id = nc_audit.audit_id where nc_host.audit_id is NULL or nc_audit.audit_id is NULL;

7
select nc_audit.status_id, nc_audit_status.status_id from nc_audit left outer join nc_audit_status on nc_audit_status.status_id = nc_audit.status_id where nc_audit.status_id is NULL or  nc_audit_status.status_id is NULL;

8
select nc_audit.scan_type_id, nc_scan_type.scan_type_id from nc_audit left outer join nc_scan_type on nc_audit.scan_type_id = nc_scan_type.scan_type_id where nc_audit.scan_type_id is NULL or nc_scan_type.scan_type_id is NULL;

9
select nc_audit.scan_profile_type_id, nc_scan_profile_type.scan_profile_type_id from nc_audit left outer join nc_scan_profile_type on nc_audit.scan_profile_type_id = nc_scan_profile_type.scan_profile_type_id where nc_audit.scan_profile_type_id is NULL or nc_scan_profile_type.scan_profile_type_id is NULL;


Query 11
select nc_persistent_host.persistent_host_id, nc_host_persistent_host.persistent_host_id 
from nc_persistent_host left outer join nc_host_persistent_host 
using(persistent_host_id) 
where nc_persistent_host.persistent_host_id is NULL or nc_host_persistent_host.persistent_host_id is NULL;

12
select nc_persistent_host_vuln.persistent_host_id, nc_persistent_host.persistent_host_id from nc_persistent_host_vuln left outer join nc_persistent_host using (persistent_host_id) where  nc_persistent_host_vuln.persistent_host_id is NULL or nc_persistent_host.persistent_host_id is NULL ;

select persistent_host_id from nc_persistent_host where persistent_host_id not in (select distinct persistent_host_id from nc_host_persistent_host );


delete  from nc_persistent_host_vuln WHERE persistent_host_id not in (select persistent_host_id from nc_persistent_host);


Query 13
select ip_address, persistent_host_id, nc_host_persistent_host.host_id, network_id, dns_name, 
netbios_name, os_id,  matched, nc_host_persistent_host.generation_id, 
nc_host_persistent_host.matchlist, nc_host_persistent_host.matchscore 
from nc_persistent_host join nc_host_persistent_host 
using (persistent_host_id) order by ip_address; 

Query 16
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

Qeury 19 - count by group
select count(*) from nc_persistent_host 
group by ip_address,network_id,generation_id 
having count(*) > 1 order by count DESC;

21
select  persistent_host_id, count(ip_address),network_id,generation_id  from nc_persistent_host group by persistent_host_id , ip_address,network_id,generation_id having count(ip_address) > 1 order by ip_address;

Query 22 - count duplicate hosts
select ip_address, count(persistent_host_id)
from nc_persistent_host
group by ip_address   
having count(persistent_host_id) > 1 order by ip_address;

Quey 23 - display in order 
select persistent_host_id, ip_address, network_id, matched, last_best_score, 
dns_name, netbios_name, os_id, os_fprint, port_signature, generation_id 
from nc_persistent_host 
order by ip_address;

Query 24 - display by group 
select persistent_host_id, ip_address, network_id, generation_id, os_id, dns_name, netbios_name, os_fprint, port_signature 
from nc_persistent_host
group by persistent_host_id, ip_address, network_id, generation_id  
order by ip_address DESC; 

select persistent_host_id, dns_name, netbios_name, ip_address, nc_os.name, nc_network.name , last_best_score from nc_persistent_host JOIN nc_os USING (os_id) join nc_network using (network_id)  where  persistent_host_id in (SELECT MAX(persistent_host_id) from nc_persistent_host group by ip_address) ;


------------------------------------
select nc_customer.name as customer_name, nc_appliance.name as DP_name, nc_appliance_status.last_update as last_checkin_time, NOW() - nc_appliance_status.last_update as time_difference from nc_customer_appliance join nc_customer using (customer_id) join nc_appliance_status using (appliance_id) join nc_appliance using (appliance_id) ;

------------------------------------
select last_host_id, dns_name, netbios_name, ip_address, nc_os.name AS "OS_NAME", nc_network.name AS "OFFICE" , last_best_score , nc_vuln_result_head.vuln_id, nc_vuln.name from nc_persistent_host JOIN nc_os USING (os_id) join nc_network using (network_id)  join nc_vuln_result_head on (nc_persistent_host.last_host_id=nc_vuln_result_head.host_id) join nc_vuln on (nc_vuln_result_head.vuln_id = nc_vuln.vuln_id )  where  last_best_score > 999 and persistent_host_id in (SELECT MAX(persistent_host_id) from nc_persistent_host group by ip_address);

-------------------------------------
SELECT relname AS table_name, pg_size_pretty(pg_relation_size(oid)) AS table_size, pg_size_pretty(pg_total_relation_size(oid)) AS total_size FROM pg_class WHERE relkind in ('r','i') ORDER BY pg_relation_size(oid) DESC;

SELECT relname, relpages FROM pg_class ORDER BY relpages DESC;

Query 17
SELECT pg_size_pretty(pg_database_size('ice'));

SELECT pg_database.datname,pg_size_pretty(pg_database_size(pg_database.datname)) FROM pg_database; 

SELECT crypt ( 'sathiya', gen_salt('md5') );


SELECT relname, age(relfrozenxid) FROM pg_class WHERE relkind = 'r';
SELECT datname, age(datfrozenxid) FROM pg_database;

select relname, last_vacuum, last_autovacuum,  last_analyze, last_autoanalyze from pg_catalog.pg_stat_all_tables;

select relname, pg_class.oid, pg_size_pretty(pg_total_relation_size(pg_class.oid)), pg_size_pretty(pg_relation_size(pg_class.oid)), last_vacuum, last_autovacuum, last_analyze from pg_catalog.pg_stat_all_tables join pg_class using (relname) ;

Query 48
select relname,  pg_size_pretty(pg_total_relation_size(pg_class.oid)) 
as total_size, pg_size_pretty(pg_relation_size(pg_class.oid)) 
as size, last_vacuum, last_autovacuum, last_analyze, last_autoanalyze 
from pg_catalog.pg_stat_all_tables join pg_class 
using (relname) where relname like '%nc_%';


-------------------------------------------
NOTEs on Database Object Size Functions

SELECT pg_size_pretty(pg_total_relation_size('nc_vuln_result_packet'));
SELECT pg_size_pretty(pg_total_relation_size('nc_vuln_result_head'));


pg_column_size(any)		int	Number of bytes used to store a particular value (possibly compressed)
pg_tablespace_size(oid) 	bigint	Disk space used by the tablespace with the specified OID
pg_tablespace_size(name) 	bigint	Disk space used by the tablespace with the specified name
pg_database_size(oid) 		bigint	Disk space used by the database with the specified OID
pg_database_size(name) 		bigint	Disk space used by the database with the specified name
pg_relation_size(oid) 		bigint	Disk space used by the table or index with the specified OID
pg_relation_size(text) 		bigint	Disk space used by the table or index with the specified name. 
			                The table name may be qualified with a schema name

SELECT pg_size_pretty(pg_relation_size('nc_vuln_result_head'));

pg_total_relation_size(oid) 	bigint	Total disk space used by the table with the specified OID, including indexes and toasted data
pg_total_relation_size(text) 	bigint	Total disk space used by the table with the specified name, including indexes and toasted data. The table name may be qualified with a schema name
pg_size_pretty(bigint) 	text	Converts a size in bytes into a human-readable format with size units

---------------
CASTING

select 1233::text::money;
----------------
REGEX

SELECT regexp_replace('52093.89'::money::text, '[$,]', '', 'g')::numeric;
----------------
select E'\\010101'::bytea;

----------------
select netbios_name from nc_persistent_host where to_tsvector('english' , netbios_name) @@ to_tsquery('english' , 'W2KPAD');
select vuln_id, name  from nc_vuln          where to_tsvector (description)             @@ to_tsquery('SMB')
SELECT * FROM pg_class  WHERE                     to_tsvector(relname) @@ to_tsquery('host');
SELECT to_tsvector('english', 'a fat  cat sat on a mat - it ate a fat rats');


INSERT INTO nc_DND_packet (packet_id, detail_digest, detail_body) select * from nc_packet order by packet_id desc limit 459663;

INSERT INTO nc_scan_schedule VALUES ( nextval('nc_scan_schedule_seq'),1,1,5,1,now(),'','','f',NULL,0,'') ;

INSERT INTO nc_scan_schedule VALUES ( nextval('nc_scan_schedule_seq'),1,1,5,1,cast(' 2010-11-22 22:11:21' as timestamp),'','','f',NULL,0,'') ;

insert into nc_trouble VALUES ( nextval('nc_trouble_seq') , 5,1,10,1,cast(' 2011-11-12 22:11:21' as timestamp),NULL,'para','le forma','holar');

alter sequence nc_audit_seq restart with 1030000;

select 'IP 360'::tsvector @@ 'IP'::tsquery;

select * from nc_version where (to_tsvector('english', ip360_version) @@ to_tsquery('english', '6.8.5'));   
select * from nc_upgrade_package where (to_tsvector('english', package) @@ to_tsquery('english', 'ontology')); 

EXPLAIN SELECT * FROM nc_version WHERE ip360_version @@ to_tsquery('6.8.6');

explain select * from nc_persistent_host;
                             QUERY PLAN                              
---------------------------------------------------------------------
 Seq Scan on nc_persistent_host  (cost=0.00..12.00 rows=1 width=894)
(1 row)

SELECT relpages, reltuples FROM pg_class WHERE relname = 'nc_persistent_host';
 relpages | reltuples 
----------+-----------
       12 |         0
(1 row)


insert into  nc_trouble_type (trouble_type_id, name, description, persistent) values ( 24, 'No Good Database Backups Available', 'Database backups are either missing or suspect.', 't' );

select nc_scan_config.scan_config_id, nc_scan_profile.name, nc_network.name, nc_appliance.name AS appliance_id, nc_scan_config.active from nc_scan_config  join nc_scan_profile using (scan_profile_id) join nc_network using (network_id) join nc_appliance on (nc_scan_config.dp_id = nc_appliance.appliance_id ) where scan_config_id between 191 and 300 order by scan_config_id DESC;

select count(*) from nc_network_range group by network_id;

select distinct counted.ip_address, nc_host.os_id, nc_os.name 
from ( select ip_address, count(os_id) 
from ( select distinct ip_address, os_id 
from nc_host 
order by ip_address ) as multiple_os 
group by ip_address ) as counted 
inner join nc_host on nc_host.ip_address = counted.ip_address
inner join nc_os on nc_host.os_id = nc_os.os_id
where count > 1;

CREATE TABLE nc_jop as (select network_id from nc_network where deleted ='f');



Query 49 bgwriter
SELECT
  (100 * checkpoints_req) / (checkpoints_timed + checkpoints_req)
    AS checkpoints_req_pct,
  pg_size_pretty(buffers_checkpoint * block_size / (checkpoints_timed +
checkpoints_req))
    AS avg_checkpoint_write,
  pg_size_pretty(block_size * (buffers_checkpoint + buffers_clean +
buffers_backend)) AS total_written,
  100 * buffers_checkpoint / (buffers_checkpoint + buffers_clean +
buffers_backend) AS checkpoint_write_pct,
  100 * buffers_backend / (buffers_checkpoint + buffers_clean +
buffers_backend) AS backend_write_pct,
  *
FROM pg_stat_bgwriter,(SELECT cast(current_setting('block_size') AS
integer)
AS block_size) AS bs;
---------------------------
SELECT vulnerability_name, cvss_score, cve_id, cve_number, count (DISTINCT host_id) AS host_count
FROM (SELECT name AS vulnerability_name, cvss_score, nc_vuln_result_head.host_id, cve_id, cve_number
FROM (SELECT nc_vuln_advisory.vuln_id, nc_vuln.name, cast (nc_vuln_advisory.advisory_id as float) 
as cvss_score, nc_vuln_cve.cve_id AS cve_id, nc_cve.cve_number AS cve_number
FROM nc_vuln_advisory JOIN nc_vuln USING (vuln_id) JOIN nc_vuln_cve 
USING (vuln_id) JOIN nc_cve USING (cve_id)
WHERE nc_vuln_advisory.advisory_publisher_id = '54' 
AND CAST (nc_vuln_advisory.advisory_id AS FLOAT) >= 7.0) 
AS subquery1 JOIN nc_vuln_result_head USING (vuln_id)
WHERE nc_vuln_result_head.audit_id = (SELECT MAX(CAST (audit_id AS INT)) 
FROM nc_vuln_result_head)) AS subquery2
GROUP BY vulnerability_name, cvss_score, cve_id, cve_number
ORDER BY cvss_score, vulnerability_name;
-----------------------
Query 50 bloat
SELECT
  current_database(), schemaname, tablename, /*reltuples::bigint, relpages::bigint, otta,*/
  ROUND(CASE WHEN otta=0 THEN 0.0 ELSE sml.relpages/otta::numeric END,1) AS tbloat,
  CASE WHEN relpages < otta THEN 0 ELSE bs*(sml.relpages-otta)::bigint END AS wastedbytes,
  iname, /*ituples::bigint, ipages::bigint, iotta,*/
  ROUND(CASE WHEN iotta=0 OR ipages=0 THEN 0.0 ELSE ipages/iotta::numeric END,1) AS ibloat,
  CASE WHEN ipages < iotta THEN 0 ELSE bs*(ipages-iotta) END AS wastedibytes
FROM (
  SELECT
    schemaname, tablename, cc.reltuples, cc.relpages, bs,
    CEIL((cc.reltuples*((datahdr+ma-
      (CASE WHEN datahdr%ma=0 THEN ma ELSE datahdr%ma END))+nullhdr2+4))/(bs-20::float)) AS otta,
    COALESCE(c2.relname,'?') AS iname, COALESCE(c2.reltuples,0) AS ituples, COALESCE(c2.relpages,0) AS ipages,
    COALESCE(CEIL((c2.reltuples*(datahdr-12))/(bs-20::float)),0) AS iotta -- very rough approximation, assumes all cols
  FROM (
    SELECT
      ma,bs,schemaname,tablename,
      (datawidth+(hdr+ma-(case when hdr%ma=0 THEN ma ELSE hdr%ma END)))::numeric AS datahdr,
      (maxfracsum*(nullhdr+ma-(case when nullhdr%ma=0 THEN ma ELSE nullhdr%ma END))) AS nullhdr2
    FROM (
      SELECT
        schemaname, tablename, hdr, ma, bs,
        SUM((1-null_frac)*avg_width) AS datawidth,
        MAX(null_frac) AS maxfracsum,
        hdr+(
          SELECT 1+count(*)/8
          FROM pg_stats s2
          WHERE null_frac<>0 AND s2.schemaname = s.schemaname AND s2.tablename = s.tablename
        ) AS nullhdr
      FROM pg_stats s, (
        SELECT
          (SELECT current_setting('block_size')::numeric) AS bs,
          CASE WHEN substring(v,12,3) IN ('8.0','8.1','8.2') THEN 27 ELSE 23 END AS hdr,
          CASE WHEN v ~ 'mingw32' THEN 8 ELSE 4 END AS ma
        FROM (SELECT version() AS v) AS foo
      ) AS constants
      GROUP BY 1,2,3,4,5
    ) AS foo
  ) AS rs
  JOIN pg_class cc ON cc.relname = rs.tablename
  JOIN pg_namespace nn ON cc.relnamespace = nn.oid AND nn.nspname = rs.schemaname AND nn.nspname <> 'information_schema'
  LEFT JOIN pg_index i ON indrelid = cc.oid
  LEFT JOIN pg_class c2 ON c2.oid = i.indexrelid
) AS sml
ORDER BY wastedbytes DESC;



------------------------------------
example of table with sequence, primary key and trigger

create sequence nc_system_license_seq;

create table nc_system_license 
(license_id bigint not null default nextval('nc_system_license_seq'), licence_product varchar(255) 
not null,  product_type varchar(32) not null);

alter table nc_system_license 
add constraint nc_system_license_pkey primary key (license_id);
  NOTICE:  ALTER TABLE / ADD PRIMARY KEY will create implicit index "nc_system_license_pkey" for table "nc_system_license"

alter table nc_system_license_client 
add constraint foreign_key_01 foreign key (license_id) 
references nc_system_license (license_id) on delete cascade on update cascade;


create trigger  nc_persistent_host_d_tr after delete on nc_persistent_host
for each row execute procedure nc_persistent_host_delete();

create or replace function  nc_persistent_host_delete()
returns trigger as ' begin insert into nc_persistent_host_del (persistent_host_id, network_id, .... )' language 'plpgsql';

--------------------------

SELECT '$' || CAST(AVG(price) AS int4) AS 'average price' FROM products;

average price

--------

$345
--------------
echo "SELECT * FROM products WHERE price > 40;" | psql -H shop

CREATE TABLE comments (id, serial, pro_id int4, comment text [ ] );

CREATE TABLE son(gender char(1)) INHERITS (father, mother);


REVOKE ALL on "nc_system_license_client" from PUBLIC;
GRANT ALL on "nc_system_license_client" to "postgres";
GRANT INSERT,UPDATE,DELETE,SELECT on "nc_system_license_client" to GROUP "ids";

select title, coalesce (male_lead, female_lead, 'Unknown') - This will replace NULL values with the value  Unknown

create or replace function nc_scan_config_to_value(xml) returns bigint as $$
  -- bitmasked value associated with discribiminating between Discovery, Assessment, and Webapp scans
  -- $1 is scan configuration in XML format
  -- return value is sum of values: 1 => discovery, 2 => assessment, 4 => webapp
  -- discovery will be set for assessment (vulnerability) and webapp scans
  select
    (
      (case when nc_xml_elem_attrib_found('scanProfile', 'type', 'discovery', $1) then 1 else 0 end) +
      (case when nc_xml_elem_attrib_found('vulnScan' , 'value', 'on', $1) then 2 else 0 end) +
      (case when nc_xml_elem_attrib_found('webAppScan' , 'value', 'on', $1) then 4 else 0 end)
     )::bigint



create or replace function    nc_version_ok(integer, integer)
returns    boolean as
 '
    ----------------------------------------------------------------------
    --    Ensure that concurrency control has not been violated.
    ----------------------------------------------------------------------
    declare
        v_old_version    alias for    $1;
        v_new_version    alias for    $2;
        l_delta        integer        := 1;
        l_return    boolean        := ''f'';
    begin
        --------------------------------------------------------------
        --    Compare the old and new document versions.
        --------------------------------------------------------------
        if (v_new_version - v_old_version = l_delta) then
            l_return := ''t'';
        end if;

        --------------------------------------------------------------
        --    Return.
        --------------------------------------------------------------
        return l_return;
    end;
'
language 'plpgsql';


------------------

create sequence nc_system_license_seq;

create table nc_system_license (        license_id      bigint             not null             default nextval('nc_system_license_seq'),
        lic_product varchar(255) not null,  lic_product_type    varchar(32)         not null,  lic_product_timestamp       date       not null,
        lic_customer_name   varchar(255)     not null,    lic_offset_days     int     null  );
alter table nc_system_license    add constraint nc_system_license_pkey    primary key    (license_id);

----------

alter table     nc_system_license_usage add constraint     foreign_key_01 foreign key     (license_id) references     nc_system_license (license_id)
on delete cascade     on update cascade;

-----------
update nc_persistent_host set owner_id = 80 from  nc_os where nc_persistent_host.os_id=nc_os.os_id and (nc_os.name like '%AIX%' or nc_os.name like '%BSD%' or nc_os.name like '%Unix%');
-----------

Insert a single quote in a string

update nc_vuln set description = 'DESCRIPTION
                                          : The host has SSH credentials that are weak, default, or easily guessable.  Weak SSH credentials could allow an attacker to gain escalated privileges or access to sensitive information.  A list of the weak credentials that were detected can be found in the ''Configuration'' tab of the Technical Analysis Report for each affected host. <html> <body> <p>My paragraph.</p> </body> </html>
                                          : 
                                          : SOLUTION
                                          : Use strong, hard-to-guess SSH credentials on hosts that provide SSH access. Implement access controls on network routing devices and firewalls.' where vuln_id = 9756;

--------------------
select setval('nc_audit_seq', xxxxxx)   

select start_date, end_date, (start_date - end_date) as times, scan_profile_id,  status_id, audit_id  from nc_audit where network_id = 4 and scan_profile_id = 6 order by audit_id ;

select nc_network.name, start_date, end_date, (end_date - start_date ) as times, scan_profile_id,  status_id, audit_id from nc_audit join nc_network using(network_id) where status_id = 4 and network_id = 8 and scan_profile_id = 5 and nc_network.deleted = 'f' order by audit_id;

update nc_customer set enable_email_system = 'f', mail_server = NULL where customer_id = 1;

------timestamps------------
select current_timestamp - interval '60 days';

select persistent_host_id, last_seen  from nc_persistent_host where last_seen < (current_timestamp - interval '75 days') order by last_seen;

-------------FRB-----------
query to see backup of database/archive/log configuration parameters

select config_name as "database configuration name", config_value as "database configuration value"  from nc_database_config_view ;

select config_name as "backup configuration name", config_value as "backup configuration value"  from nc_backup_config_view ;


select config_name as "archive configuration name", config_value as "archive configuration value"  from nc_archive_config_view ;

select config_name as "log files configuration name", config_value as "log files configuration value"  from nc_logfiles_config_view ;

Additional queries

select config_value as "VnE Name " from nc_console_config where config_name ='hostname';

select config_value as "VnE IP Address " from nc_console_config where config_name ='first_ip';
------------------------ROCHE
select  nc_scan_config.scan_config_id, nc_scan_config.scan_profile_id, nc_scan_profile.name, nc_scan_config.network_id, nc_network.name, nc_scan_config.dp_id, nc_appliance.appliance_id from nc_scan_config join nc_scan_profile using(scan_profile_id) join nc_network using(network_id) join nc_appliance on (nc_appliance.appliance_id = nc_scan_config.dp_id) where nc_network.deleted = 'f';


------------------------purecloud

select audit_id, nc_audit_status.status, nc_network.name, nc_scan_profile.name, (end_date - start_date) as time from nc_audit join nc_network using (network_id) join nc_audit_status using (status_id) join nc_scan_profile using (scan_profile_id) order by audit_id ;


select host_id, nc_host.name, ip_address, nc_os.name, audit_id, host_score, custom_score , time_stamp from nc_host join nc_os using (os_id) where audit_id = 596 order by time_stamp;

-------------------------dp loap
 select (now()- start_date) as delta , audit_id, nc_audit_status.status , nc_scan_profile.name , nc_network.name, nc_appliance.name from nc_audit join nc_appliance on dp_id=appliance_id join nc_network using (network_id) join nc_scan_profile using (scan_profile_id) join nc_audit_status using (status_id) where status_id != 4 and status_id !=3 

----------------------
select nc_customer.name as customer, nc_network.network_id as network_id, nc_network.name as name, nc_audit.audit_id as audit_id, count(nc_host) as count_hosts, nc_audit.end_date as end_date, nc_network.customer_id as customer_id from nc_audit inner join nc_network using (network_id) inner join nc_host using (audit_id) inner join nc_customer on nc_network.customer_id = nc_customer.customer_id where nc_network.deleted = 'f' and nc_audit.scan_profile_id IN (select scan_profile_id from nc_scan_profile where config like '%<vulnScan value=\"on\">%') and status_id=4 and scan_type_id in (1,2) group by nc_customer.name, nc_network.customer_id, nc_network.name, nc_network.network_id, nc_audit.audit_id, nc_audit.end_date

--------------------- us senate
select scan_profile_id, name, active, deleted from nc_scan_profile where deleted = 'f' and active = 'f';
select network_id, name, active, deleted from nc_network where deleted = 'f' and active = 'f';

select nc_scan_profile.scan_profile_id, nc_scan_profile.name as SP_name, nc_scan_profile.active as SP_active, nc_network.network_id, nc_network.name as Net_name, nc_network.active as Net_active, nc_scan_config.active as Schedule_active from nc_scan_config full join nc_network using(network_id) full join nc_scan_profile using (scan_profile_id) where nc_scan_profile.active ='f' and nc_scan_profile.deleted ='f' or nc_network.active ='f' and nc_network.deleted ='f';

select nc_network.name as Net_name, nc_scan_profile.name as SP_name, nc_network.active as Net_active, nc_scan_profile.active as SP_active, nc_scan_config.active as Schedule_active from nc_scan_config full join nc_network using(network_id) full join nc_scan_profile using (scan_profile_id) where nc_scan_profile.active ='f' and nc_scan_profile.deleted ='f' or nc_network.active ='f' and nc_network.deleted ='f' order by nc_scan_config.active;


 select nc_scan_config.scan_config_id, nc_network.active as Net_active, nc_scan_profile.active as SP_active, nc_scan_config.active as Schedule_active from nc_scan_config full join nc_network using(network_id) full join nc_scan_profile using (scan_profile_id) where nc_scan_config.active = 't' and (nc_scan_profile.active ='f' and nc_scan_profile.deleted ='f' or nc_network.active ='f' and nc_network.deleted ='f');


update nc_scan_config set active = 'f' where nc_scan_config.scan_config_id = (select nc_scan_config.scan_config_id from nc_scan_config full join nc_network using(network_id) full join nc_scan_profile using (scan_profile_id) where nc_scan_config.active = 't' and (nc_scan_profile.active ='f' and nc_scan_profile.deleted ='f' or nc_network.active ='f' and nc_network.deleted ='f'));



----------------------------------

 ssh -i ~/qakey root@$3 "/hive/vendor/pgsql/bin/psql -U postgres -d ice -c 'select distinct  all_app.application_id, all_app.name from (select application_id, name from nc_application union all select application_id, name from nc_application_protocol) as all_app inner join nc_app_result_head using(application_id) inner join nc_host using(host_id) inner join nc_audit using(audit_id) where nc_audit.audit_id=$1'" >scan1Apps.txt

 ssh -i ~/qakey root@$3 "/hive/vendor/pgsql/bin/psql -U postgres -d ice -c 'select nc_host_datum_type.name from nc_audit inner join nc_host using(audit_id) inner join nc_host_datum using(host_id) inner join nc_host_datum_type using(host_datum_type_id) where audit_id=$1 ORDER BY nc_host_datum_type.name'" > scan1HCC.txt

 ssh -i ~/qakey root@$4 "/hive/vendor/pgsql/bin/psql -U postgres -d ice -c 'SELECT distinct nc_vuln.vuln_id, name FROM nc_vuln_result_head, nc_audit, nc_vuln WHERE nc_audit.audit_id=$2 AND nc_vuln_result_head.audit_id = nc_audit.audit_id AND nc_vuln_result_head.vuln_id = nc_vuln.vuln_id ORDER BY vuln_id'" > scan2Vulns.txt

 ssh -i ~/qakey root@$4 "/hive/vendor/pgsql/bin/psql -U postgres -d ice -c 'select distinct  all_app.application_id, all_app.name from (select application_id, name from nc_application union all select application_id, name from nc_application_protocol) as all_app inner join nc_app_result_head using(application_id) inner join nc_host using(host_id) inner join nc_audit using(audit_id) where nc_audit.audit_id=$2'" >scan2Apps.txt

+ssh -i ~/qakey root@$3 "/hive/vendor/pgsql/bin/psql -U postgres -d ice -c 'select nc_host_datum_type.name from nc_audit inner join nc_host using(audit_id) inner join nc_host_datum using(host_id) inner join nc_host_datum_type using(host_datum_type_id) where audit_id=$2 ORDER BY nc_host_datum_type.name'" > scan2HCC.txt

-------------
UPDATE leagues
SET league_id = permissions_id
FROM permissions
WHERE permissions.league_key = leagues.league_key;
------------------------------

1. How to find the largest table in the postgreSQL database?
SELECT relname, relpages FROM pg_class ORDER BY relpages DESC;

If you want only the first biggest table in the postgres database then append the above query with limit as:
SELECT relname, relpages FROM pg_class ORDER BY relpages DESC limit 1;

    relname – name of the relation/table.
    relpages - relation pages ( number of pages, by default a page is 8kb )
    pg_class – system table, which maintains the details of relations
    limit 1 – limits the output to display only one row.

2. How to calculate postgreSQL database size in disk ?
pg_database_size is the function which gives the size of mentioned database. It shows the size in bytes.
SELECT pg_database_size('geekdb');

If you want it to be shown pretty, then use pg_size_pretty function which converts the size in bytes to human understandable format.
SELECT pg_size_pretty(pg_database_size('geekdb'));

3. How to calculate postgreSQL table size in disk ?
This is the total disk space size used by the mentioned table including index and toasted data. You may be interested in knowing only the size of the table excluding the index then use the following command.
SELECT pg_size_pretty(pg_total_relation_size('big_table'));

How to find size of the postgreSQL table ( not including index ) ?
Use pg_relation_size instead of pg_total_relation_size as shown below.
SELECT pg_size_pretty(pg_relation_size('big_table'));

4. How to view the indexes of an existing postgreSQL table ?
Syntax: # \d table_name

5. How to specify postgreSQL index type while creating a new index on a table ?
By default the indexes are created as btree. You can also specify the type of index during the create index statement as shown below.
Syntax: CREATE INDEX name ON table USING index_type (column);
 CREATE INDEX test_index ON numbers using hash (num);

6. How to work with postgreSQL transactions ?
How to start a transaction ?
 BEGIN -- start the transaction.
How to rollback or commit a postgreSQL transaction ?
All the operations performed after the BEGIN command will be committed to the postgreSQL database only you execute the commit command. Use rollback command to undo all the transactions before it is committed.
 ROLLBACK -- rollbacks the transaction.
 COMMIT -- commits the transaction.

7. How to view execution plan used by the postgreSQL for a SQL query ?
EXPLAIN query;

8. How to display the plan by executing the query on the server side ?
This executes the query in the server side, thus does not shows the output to the user. But shows the plan in which it got executed.
EXPLAIN ANALYZE query;

9. How to generate a series of numbers and insert it into a table ?
This inserts 1,2,3 to 1000 as thousand rows in the table numbers.
INSERT INTO numbers (num) VALUES ( generate_series(1,1000));

10. How to count total number of rows in a postgreSQL table ?
This shows the total number of rows in the table.
select count(*) from table;
Following example gives the total number of rows with a specific column value is not null.
select count(col_name) from table;
Following example displays the distinct number of rows for the specified column value.
select count(distinct col_name) from table;

11. How can I get the second maximum value of a column in the table ?
First maximum value of a column
# select max(col_name) from table;
Second maximum value of a column
# SELECT MAX(num) from number_table where num  < ( select MAX(num) from number_table );

12. How can I get the second minimum value of a column in the table ?
First minimum value of a column
# select min(col_name) from table;
Second minimum value of a column
# SELECT MIN(num) from number_table where num > ( select MIN(num) from number_table );

13. How to view the basic available datatypes in postgreSQL ?
Below is the partial output that displays available basic datatypes and it’s size.

14. How to redirect the output of postgreSQL query to a file?
# \o output_file
# SELECT * FROM pg_class;
The output of the query will be redirected to the “output_file”. After the redirection is enabled, the select command will not display the output in the stdout. To enable the output to the stdout again, execute the \o without any argument as mentioned below.
# \o

As explained in our earlier article, you can also backup and restore postgreSQL database using pg_dump and psql.

15. Storing the password after encryption.
PostgreSQL database can encrypt the data using the crypt command as shown below. This can be used to store your custom application username and password in a custom table.
# SELECT crypt ( 'sathiya', gen_salt('md5') );
PostgreSQL crypt function Issue:
The postgreSQL crypt command may not work on your environment and display the following error message.
ERROR:  function gen_salt("unknown") does not exist
HINT:  No function matches the given name and argument types.
         You may need to add explicit type casts.
PostgreSQL crypt function Solution:
To solve this problem, installl the postgresql-contrib-your-version package and execute the following command in the postgreSQL prompt.
# \i /usr/share/postgresql/8.1/contrib/pgcrypto.sql


---------------------
SELECT nc_audit.audit_id, nc_audit.network_id, nc_audit.status_id, nc_audit.scan_profile_id, nc_audit.dp_id, nc_audit.scan_type_id, nc_network.name as network_name, to_char(nc_audit.start_date, 'MM/DD/YYYY HH24:MI') AS start_date, date_part('epoch',start_date) AS start_epoch, CASE WHEN end_date is NULL THEN to_char(now() - start_date, 'HH24:MI:SS' ) ELSE to_char(now() - start_date, 'HH24:MI:SS' ) END as duration, to_char(nc_audit.end_date, 'MM/DD/YYYY HH24:MI') AS end_date, date_part('epoch',end_date) AS end_epoch, nc_scan_profile.name AS scan_profile_name, nc_appliance.name AS appliance_name, nc_audit_status.status AS status_name, nc_scan_type.name AS scan_type_name, to_char(nc_audit.start_date, 'MM/DD/YYYY HH24:MI') AS start_date_formatted, to_char(nc_audit.end_date, 'MM/DD/YYYY HH24:MI') AS end_date_formatted, nc_audit.scan_profile_type_id FROM nc_audit INNER JOIN nc_network USING (network_id) INNER JOIN nc_scan_profile USING (scan_profile_id) INNER JOIN nc_appliance ON (nc_audit.dp_id = nc_appliance.appliance_id) INNER JOIN nc_audit_status USING (status_id) INNER JOIN nc_scan_type USING (scan_type_id) WHERE audit_id = 21;

SELECT nc_audit.audit_id, to_char(nc_audit.start_date, 'MM/DD/YYYY HH24:MI') AS start_date, date_part('epoch',start_date) AS start_epoch, CASE WHEN end_date is NULL THEN to_char(now() - start_date, 'HH24:MI:SS' ) ELSE to_char(now() - start_date, 'HH24:MI:SS' ) END as duration, to_char(nc_audit.end_date, 'MM/DD/YYYY HH24:MI') AS end_date, date_part('epoch',end_date) AS end_epoch, to_char(nc_audit.start_date, 'MM/DD/YYYY HH24:MI') AS start_date_formatted, to_char(nc_audit.end_date, 'MM/DD/YYYY HH24:MI') AS end_date_formatted, nc_audit.scan_profile_type_id FROM nc_audit  WHERE audit_id = 21;


SELECT DISTINCT nc_audit.audit_id as audit_id, nc_audit.network_id, nc_audit.status_id, nc_audit.scan_profile_id, nc_audit.dp_id, nc_audit.scan_type_id, nc_network.name as network_name, LOWER(nc_network.name) AS order_network, to_char(nc_audit.start_date, 'MM/DD/YYYY HH24:MI') AS start_date, date_part('epoch',start_date) AS start_epoch, to_char(nc_audit.end_date, 'MM/DD/YYYY HH24:MI') AS end_date, date_part('epoch',end_date) AS end_epoch, CASE WHEN end_date is NULL THEN to_char(now() - start_date, 'HH24:MI:SS' ) ELSE to_char(now() - start_date, 'HH24:MI:SS' ) END AS duration, nc_scan_profile.name as scan_profile_name, LOWER(nc_scan_profile.name) AS order_scan_profile, CASE WHEN nc_appliance.name is NULL THEN 'Unknown' ELSE nc_appliance.name END as appliance_name, LOWER(CASE WHEN nc_appliance.name is NULL THEN 'Unknown' ELSE nc_appliance.name END) AS order_appliance, nc_audit_status.status as status_name, nc_scan_type.name as scan_type_name, to_char(nc_audit.start_date, 'MM/DD/YYYY HH24:MI') as start_date_formatted, to_char(nc_audit.end_date, 'MM/DD/YYYY HH24:MI') as end_date_formatted, nc_audit.ontology_version, nc_scan_profile_type.scan_profile_type_id, nc_scan_profile_type.name as scan_profile_type_name from nc_audit inner join nc_network using (network_id) inner join nc_scan_profile using (scan_profile_id) left outer join nc_appliance on (nc_audit.dp_id = nc_appliance.appliance_id) left outer join nc_appliance_status using (appliance_id) inner join nc_audit_status using (status_id) inner join nc_scan_type using (scan_type_id) inner join nc_scan_profile_type on (nc_audit.scan_profile_type_id = nc_scan_profile_type.scan_profile_type_id) where audit_id = 21;


SELECT DISTINCT nc_audit.audit_id as audit_id, to_char(nc_audit.start_date, 'MM/DD/YYYY HH24:MI') AS start_date, date_part('epoch',start_date) AS start_epoch, to_char(nc_audit.end_date, 'MM/DD/YYYY HH24:MI') AS end_date, date_part('epoch',end_date) AS end_epoch, CASE WHEN end_date is NULL THEN to_char(now() - start_date, 'HH24:MI:SS' ) ELSE to_char(now() - start_date, 'HH24:MI:SS' ) END AS duration, to_char(nc_audit.start_date, 'MM/DD/YYYY HH24:MI') as start_date_formatted, to_char(nc_audit.end_date, 'MM/DD/YYYY HH24:MI') as end_date_formatted from nc_audit  where audit_id = 21;


select extract ('epoch' from timestamp '2009-08-12')

select to_timestamp(1250028000);


SELECT nc_audit.audit_id as audit_id, nc_audit.network_id, nc_audit.status_id, nc_audit.scan_profile_id, nc_audit.dp_id, nc_audit.scan_type_id, nc_network.name AS network_name, LOWER(nc_network.name) AS order_network, to_char(nc_audit.start_date, 'MM/DD/YYYY HH00:MI') AS start_date, start_epoch, to_char(nc_audit.end_date, 'MM/DD/YYYY HH00:MI') AS end_date, date_part('epoch',end_date) as end_epoch, CASE WHEN end_date is NULL THEN to_char(now() - start_date, 'HH00:MI:SS' ) ELSE to_char(now() - start_date, 'HH00:MI:SS' ) END as duration, nc_scan_profile.name as scan_profile_name, LOWER(nc_scan_profile.name) AS order_scan_profile, CASE WHEN nc_appliance.name is NULL THEN 'Unknown' ELSE nc_appliance.name END as appliance_name, LOWER(CASE WHEN nc_appliance.name is NULL THEN 'Unknown' ELSE nc_appliance.name END) AS order_appliance, nc_audit_status.status as status_name, nc_scan_type.name AS scan_type_name, to_char(nc_audit.start_date, 'MM/DD/YYYY HH00:MI') AS start_date_formatted, to_char(nc_audit.end_date, 'MM/DD/YYYY HH00:MI') AS end_date_formatted, nc_audit.ontology_version, nc_scan_profile_type.scan_profile_type_id, nc_scan_profile_type.name as scan_profile_type_name FROM ( SELECT nc_audit.*,date_part('epoch',start_date) AS start_epoch from nc_audit inner join nc_network using (network_id) INNER JOIN nc_scan_profile using (scan_profile_id)WHERE nc_network.customer_id = 1::bigint AND nc_network.deleted = false AND nc_scan_profile.deleted = false AND nc_audit.status_id IN (4,2,3) ORDER BY "start_epoch" DESC offset 0 limit 25) as nc_audit INNER JOIN nc_network USING (network_id) INNER JOIN nc_scan_profile using (scan_profile_id) LEFT OUTER JOIN nc_appliance ON (nc_audit.dp_id = nc_appliance.appliance_id) LEFT OUTER JOIN nc_appliance_status USING (appliance_id) INNER JOIN nc_audit_status USING (status_id) INNER JOIN nc_scan_type USING (scan_type_id) INNER JOIN nc_scan_profile_type ON (nc_audit.scan_profile_type_id = nc_scan_profile_type.scan_profile_type_id) WHERE nc_network.customer_id = 1::bigint AND nc_network.deleted = false AND nc_scan_profile.deleted = false ORDER BY "start_epoch" DESC;

---------------------objectapixx
select((exprs((column("customer_id"))), from(table("nc_motd")), where(column("customer_id") == 1)));
select customer_id from nc_motd where customer_id = 1);
insert((target(table("nc_motd")),values((
       nv("customer_id", constant(request_->getObjRef().getInstance())),
       nv("msg_welcome", constant("")),
       nv("msg_logout", constant("")) )) ));

------------------
 select msg_welcome from nc_motd where customer_id = (select customer_id from nc_customer where master = 't');

update nc_motd set msg_welcome = (select msg_welcome from nc_motd where customer_id = (select customer_id from nc_customer where master = 't'))
-----------
select count((select service where service = 'profiler')) as profiler, count((select service where service = 'imageserver')) as imageserver from nc_appliance_log where service in ('profiler', 'imageserver') and (info like ' Data (opaque pointer):%' or info like ' Recv bfufer:%' or info like ' Writable:%' or info like ' Readable:%' or info like ' Bytes written:%' or info like ' Bytes read:%' or info like ' Callback:%' or info like ' Peer port:%' or info like ' Peer addr:%' or info like ' Bind port:%' or info like ' Bind addr:%' or info like ' SSL:%' or info like ' SSL CTX:%' or info like ' Fd:%' or info like ' Opts:%' or info like ' Type:%' or info like ' Dead:%' or info like ' Error:%' or info like ' State:%' or info like '%SSL error connecting to%' or info = '');
-----------
How to view active locks
select t.relname,l.locktype,page,virtualtransaction,pid,mode,granted from pg_locks l, pg_stat_all_tables t where l.relation=t.relid order by relation asc;

Active queries and open connections
SELECT datname,usename,procpid,client_addr,waiting,query_start,current_query FROM pg_stat_activity;


CREATE TEMPORARY TABLE _nc_scan_configs_ AS SELECT sc.scan_config_id as uid, sc.active, sp.scan_profile_id, sp.name AS scan_profile, sp.active AS scan_profile_active, n.network_id, n.name AS network, n.active AS network_active, a.name as appliance, a.appliance_id AS appliance_id, CASE WHEN (date_part('epoch', now()) - date_part('epoch', appliance_status.last_update)) < 600 THEN true ELSE false END AS appliance_active, au.status_id AS audit_status, au.audit_id FROM nc_scan_config sc JOIN nc_scan_profile sp USING(scan_profile_id) JOIN nc_network n USING(network_id) JOIN nc_appliance a ON (a.appliance_id = sc.dp_id) JOIN nc_appliance_status appliance_status USING(appliance_id) LEFT OUTER JOIN nc_audit au ON ( sc.network_id = au.network_id AND sc.dp_id = au.dp_id AND sc.scan_profile_id = au.scan_profile_id AND au.status_id IN(1,5,6,7)) WHERE sp.deleted = false AND n.deleted = false AND sp.deleted = false AND n.customer_id = 1
 	

SELECT *, CASE WHEN network_active = 't' AND appliance_active = 't' AND scan_profile_active = 't' AND active = 't' THEN CASE WHEN audit_status = 1 THEN 'In Progress'::text WHEN audit_status IN(5,6) THEN 'Paused'::text WHEN audit_status = 7 THEN 'Suspended'::text WHEN audit_status is NULL THEN 'Pending'::text END ELSE NULL END as status FROM _nc_scan_configs_ WHERE true OFFSET 0 LIMIT 25


                        SELECT
                                sc.scan_config_id as uid,
                                sp.scan_profile_id,
                                sp.name AS scan_profile,
                                n.network_id,
                                n.name AS network,
                                n.active AS network_active,
                                a.name AS appliance,
                                a.appliance_id,
                                CASE
                                        WHEN (date_part('epoch', now()) - date_part('epoch', astatus.last_update)) < 20  THEN true
                                        ELSE false
                                END AS appliance_active,
                                sc.active,
                                CASE
                                        WHEN sp.active = true THEN false
                                        ELSE true
                                END AS disabled
                        FROM nc_scan_config sc
                                JOIN nc_scan_profile sp USING(scan_profile_id)
                                JOIN nc_network n USING(network_id)
                                JOIN nc_appliance a ON (a.appliance_id = sc.dp_id)
                                LEFT OUTER JOIN nc_appliance_status astatus USING(appliance_id)
                                        WHERE sp.deleted = 'f' AND n.deleted = 'f' AND
                                                n.customer_id = 1  ;
----------------
SELECT  sc.scan_config_id,  NULL as scan_schedule_id,  sc.network_id,  sc.scan_profile_id,  sc.dp_id AS appliance_id,  sc.active,  NULL as login_id,  NULL as scan_time,  '' as range,  NULL as audit_id,  '' as rejected,  0 as fault_code,  '' as fault_string,  'f' as fault,  'f' as debug_mode,  au.status_id FROM nc_scan_config sc LEFT OUTER JOIN nc_audit au  ON (  sc.network_id = au.network_id AND  sc.dp_id = au.dp_id AND  sc.scan_profile_id = au.scan_profile_id AND  au.status_id IN (1, 5, 6, 7)) UNION ALL SELECT  NULL as scan_config_id,  ns.scan_schedule_id,  ns.network_id,  ns.scan_profile_id,  ns.appliance_id,  't' as active,  ns.login_id,  ns.scan_time,  ns.range,  ns.audit_id,  ns.rejected,  ns.fault_code,  ns.fault_string,  ns.fault,  ns.debug_mode,  au.status_id FROM nc_scan_schedule ns LEFT OUTER JOIN nc_audit au  ON (au.audit_id = ns.audit_id)

----------------
insert into nc_appliance VALUES (nextval('nc_appliance_seq'), 1, 20, 'CopyofAs', '10.64.4.27' , 2, '10.64.4.27', '6232-C05B-2913-994D-BC0E-4097-1398-9999')

------------
 COPY public.nc_packet (packet_id, detail_digest, detail_body) TO stdout;

select  TO_CHAR((current_date - interval '1 month' * a),'YYYY-MM') AS mmyyyy FROM generate_series(1,60,1) AS s(a)

--------------

SELECT audit_id, DATE_PART('day', end_date::timestamp - start_date::timestamp) * 24 + DATE_PART('hour', end_date::timestamp - start_date::timestamp) + DATE_PART('minute', end_date::timestamp - start_date::timestamp) as mine from nc_audit;

---------------

get aspl cves and calculate socre

 select cve.cve_number, cve.name, vcve.vuln_id, v.name   from nc_cve as cve join nc_vuln_cve as vcve on cve.cve_id = vcve.cve_id join nc_vuln as v on vcve.vuln_id = v.vul
n_id where cve.cve_number like '%CVE-2017-2950%';

select cve.cve_number, cve.name, vcve.vuln_id, v.name, v.cvssv3, sqrt(DATE_PART('day', now() - v.date)) * (r.level ! / (s.level * s.level)) as score, DATE_PART('day', now() - v.date) as t, r.level as r, s.level as s, v.date
from nc_cve as cve
join nc_vuln_cve as vcve on cve.cve_id = vcve.cve_id
join nc_vuln as v on vcve.vuln_id = v.vuln_id
join nc_risk as r on r.risk_id = v.risk_id
join nc_skill as s on s.skill_id = v.skill_id
where cve.cve_number like '%CVE-2018-2628%';

or use function nc_vuln_score(vuln_id)

