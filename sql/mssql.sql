select count(vuln_id) as total_vulns_201206 from fndappvuln join audit_tbl on (audit_tbl.audit_id = fndappvuln.audit_app_id) where end_date >= '20120601' and end_date <= '20120630' ;
select count(vuln_id) as total_vulns_201207 from fndappvuln join audit_tbl on (audit_tbl.audit_id = fndappvuln.audit_app_id) where end_date >= '20120701' and end_date <= '20120731' ;
select count(vuln_id), month(end_date) from fndappvuln join audit_tbl on (audit_tbl.audit_id = fndappvuln.audit_app_id) group by month(end_date);
select start_date, end_date, month(end_date) from fndappvuln join audit_tbl on (audit_tbl.audit_id = fndappvuln.audit_app_id) where audit_tbl.audit_id = 444321;
select vuln_id from fndappvuln join audit_tbl on (audit_tbl.audit_id = fndappvuln.audit_app_id) where end_date >= '20120601' and end_date <= '20120630' and vuln_id not in (select vuln_id from fndappvuln join audit_tbl on (audit_tbl.audit_id = fndappvuln.audit_app_id) where end_date >= '20120701' and end_date <= '20120731');


SELECT CAST(ROUND(AVG(CAST(s.host_count as REAL)), 0) AS INT), ISNULL(osg.name, 'Others'), DATENAME(mm, atb.end_date) + '/' + convert(varchar(4),DATEPART(yyyy, atb.end_date)), DATEADD(mm, DATEDIFF(mm,0,atb.end_date), 0) AS enddate
FROM summary_os s
INNER JOIN audit_tbl atb ON s.vne_id = atb.vne_id AND s.audit_id = atb.audit_id
LEFT JOIN sih_os_group osg ON s.os_group_id = osg.id
WHERE ( atb.end_date > '04/14/2014 17:49:15' )
AND ( atb.end_date < '10/11/2014 17:49:15' )
AND ( (atb.aud_status IS NULL OR atb.aud_status='Finished') )
AND ( atb.upload_in_progress != 1 )
GROUP BY DATEADD(mm, DATEDIFF(mm,0,atb.end_date), 0), DATENAME(mm, atb.end_date) + '/' + convert(varchar(4),DATEPART(yyyy, atb.end_date)), ISNULL(osg.name, 'Others')
ORDER BY ISNULL(osg.name, 'Others'), enddate



SELECT DATENAME(mm, atb.end_date) + '/' + convert(varchar(4),DATEPART(yyyy, atb.end_date)), CAST(ROUND(AVG(CAST(s.vuln_count as REAL)), 0) AS INT)
AS avg_vulncount, SUM(CAST(s.vuln_count as BIGINT)) AS sum_vulncount, SUM(CAST(s.vscore_total as BIGINT)) AS avg_score, 
CAST(ROUND(AVG(CAST(s.vuln_exposure_count as REAL)), 0) AS INT) AS exposure_count, 
CAST(ROUND(AVG(CAST(s.vuln_lavail_count as REAL)), 0) AS INT) AS lavail_count, 
CAST(ROUND(AVG(CAST(s.vuln_laccess_count as REAL)), 0) AS INT) AS laccess_count, 
CAST(ROUND(AVG(CAST(s.vuln_lpriv_count as REAL)), 0) AS INT) AS lpriv_count,
CAST(ROUND(AVG(CAST(s.vuln_ravail_count as REAL)), 0) AS INT) AS ravail_count, 
CAST(ROUND(AVG(CAST(s.vuln_rpriv_count as REAL)), 0) AS INT) AS rpriv_count,
CAST(ROUND(AVG(CAST(s.vuln_raccess_count as REAL)), 0) AS INT) AS raccess_count, DATEADD(mm, DATEDIFF(mm,0,atb.end_date), 0) AS enddate
FROM summary s INNER JOIN audit_tbl atb ON s.vne_id = atb.vne_id AND s.audit_id = atb.audit_id WHERE ( atb.end_date > '04/11/2014 02:02:08' )
AND ( (atb.aud_status IS NULL OR atb.aud_status='Finished') ) AND ( atb.upload_in_progress != 1 )
GROUP BY DATEADD(mm, DATEDIFF(mm,0,atb.end_date), 0), DATENAME(mm, atb.end_date) + '/' + convert(varchar(4),DATEPART(yyyy, atb.end_date))
ORDER BY enddate;



--select getdate(184*24*60*60);

--"DATEADD(mm, DATEDIFF(mm,0,$col), 0)"
select dateadd(month, datediff(month,0,'20141011'), 0) as begMonth1, dateadd(month, datediff(month,0,'20111230'), 0) as begMonth2;
select dateadd(month, datediff(month,0,'19770914'), 0) as begMonth3, dateadd(month, datediff(month,0,'18741112'), 0) as begMonth4, dateadd(month, datediff(month,0,'19971010'), 0) as begMonth5;

-------------------------
DATEDIFF - returns the count (signed int) of the specified datepart boundaries crossed between the specified startdate and the enddate
datediff (datepart, startdate, enddate)
datepart -  is the part of the startdate and enddate that specifies the type of boundary crossed
year, yy,yyyy
quarter,qq,q
month,mm.m
dayofyear,dy,y
day,dd,d
week,wk,w
hour, hh
minute, mi,n

select datediff(month,0,'20141011'); 
1377
select datediff(month,'20131020','20141011');
12
select datediff(month,'20140112',0);
-1368
select datediff(yy,0,'20141011'); 
114
select DATEDIFF(yy,'1900-01-01', '2014-01-01');
114
select datediff(yyyy,'20131020','20141011');
1
select datediff(year,'20140112',0);
-114
-----------------

DATEADD - returns a date with the specified number interval (signed integer) to a specified datapart of that date;
dateadd (datepart, number, date)

select dateadd(yy, 0, 0);
1900-01-01 00:00:00.000
select dateadd(yy, 114, 0);
2014-01-01 00:00:00.000
select dateadd(month, 1577, 0);
2031-06-01 00:00:00.000
select dateadd(mm, 0, 1577);
1904-04-27 00:00:00.000
select dateadd(yy, 150, 0);
2050-01-01 00:00:00.000
select dateadd(year, 0, 150);
1900-05-31 00:00:00.000



select DATEADD(mm, DATEDIFF(mm,0,'2014/10/15 10:33:05'), 0), DATENAME(mm, '2014/10/15 10:33:05.000') + '/' + convert(varchar(4),DATEPART(yyyy, '2014/10/15 10:33:05.000'));

select DATEADD(mm, DATEDIFF(mm,0,'2014/10/05 11:13:05'), 31), DATENAME(mm, DATEADD(mm, DATEDIFF(mm,0,'2014/10/05 11:13:05'), 31)) + '/' + convert(varchar(4),DATEPART(yyyy, DATEADD(mm, DATEDIFF(mm,0,'2014/10/05 11:13:05'), 31)));

select DATEADD(mm, DATEDIFF(mm,0,'2014/1/30 10:39:05'), 31), DATENAME(mm, DATEADD(mm, DATEDIFF(mm,0,'2014/1/30 10:39:05'), 31)) + '/' + convert(varchar(4),DATEPART(yyyy, DATEADD(mm, DATEDIFF(mm,0,'2014/1/30 10:39:05'), 31)));

select DATEADD(mm, DATEDIFF(mm,0,'2014/7/31 20:23:05'), 31), DATENAME(mm, DATEADD(mm, DATEDIFF(mm,0,'2014/7/31 20:23:05'), 31)) + '/' + convert(varchar(4),DATEPART(yyyy, DATEADD(mm, DATEDIFF(mm,0,'2014/7/31 20:23:05'), 31)));



----------------
select datediff(month, 0, '19001020') as stillnose, datediff(month, 0, '19990101') as stillnose, datediff(month, 0, '20111020') as stillnose;
select dateadd(month, 1380, 0) as morenose;

--"DATENAME(mm, $col) + '/' + convert(varchar(4),DATEPART(yyyy, $col))")
select datename(month, '20140101') + '/' + convert(varchar(4),DATEPART(yyyy, '20140101')) as begdateFormatted;

select dateadd(day,45,getdate()) as add45daysdate , dateadd(month, 3, getdate()) as add3monthsdate;
select datediff(day,getdate(),getdate()+30) as diffplus30Date, datediff(day,getdate(),getdate()-60) as diffminus60date;
select getdate() as todaysdate, datediff(month,2014, getdate()) as Ydate;
select DATEDIFF(year, 1, 2010) as diff;
select datediff(month,0, 201401);
--select dateadd(month, datediff(month,0,getdate()), 0) as Xdate;
SELECT datepart(MONTH,getdate()) as jm;     
select convert(varchar, getdate(), 100) ;
select convert(varchar, getdate(), 8) ;
select convert(varchar, getdate(), 10) ;
select convert(varchar, getdate(), 20) ;
select convert(varchar(7), getdate(), 126) ;
select SYSDATETIME() as datee;

----------------from pm file 
 SELECT DATENAME(mm, atb.end_date) + '/' + convert(varchar(4),DATEPART(yyyy, atb.end_date)) as month, SUM(s.vuln_count) AS vuln_count
        FROM summary s
        INNER JOIN audit_tbl atb ON s.vne_id = atb.vne_id AND s.audit_id = atb.audit_id
        WHERE ( DATEADD(mm, DATEDIFF(mm,0,atb.end_date), 0) >= '04/18/2014 05:41:53' )
        GROUP BY DATEADD(mm, DATEDIFF(mm,0,atb.end_date), 0), DATENAME(mm, atb.end_date) + '/' + convert(varchar(4),DATEPART(yyyy, atb.end_date))
----------------
select DATENAME(mm, '2012-06-08 11:34:35.000') + '/' + convert(varchar(4),DATEPART(yyyy, '2012-06-08 11:34:35.000')) as month_year;
month_year
June/2012
select DATENAME(mm, '2012-06-08 11:34:35.000') as month;
month
June
select DATENAME(yy, '2012-06-08 11:34:35.000') as yy;
yy
2012
select DATENAME(dd, '2012-06-08 11:34:35.000') as dd;
dd
8
select convert(varchar(4),DATEPART(yyyy, '2012-06-08 11:34:35.000')) as year;
year
2012
elect convert(varchar(4),DATEPART(year, '2012-10-08 11:34:35.000')) as year;
year
2012
select convert(varchar(2),DATEPART(mm, '2012-10-08 11:34:35.000')) as month;
month
10
select convert(varchar(2),DATEPART(month, '2012-10-08 11:34:35.000')) as month;
month 
10
select DATEPART(month, '2012-10-08 11:34:35.000') as month;
month 
10
select convert(varchar(2),DATEPART(day, '2012-10-08 11:34:35.000')) as day;
day
8
select convert(varchar(2),DATEPART(d, '2012-10-08 11:34:35.000')) as day;
day 
8




-------------------
\SELECT DATENAME(mm, atb.end_date) + '/' + convert(varchar(4),DATEPART(yyyy, atb.end_date)) as month_and_year, 
CAST(ROUND(SUM(CAST(s.vuln_count as REAL)),0) as int) as total_vulns,
--CAST(ROUND(AVG(CAST(s.vuln_count as REAL)), 0) AS INT) AS avg_vulncount, 
--SUM(CAST(s.vuln_count as BIGINT)) AS sum_vulncount, 
--SUM(CAST(s.vscore_total as BIGINT)) AS avg_score, 
--CAST(ROUND(AVG(CAST(s.vuln_exposure_count as REAL)), 0) AS INT) AS exposure_count,
--CAST(ROUND(AVG(CAST(s.vuln_lavail_count as REAL)), 0) AS INT) AS lavail_count, 
--CAST(ROUND(AVG(CAST(s.vuln_laccess_count as REAL)), 0) AS INT) AS laccess_count, 
--CAST(ROUND(AVG(CAST(s.vuln_lpriv_count as REAL)), 0) AS INT) AS lpriv_count, 
--CAST(ROUND(AVG(CAST(s.vuln_ravail_count as REAL)), 0) AS INT) AS ravail_count, 
--CAST(ROUND(AVG(CAST(s.vuln_rpriv_count as REAL)), 0) AS INT) AS rpriv_count, 
--CAST(ROUND(AVG(CAST(s.vuln_raccess_count as REAL)), 0) AS INT) AS raccess_count, 
DATEADD(mm, DATEDIFF(mm,0,atb.end_date), 0) AS enddate FROM summary s
INNER JOIN audit_tbl atb ON s.vne_id = atb.vne_id AND s.audit_id = atb.audit_id
WHERE ( atb.end_date > '04/1/2014' ) AND ( (atb.aud_status IS NULL OR atb.aud_status='Finished') ) 
AND ( atb.upload_in_progress != 1 )
GROUP BY DATEADD(mm, DATEDIFF(mm,0,atb.end_date), 0), 
DATENAME(mm, atb.end_date) + '/' + convert(varchar(4),DATEPART(yyyy, atb.end_date)) 
ORDER BY enddate;
----
SELECT DATENAME(mm, audit_tbl.end_date) + '/' + convert(varchar(4),DATEPART(yyyy, audit_tbl.end_date)) as month_and_year
from audit_tbl;
select DATEADD(mm, DATEDIFF(mm,0,audit_tbl.end_date), 0) AS enddate from audit_tbl;

------------



 SELECT DATENAME(mm, atb.end_date) + '/' + convert(varchar(4),DATEPART(yyyy, atb.end_date)), CAST(ROUND(AVG(CAST(s.vuln_count as REAL)), 0) AS INT) AS avg_vulncount, SUM(CAST(s.vuln_count as BIGINT)) AS sum_vulncount, SUM(CAST(s.vscore_total as BIGINT)) AS avg_score, CAST(ROUND(AVG(CAST(s.vuln_exposure_count as REAL)), 0) AS INT) AS exposure_count, CAST(ROUND(AVG(CAST(s.vuln_lavail_count as REAL)), 0) AS INT) AS lavail_count, CAST(ROUND(AVG(CAST(s.vuln_laccess_count as REAL)), 0) AS INT) AS laccess_count, CAST(ROUND(AVG(CAST(s.vuln_lpriv_count as REAL)), 0) AS INT) AS lpriv_count, CAST(ROUND(AVG(CAST(s.vuln_ravail_count as REAL)), 0) AS INT) AS ravail_count, CAST(ROUND(AVG(CAST(s.vuln_rpriv_count as REAL)), 0) AS INT) AS rpriv_count, CAST(ROUND(AVG(CAST(s.vuln_raccess_count as REAL)), 0) AS INT) AS raccess_count, DATEADD(mm, DATEDIFF(mm,0,atb.end_date), 0) AS enddate
        FROM summary s
        INNER JOIN audit_tbl atb ON s.vne_id = atb.vne_id AND s.audit_id = atb.audit_id
        WHERE ( atb.end_date > '04/14/2014 03:45:29' )
        AND ( (atb.aud_status IS NULL OR atb.aud_status='Finished') )
        AND ( atb.upload_in_progress != 1 )
        GROUP BY DATEADD(mm, DATEDIFF(mm,0,atb.end_date), 0), DATENAME(mm, atb.end_date) + '/' + convert(varchar(4),DATEPART(yyyy, atb.end_date))
        ORDER BY enddate

-------------------------
select DATENAME(mm, audit_tbl.end_date) + '/' + convert(varchar(4),DATEPART(yyyy, audit_tbl.end_date)), 
sum(summary.vuln_count) as vuln_count 
from summary
inner join audit_tbl on (summary.vne_id = audit_tbl.vne_id and summary.audit_id = audit_tbl.audit_id)
group by  DATEADD(mm, DATEDIFF(mm,0,audit_tbl.end_date), 0), 
DATENAME(mm, audit_tbl.end_date) + '/' + convert(varchar(4),DATEPART(yyyy, audit_tbl.end_date));


---------------------------
This is mine to get vuln count--------------

SELECT DATENAME(mm, atb.end_date) + '/' + convert(varchar(4),DATEPART(yyyy, atb.end_date)) as month, SUM(s.vuln_count) AS vuln_count
FROM summary s
INNER JOIN audit_tbl atb ON s.vne_id = atb.vne_id AND s.audit_id = atb.audit_id
WHERE ( DATEADD(mm, DATEDIFF(mm,0,atb.end_date), 0) >= '04/18/2014 05:17:01' ) AND ( atb.aud_status IS NULL OR atb.aud_status='Finished' ) AND ( atb.upload_in_progress != 1 )
GROUP BY DATEADD(mm, DATEDIFF(mm,0,atb.end_date), 0), DATENAME(mm, atb.end_date) + '/' + convert(varchar(4),DATEPART(yyyy, atb.end_date))
order by month;

This is the one created for the chart-------

SELECT DATENAME(mm, atb.end_date) + '/' + convert(varchar(4),DATEPART(yyyy, atb.end_date)), CAST(ROUND(AVG(CAST(s.vuln_count as REAL)), 0) AS INT) AS avg_vulncount, 
SUM(CAST(s.vuln_count as BIGINT)) AS sum_vulncount, SUM(CAST(s.vscore_total as BIGINT)) AS avg_score, CAST(ROUND(AVG(CAST(s.vuln_exposure_count as REAL)), 0) AS INT) AS exposure_count, 
CAST(ROUND(AVG(CAST(s.vuln_lavail_count as REAL)), 0) AS INT) AS lavail_count, CAST(ROUND(AVG(CAST(s.vuln_laccess_count as REAL)), 0) AS INT) AS laccess_count, 
CAST(ROUND(AVG(CAST(s.vuln_lpriv_count as REAL)), 0) AS INT) AS lpriv_count, CAST(ROUND(AVG(CAST(s.vuln_ravail_count as REAL)), 0) AS INT) AS ravail_count, 
CAST(ROUND(AVG(CAST(s.vuln_rpriv_count as REAL)), 0) AS INT) AS rpriv_count, CAST(ROUND(AVG(CAST(s.vuln_raccess_count as REAL)), 0) AS INT) AS raccess_count, 
DATEADD(mm, DATEDIFF(mm,0,atb.end_date), 0) AS enddate
FROM summary s
INNER JOIN audit_tbl atb ON s.vne_id = atb.vne_id AND s.audit_id = atb.audit_id
WHERE ( atb.end_date > '04/18/2014 05:17:02' ) AND ( (atb.aud_status IS NULL OR atb.aud_status='Finished') ) AND ( atb.upload_in_progress != 1 ) 
GROUP BY DATEADD(mm, DATEDIFF(mm,0,atb.end_date), 0), DATENAME(mm, atb.end_date) + '/' + convert(varchar(4),DATEPART(yyyy, atb.end_date))
ORDER BY enddate

------------------------Run as group
SELECT DATENAME(mm, atb.end_date) + '/' + convert(varchar(4),DATEPART(yyyy, atb.end_date)) as month, SUM(s.vuln_count) AS vuln_count
FROM JesusO.dbo.summary s
INNER JOIN JesusO.dbo.audit_tbl atb ON s.vne_id = atb.vne_id AND s.audit_id = atb.audit_id
WHERE (atb.end_date >= '04/18/2014 05:17:01') 
AND ( atb.aud_status IS NULL OR atb.aud_status='Finished' ) AND ( atb.upload_in_progress != 1 )
GROUP BY DATEADD(mm, DATEDIFF(mm,0,atb.end_date), 0), 
DATENAME(mm, atb.end_date) + '/' + convert(varchar(4),DATEPART(yyyy, atb.end_date))
order by month;

select SUM(s.vuln_count) AS vuln_count_July_2014
FROM JesusO.dbo.summary s
INNER JOIN JesusO.dbo.audit_tbl atb ON s.vne_id = atb.vne_id AND s.audit_id = atb.audit_id
AND ( atb.aud_status IS NULL OR atb.aud_status='Finished' ) AND ( atb.upload_in_progress != 1 )
WHERE (atb.end_date >= '07/01/2014 00:00:00' and atb.end_date <= '07/31/2014 23:59:59');

select SUM(s.vuln_count) AS vuln_count_Oct_2014
FROM JesusO.dbo.summary s
INNER JOIN JesusO.dbo.audit_tbl atb ON s.vne_id = atb.vne_id AND s.audit_id = atb.audit_id
AND ( atb.aud_status IS NULL OR atb.aud_status='Finished' ) AND ( atb.upload_in_progress != 1 )
WHERE (atb.end_date >= '10/01/2014 00:00:00' and atb.end_date <= '10/31/2014 23:59:59');

--select DATENAME(mm, atb.end_date) + '/' + convert(varchar(4),DATEPART(yyyy, atb.end_date)) as month, count(vuln_id) from JesusO.dbo.host_scan hs 
--select current_timestamp;
select count(vuln_id) as vuln_count_Oct2014_diff_SQL from JesusO.dbo.host_scan hs
join JesusO.dbo.fndappvuln fav on fav.hostscan_guid = hs.guid
join JesusO.dbo.audit_tbl atb on atb.audit_id = hs.audit_id
AND ( atb.aud_status IS NULL OR atb.aud_status='Finished' ) AND ( atb.upload_in_progress != 1 )
where (atb.end_date >= '10/01/2014 00:00:00' and atb.end_date <= '10/31/2014 23:59:59')
--select current_timestamp;
--order by month;

select vuln_id, atb.audit_id  from JesusO.dbo.host_scan hs 
join JesusO.dbo.fndappvuln fav on fav.hostscan_guid = hs.guid
join JesusO.dbo.audit_tbl atb on atb.audit_id = hs.audit_id
AND ( atb.aud_status IS NULL OR atb.aud_status='Finished' ) AND ( atb.upload_in_progress != 1 )
where (atb.end_date >= '10/01/2014 00:00:00' and atb.end_date <= '10/31/2014 23:59:59') 
and vuln_id not in ( select vuln_id from JesusO.dbo.host_scan hs
join JesusO.dbo.fndappvuln fav on fav.hostscan_guid = hs.guid
join JesusO.dbo.audit_tbl atb on atb.audit_id = hs.audit_id
AND ( atb.aud_status IS NULL OR atb.aud_status='Finished' ) AND ( atb.upload_in_progress != 1 ) 
where ( convert(varchar, atb.end_date) >= '11/01/2014 00:00:00' and convert(varchar, atb.end_date) <= '11/31/2014 23:59:59' ) );
----------

select hs.guid, hs.audit_id, hs.host_score from JesusO.dbo.host_scan hs
join JesusO.dbo.audit_tbl atb on atb.audit_id = hs.audit_id AND ( atb.aud_status IS NULL OR atb.aud_status='Finished' ) AND ( atb.upload_in_progress != 1 )
where ( atb.end_date >= '09/01/2014 00:00:00' and atb.end_date <= '09/30/2014 23:59:59');

select guid, host_guid, audit_id  from JesusO.dbo.host_scan where audit_id >= 443653 and audit_id <= 443660 order by host_guid;

select hs.host_guid, hs.host_score, atb.scanprofile_name, atb.audit_id, atb.end_date from JesusO.dbo.host_scan hs
join JesusO.dbo.audit_tbl atb on atb.audit_id = hs.audit_id AND ( atb.aud_status IS NULL OR atb.aud_status='Finished' ) AND ( atb.upload_in_progress != 1 )
where  atb.end_date >= '09/01/2014 00:00:00' and atb.end_date <= '09/30/2014 23:59:59' 
and hs.host_guid in ( select hs.host_guid from JesusO.dbo.host_scan hs
join JesusO.dbo.audit_tbl atb on atb.audit_id = hs.audit_id AND atb.aud_status IS NULL OR atb.aud_status='Finished' AND  atb.upload_in_progress != 1 
where  atb.end_date >= '10/01/2014 00:00:00' and atb.end_date <= '10/31/2014 23:59:59' ) 
and hs.host_score > 0
order by host_guid;

select hs.host_guid, hs.host_score, fav.vuln_id, atb.scanprofile_name, atb.audit_id, atb.start_date from JesusO.dbo.host_scan hs
join JesusO.dbo.audit_tbl atb on atb.audit_id = hs.audit_id AND ( atb.aud_status IS NULL OR atb.aud_status='Finished' ) AND ( atb.upload_in_progress != 1 )
join JesusO.dbo.fndappvuln fav on fav.hostscan_guid = hs.host_guid
where  atb.end_date >= '09/01/2014 00:00:00' and atb.end_date <= '09/30/2014 23:59:59' 
and hs.host_guid in ( select hs.host_guid from JesusO.dbo.host_scan hs
join JesusO.dbo.audit_tbl atb on atb.audit_id = hs.audit_id AND atb.aud_status IS NULL OR atb.aud_status='Finished' AND  atb.upload_in_progress != 1 
where  atb.end_date >= '10/01/2014 00:00:00' and atb.end_date <= '10/31/2014 23:59:59' ) 
and hs.host_score > 0
order by host_guid;

------------------
select v.host_guid, vuln_id, hs.audit_id as last_vuln_audit, hs2.audit_id as last_audit
from ( select host_guid, vuln_id, max(hostscan_guid) as last_seen_hs_guid from JesusO.dbo.fndappvuln fav
join JesusO.dbo.host_scan hs on hs.guid = fav.hostscan_guid group by host_guid, vuln_id ) v
join ( select host_guid, max(guid) as last_scan_hs_guid from JesusO.dbo.host_scan hs group by host_guid ) h on h.host_guid  = v.host_guid
join JesusO.dbo.host_scan hs on hs.guid = v.last_seen_hs_guid
join JesusO.dbo.host_scan hs2 on hs2.guid = h.last_scan_hs_guid
join JesusO.dbo.audit_tbl on hs.audit_id = audit_tbl.audit_id 
where last_seen_hs_guid < last_scan_hs_guid
and audit_tbl.end_date >= '10/01/2014 00:00:00' and audit_tbl.end_date <= '10/31/2014 23:59:59'
order by vuln_id;
--------------
select vuln_id 
from ( select host_guid, vuln_id, max(hostscan_guid) as last_seen_hs_guid from JesusO.dbo.fndappvuln fav
join JesusO.dbo.host_scan hs on hs.guid = fav.hostscan_guid group by host_guid, vuln_id ) v
join ( select host_guid, max(guid) as last_scan_hs_guid from JesusO.dbo.host_scan hs group by host_guid ) h on h.host_guid  = v.host_guid
join JesusO.dbo.host_scan hs on hs.guid = v.last_seen_hs_guid
join JesusO.dbo.host_scan hs2 on hs2.guid = h.last_scan_hs_guid
join JesusO.dbo.audit_tbl on hs.audit_id = audit_tbl.audit_id 
where last_seen_hs_guid < last_scan_hs_guid
and audit_tbl.end_date >= '10/01/2014 00:00:00' and audit_tbl.end_date <= '10/31/2014 23:59:59'A
order by vuln_id;
---------------------------

select count(host_count) 
from JesusO.dbo.summary s
join JesusO.dbo.audit_tbl atb on (atb.audit_id = s.audit_id and s.vne_id = atb.vne_id) 
where atb.end_date >= '05/01/2014 00:00:00.000' and atb.end_date <= '05/31/2014 23:59:59.000'
AND ( (atb.aud_status IS NULL OR atb.aud_status='Finished') )
AND ( atb.upload_in_progress != 1 );


select count(host_count) 
from JesusO.dbo.summary s
join JesusO.dbo.audit_tbl atb on (atb.audit_id = s.audit_id and s.vne_id = atb.vne_id) 
where atb.end_date >= '04/21/2014 15:48:36' and atb.end_date <= '04/30/2014 23:59:59'
AND ( (atb.aud_status IS NULL OR atb.aud_status='Finished') )
AND ( atb.upload_in_progress != 1 );


SELECT DATENAME(mm, atb.end_date) + '/' + convert(varchar(4),DATEPART(yyyy, atb.end_date)) as hosts_month, 
COUNT(s.host_count) as hosts_count, DATEADD(mm, DATEDIFF(mm,0,atb.end_date), 0) AS henddate
FROM JesusO.dbo.summary s
INNER JOIN JesusO.dbo.audit_tbl atb ON s.vne_id = atb.vne_id AND s.audit_id = atb.audit_id
WHERE ( atb.end_date > '04/21/2014 15:48:36' )
AND ( (atb.aud_status IS NULL OR atb.aud_status='Finished') )
AND ( atb.upload_in_progress != 1 )
GROUP BY DATEADD(mm, DATEDIFF(mm,0,atb.end_date), 0), DATENAME(mm, atb.end_date) + '/' + convert(varchar(4),DATEPART(yyyy, atb.end_date))
ORDER BY henddate

-----------------
select count(distinct hs.host_guid) from JesusO.dbo.host_scan hs 
join JesusO.dbo.audit_tbl atb on (hs.audit_id = atb.audit_id)
where atb.end_date > '05/01/2014' and atb.end_date < '05/31/2014';

select count(distinct hs.host_guid) from JesusO.dbo.host_scan hs 
join JesusO.dbo.audit_tbl atb on (hs.audit_id = atb.audit_id)
where atb.end_date > '06/01/2014' and atb.end_date < '06/30/2014';

select COUNT(distinct hs.host_guid) from JesusO.dbo.host_scan hs 
join JesusO.dbo.audit_tbl atb on (hs.audit_id = atb.audit_id)
where (atb.end_date > '06/01/2014' and atb.end_date < '06/30/2014')
except
select distinct hs2.host_guid from JesusO.dbo.host_scan hs2 
join JesusO.dbo.audit_tbl atb2 on (hs2.audit_id = atb2.audit_id)
where atb2.end_date > '05/01/2014' and atb2.end_date < '05/31/2014';
---------------

--select count(distinct hs.host_guid) from JesusO.dbo.host_scan hs 
--join JesusO.dbo.audit_tbl atb on (hs.audit_id = atb.audit_id)
--where atb.end_date > '04/01/2014' and atb.end_date < '04/30/2014';

--select count(distinct hs.host_guid) from JesusO.dbo.host_scan hs 
--join JesusO.dbo.audit_tbl atb on (hs.audit_id = atb.audit_id)
--where atb.end_date > '05/01/2014' and atb.end_date < '05/31/2014';

--select count(distinct hs.host_guid) from JesusO.dbo.host_scan hs 
--join JesusO.dbo.audit_tbl atb on (hs.audit_id = atb.audit_id)
--where atb.end_date > '06/01/2014' and atb.end_date < '06/30/2014';

--select count(distinct hs.host_guid) from JesusO.dbo.host_scan hs 
--inner join JesusO.dbo.audit_tbl atb on (hs.audit_id = atb.audit_id)
--where atb.end_date > '05/01/2014' and atb.end_date < '5/31/2014'
--except (
--select distinct hs2.host_guid from JesusO.dbo.host_scan hs2 
--inner join JesusO.dbo.audit_tbl atb2 on (hs2.audit_id = atb2.audit_id)
--where atb2.end_date > '04/01/2014' and atb2.end_date < '04/30/2014');

--s-elect count(distinct hs.host_guid) from JesusO.dbo.host_scan hs 
--inner join JesusO.dbo.audit_tbl atb on (hs.audit_id = atb.audit_id)
--where atb.end_date > '05/01/2014' and atb.end_date < '5/31/2014'
--and exists ( 
--select distinct hs2.host_guid from JesusO.dbo.host_scan hs2 
--inner join JesusO.dbo.audit_tbl atb2 on (hs2.audit_id = atb2.audit_id)
--where atb2.end_date > '04/01/2014' and atb2.end_date < '04/30/2014');

select count(distinct hs.host_guid) from JesusO.dbo.host_scan hs 
inner join JesusO.dbo.audit_tbl atb on (hs.audit_id = atb.audit_id)
where atb.end_date > '05/01/2014' and atb.end_date < '5/31/2014'
and not exists ( 
select distinct hs2.host_guid from JesusO.dbo.host_scan hs2 
inner join JesusO.dbo.audit_tbl atb2 on (hs2.audit_id = atb2.audit_id)
where atb2.end_date > '04/01/2014' and atb2.end_date < '04/30/2014');

-------------------
select count(distinct hs.host_guid) from JesusO.dbo.host_scan hs 
inner join JesusO.dbo.audit_tbl atb on (hs.audit_id = atb.audit_id)
where atb.end_date > '08/01/2014' and atb.end_date < '8/31/2014'
except (
select distinct hs2.host_guid from JesusO.dbo.host_scan hs2 
inner join JesusO.dbo.audit_tbl atb2 on (hs2.audit_id = atb2.audit_id)
where atb2.end_date > '07/01/2014' and atb2.end_date < '07/31/2014');

-------------------
select count(distinct hs.host_guid) from JesusO.dbo.host_scan hs 
inner join JesusO.dbo.audit_tbl atb on (hs.audit_id = atb.audit_id)
where atb.end_date > '09/01/2014' and atb.end_date < '9/30/2014'
except (
select distinct hs2.host_guid from JesusO.dbo.host_scan hs2 
inner join JesusO.dbo.audit_tbl atb2 on (hs2.audit_id = atb2.audit_id)
where atb2.end_date > '08/01/2014' and atb2.end_date < '08/31/2014');
------------------

select count(distinct hs.host_guid) from JesusO.dbo.host_scan hs 
inner join JesusO.dbo.audit_tbl atb on (hs.audit_id = atb.audit_id)
where atb.end_date > '10/01/2014' and atb.end_date < '10/31/2014'
except ( 
select distinct hs2.host_guid from JesusO.dbo.host_scan hs2 
inner join JesusO.dbo.audit_tbl atb2 on (hs2.audit_id = atb2.audit_id)
where atb2.end_date > '09/01/2014' and atb2.end_date < '09/30/2014');

---------------------
select top 50 fav.hostscan_guid, h.persistent_id, h.IP, fav.vuln_id, fav.vuln_name, fav.port, fav.protocol, fav.advisories, 
va.advisory_key, va.advisory_url, fav.max_cvss_base_score , vc.cve_id, vc.cve_num, cvss.ncircle, cvss.vector, cvss.score
from JesusO.dbo.fndappvuln fav  
join JesusO.dbo.host h on (fav.hostscan_guid = h.host_id)
join JesusO.dbo.vuln_advisory_url va on (fav.vuln_id = va.vuln_id)
join JesusO.dbo.vuln_cve vc on ( fav.vuln_id = vc.vuln_id) 
join JesusO.dbo.vuln_cvss_base cvss on (fav.vuln_id = cvss.vuln_id);
-----------------------------
select distinct fav.vuln_name as vuln_name, fav.vuln_id as vuln_id
from host_scan hs 
inner join fndappvuln fav on (hs.guid = fav.hostscan_guid)

select h.hostname as host_name, h.IP as host_ip, fav.port as vuln_port, fav.protocol as vuln_prot
from host_scan hs
inner join fndappvuln fav on (hs.guid = fav.hostscan_guid)
inner join host h on (h.guid = hs.host_guid)
inner join audit_tbl adt on (hs.audit_id = adt.audit_id and hs.vne_id = adt.vne_id)
where fav.vuln_id = 91054;

-----------------------------------------------------------------------------------------------------------
## Readme for the Security Intelligence Hub SQL Query Reports
## Author: Tripwire, Inc.
## Date:  June 2, 2015
## Copyright: ©2015 Tripwire


#License
By downloading and using this document, you agree to the following terms:  

The information in this document and the queries herein are not supported under any Tripwire support program or service.

These queries are provided "as is" without warranty of any kind either expressed or implied, including but not limited to 
the implied warranties of merchantability and/or fitness for a particular purpose, and/or non-infringement. 
You agree that Tripwire does not in any way warrant the accuracy, reliability, completeness, usefulness, non-infringement,
or quality of these queries and that Tripwire shall not be liable or responsible in any way for any losses or damage of any
kind, including lost profits or other indirect or consequential damages, relating to your use of or reliance upon these
queries.


#Overview
The queries provided in this file are example reports that are executed in the new "SQL Report CSV" template in Security
Intelligence Hub (SIH) version 2.7. These queries assume familiarity with SQL and are written specifically for Microsoft
SQL Server, if SIH is deployed on Oracle, these queries may need to be modified (especially where a date calculation is used)


These queries include:

1. Vulnerabilities_Published_In_Last_30_Days
   Description:  Shows hosts that are vulnerable to recently published vulnerabilities
   Note: You can adjust the time period in the query.

2. Last_Full_Scan_Per_Network_by_Network_Group
   Description: Displays the last time, host count, vulnerability count and total risk score, that a network was successfully
   fully scanned (either by an on demand or scheduled scan) 
   Note: Null values (a network has never been scanned) have been represented by "-1" to distinguish between scanned networks
   that return a "0" value.

3. Last_Scan_Cred_Count_by_Network
   Description: Displays a comparison of hosts to the number of authenticated hosts and total vulnerability scores

4. IP360_Cred_Failures
   Description: Displays authentication failures and type by IP
   Note: This report pairs well with the Last_Scan_Cred_Count_By_Network query

5. CCM_Hosts_Without_Successful_Auth
   Description: Displays all CCM unauthenticated hosts

6. Host_Data_Items_By_Audit
   Description: Displays all host configuration items gathered from a single audit in an exportable format.
   Note: You must provide the IP360 VNE ID and audit ID for the audit you wish to display.


# Note for SIH and Oracle installations.  
These queries assume familiarity with SQL and are written specifically for Microsoft SQL Server, if SIH is deployed on Oracle, these queries may need to be modified (especially where
a date calculation is used)


#INSTALLATION:
1. Simply copy and paste the query in its entirety into "SQL Report CSV" Template provided with Security Intelligence Hub version 2.7.
   The text will be pasted into the "SQL Query Text" prompt.
2. You can save and schedule this report as required.

=====================================================================================
SQL QUERIES
=====================================================================================

1. Vulnerabilities_Published_In_Last_30_Days

select distinct a.vne_id, a.network_name, h.guid, h.ip, h.hostname, h.netbiosname, h.os, fav.app_name, fav.vuln_name, v.publication_date, v.vuln_score, fav.max_cvss_base_score, v.risk, v.skill
from host h
join host_scan hs on h.guid = hs.host_guid
join audit_tbl a on a.audit_id = hs.audit_id and a.vne_id = hs.vne_id
join fndappvuln fav on fav.hostscan_guid = hs.guid
join vulnerability v on v.vuln_id = fav.vuln_id
where
        -- You can change the time period from 30 to n days in the following line:
	DateDiff(DAY, v.publication_date, GETDATE()) < 30
	--v.risk IN ('Remote Privileged')
	--v.skill IN ('Automated Exploit')

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
2. Last_Full_Scan_Per_Network_by_Network_Group
select distinct n.*,
       case when a.audit_id IS NULL then 0 else a.audit_id end as last_audit_id,
	   case when a.end_date IS NULL then 0 ELSE a.end_date end as last_scan_date,
	   case when s.host_count IS NULL then -1 else s.host_count end as host_count,
	   case when s.vuln_count IS NULL then -1 else s.vuln_count end as vuln_count,
	case when s.vscore_total IS NULL then -1 else s.vscore_total end as risk_score_total
from (
	select distinct ang.vne_id, ang.parent_network_group_id as network_group_id, ng.network_group_name, nl.network_id, nl.network_name
	from (
		SELECT vne_id, ng.network_group_id as parent_network_group_id, a.network_group_id as child_network_group_id
		FROM network_group ng
		CROSS APPLY dbo.RecurseNetworkGroups(ng.network_group_id, ng.vne_id) AS a
	) ang
	join NETWORK_GROUP ng on ng.vne_id = ang.vne_id and ng.network_group_id = ang.parent_network_group_id
	join NETWORK_GROUP_NETWORK ngn on ngn.vne_id = ang.vne_id and ngn.network_group_id = ang.child_network_group_id
	join network_list nl on nl.vne_id = ngn.vne_id and nl.network_id = ngn.network_id
	where
		nl.deleted = 0 and
		nl.active = 1 and
		nl.isGlobalExclude = 0
	UNION ALL
	select distinct nb.vne_id, 0 as network_group_id, 'All' as network_group_name, nl.network_id, nl.network_name
	from (
		SELECT vne_id, ng.network_group_id
		FROM network_group ng
		where parent IS NULL
	) nb
	CROSS APPLY dbo.RecurseNetworkGroups(nb.network_group_id, nb.vne_id) AS a
	join NETWORK_GROUP_NETWORK ngn on ngn.network_group_id = a.network_group_id and ngn.vne_id = nb.vne_id
	join network_list nl on nl.network_id = ngn.network_id and nl.vne_id = ngn.vne_id
	where
		nl.deleted = 0 and
		nl.active = 1 and
		nl.isGlobalExclude = 0
) n
left join (
	select vne_id, network_id, audit_id, end_date
	from (
		select vne_id, network_id, audit_id, end_date, rank() over (partition by vne_id, network_id order by end_date desc) rank
		from audit_tbl a
			WHERE
				a.aud_type != 'Partial' and
				(a.aud_status = 'Finished' or a.aud_status IS NULL) and
				a.end_date < DATEADD(mm,DATEDIFF(mm,0,GETDATE()),0)
	) fatb
	where rank = 1
) a on n.vne_id = a.vne_id and n.network_id = a.network_id
left join SUMMARY s on s.vne_id = a.vne_id and s.audit_id = a.audit_id
order by network_group_name, last_audit_id

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
3. Last_Scan_Cred_Count_by_Network
select 
    a.vne_id,
	a.network_id,
	a.audit_id,
	a.end_date,
    s.vscore_total,
    s.host_count,
    case when c.cred_scan_cnt is null then 0 else c.cred_scan_cnt end as cred_scan_cnt,
	count(distinct hostscan_guid) as host_vuln_cnt
from fndappvuln f
join host_scan hs on hs.guid=f.hostscan_guid
join audit_tbl a on a.vne_id=hs.vne_id and a.audit_id=hs.audit_id
join summary s on s.vne_id = a.vne_id and s.audit_id = a.audit_id
join (
		select vne_id, audit_id
		from (
			select vne_id, audit_id, end_date, rank() over (partition by vne_id, network_id order by end_date desc) rank
			from audit_tbl a
				WHERE
					a.aud_type != 'Partial' and
					(a.aud_status = 'Finished' or a.aud_status IS NULL) and
					a.end_date < DATEADD(mm,DATEDIFF(mm,0,GETDATE()),0)
		) fatb
		where rank = 1
) i on i.vne_id = s.vne_id and i.audit_id = s.audit_id
left join (
	select hs.vne_id, hs.audit_id, count(*) as cred_scan_cnt
	from HOST_SCAN hs
	join (
		select distinct hostscan_guid
		from fndappvuln fav
		where vuln_id IN (5923,7290,9971,9973)
	) c on c.hostscan_guid = hs.guid
	group by hs.vne_id, hs.audit_id
) c on c.vne_id = s.vne_id and c.audit_id = s.audit_id
group by a.vne_id, a.network_id, a.audit_id, a.end_date, s.vscore_total, s.host_count, c.cred_scan_cnt

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
4. IP360_Credential_Failures
select distinct network_group_name, ip, hostname, os, smb_failure, wmi_failure, rpc_failure, ssh_failure
from (
	SELECT ng.network_group_name, h.IP, h.HostName, h.OS, 
	CASE WHEN fav.vuln_id=5452 THEN 'Yes' ELSE '' END as SMB_Failure ,
	CASE WHEN fav.vuln_id=9974 THEN 'Yes' ELSE '' END as WMI_Failure ,
	CASE WHEN fav.vuln_id=9972 THEN 'Yes' ELSE '' END as RPC_Failure ,
	CASE WHEN fav.vuln_id=7291 THEN 'Yes' ELSE '' END as SSH_Failure 
	FROM host_scan hs
	JOIN host h ON h.guid=hs.host_guid and h.vne_id = hs.vne_id
	JOIN fndappvuln fav ON fav.hostscan_guid = hs.guid
	JOIN audit_tbl a ON a.audit_id=hs.audit_id and a.vne_id = hs.vne_id
	JOIN network n ON a.network_id=n.network_id and a.vne_id = n.vne_id
	JOIN network_group_network ngn ON n.network_id=ngn.network_id and n.vne_id = ngn.vne_id
	JOIN network_group ng ON ngn.network_group_id=ng.network_group_id and ngn.vne_id = ng.vne_id
	WHERE
		fav.vuln_id IN (5452,9974,7291,9972)
		AND n.last_audit=a.audit_id ) s
group by network_group_name, ip, hostname, os, smb_failure, wmi_failure, rpc_failure, ssh_failure
order by network_group_name, ip

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
5. CCM_Hosts_Without_Successful_Auth

with _prefcreds as (
    select np.ProfileName, a.AssetId, ar.hostname, ar.IP, AR.OS + ' ' + AR.OSVersion AS OS,  ar.netbiosgroup, ar.Up, rev.RevisionTime,
    CASE WHEN iip.PropertyValue = -1 THEN 0 ELSE 1 END as LoggedIn, c.Username
    from nCCM_Asset a 
    inner join nCCM_NetworkProfile np on np.NetworkProfileID = a.NetworkProfileId
    inner join nCCM_AssetRecord ar on a.CurrentRecordId = ar.AssetRecordId 
    inner join nCCM_AssetInventoryItem aii on a.AssetId = aii.AssetId 
    inner join nCCM_InventoryItemChange iic on aii.AssetInventoryItemId = iic.AssetInventoryItemId 
    inner join nCCM_InventoryCategory ic on aii.InventoryCategoryId = ic.InventoryCategoryId 
    inner join nCCM_ItemProperty ip on ip.ItemPropertyId = iic.ItemPropertyId 
    inner join nCCM_InventoryProperty invp on ip.InventoryPropertyId = invp.InventoryPropertyId 
    inner join nCCM_Revision rev on rev.RevisionId = iic.RevisionId 
    inner join nCCM_ItemIntProperty iip on ip.ItemPropertyId = iip.ItemPropertyId 
    left outer join nCCM_Credentials c on c.CredentialsId = iip.PropertyValue
    where iic.NextRevisionId = 2147483646 
    and iic.IsDeleted = 0 
    and invp.PropertyName = 'Preferred Credentials'
), _unauth as (
       select hostname, ip, ar.os + ' ' + ar.osversion as os, netbiosgroup, up, NULL as revisiontime, NULL as loggedin, NULL as username
       from nCCM_Asset a
       inner join nCCM_NetworkProfile np on np.NetworkProfileID = a.NetworkProfileId
       inner join nCCM_AssetRecord ar on a.CurrentRecordId = ar.AssetRecordId 
       where a.AssetID NOT IN (select distinct AssetId from _prefcreds)
)


select hostname, ip, os, netbiosgroup, up, revisiontime, loggedin, username
from _prefcreds
where LoggedIn IN (0,1)
UNION ALL
select hostname, ip, os, netbiosgroup, up, NULL, NULL, NULL
from _unauth
order by OS, NetBIOSGroup, Hostname


- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
6. Host_Data_Items_by_Audit:
select h.vne_id, atb.network_name, h.ip, h.hostname, h.netbiosname, atb.end_date, atb.scanprofile_name, hdi.item_name, hdi.description, fd.data_item
from audit_tbl atb
join host_scan hs on hs.audit_id = atb.audit_id and hs.vne_id = atb.vne_id
join host h on h.guid = hs.host_guid and h.vne_id = hs.vne_id and h.last_audit = atb.audit_id
join fnddata fd on fd.hostscan_guid = hs.guid
join host_data_items hdi on fd.host_data_item_id = hdi.item_id
-- You must adjust the
-- Example: where atb.vne_id = 1 and atb.audit_id = 93732
where atb.vne_id = %1% and atb.audit_id = %2%
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

----Pulls the last 30 days of scan data and using the unique IP data, shows the hosts per OS
with scope(hostscan_guid, host_guid, ip, os, hostname, netbiosname) as (
	SELECT hso.guid as hostscan_guid, h.guid as host_guid, h.ip, h.os, h.hostname, h.netbiosname
	FROM host h
	INNER JOIN host_scan hso ON hso.host_guid = h.guid
	WHERE EXISTS(
		SELECT distinct hs.guid as hostscan_guid
		FROM host_scan hs
		INNER JOIN audit_tbl atb ON hs.audit_id = atb.audit_id AND hs.vne_id = atb.vne_id
		INNER JOIN network n ON n.network_id = atb.network_id AND n.vne_id = atb.vne_id
		WHERE
			hso.guid = hs.guid
			AND atb.start_date >= dateadd("d", -30, getdate()) AND atb.end_date < getdate()
			AND (atb.aud_status IS NULL OR atb.aud_status IN ('Finished'))
			AND atb.upload_in_progress != 1
	)
), success_auth_scope(host_guid, ip, os) as (
	select host_guid, ip, max(os) as os
	from scope s
	join fndappvuln fav on fav.hostscan_guid = s.hostscan_guid
	where fav.vuln_id IN (5923,7290,9971,9973)
    group by host_guid, ip
), os_unique_ip(os, ip) as (
	select distinct os, ip
	from scope
), os_unique_ip_auth(os, ip) as (
	select distinct os, ip
	from success_auth_scope
), unique_ip_hostname(ip, hostname, netbiosname) as (
	select ip, max(hostname) as hostname, max(netbiosname) as netbiosname
	from scope s
	group by ip
)

select distinct s.os, s.ip, uih.hostname, uih.netbiosname, case when sas.ip IS NULL THEN 0 else 1 end as auth
from scope s
join unique_ip_hostname uih on uih.ip = s.ip
left join success_auth_scope sas on sas.ip = s.ip

---------------modified pull data from last x days and display auth information
with scope(hostscan_guid, host_guid, ip, os, hostname, netbiosname, audit_id, network_id, network_name) as (
	SELECT hso.guid as hostscan_guid, h.guid as host_guid, h.ip, h.os, h.hostname, h.netbiosname, a.audit_id, a.network_id, a.network_name
	FROM host h
	INNER JOIN host_scan hso ON hso.host_guid = h.guid
	INNER JOIN AUDIT_TBL a on a.audit_id = hso.audit_id and a.vne_id = hso.vne_id
	WHERE EXISTS(
		SELECT distinct hs.guid as hostscan_guid
		FROM host_scan hs
		INNER JOIN audit_tbl atb ON hs.audit_id = atb.audit_id AND hs.vne_id = atb.vne_id
		INNER JOIN network n ON n.network_id = atb.network_id AND n.vne_id = atb.vne_id
		WHERE
			hso.guid = hs.guid
			AND atb.start_date >= dateadd("d", -130, getdate()) AND atb.end_date < getdate()
			AND (atb.aud_status IS NULL OR atb.aud_status IN ('Finished'))
			AND atb.upload_in_progress != 1
	)
), success_auth_scope(hostscan_guid, vuln_id, vuln_name) as (
	select hostscan_guid, s.vuln_id, vuln_name
	from (
		select s.hostscan_guid, max(vuln_id) as vuln_id
		from scope s
		join fndappvuln fav on fav.hostscan_guid = s.hostscan_guid
		where fav.vuln_id IN (5923,7290,9971,9973)
		group by s.hostscan_guid
	) s
	join VULNERABILITY v on v.vuln_id = s.vuln_id
), none_auth_scope(hostscan_guid, vuln_id, vuln_name) as (
	select hostscan_guid, s.vuln_id, vuln_name
	from (
		select s.hostscan_guid, max(vuln_id) as vuln_id
		from scope s
		join fndappvuln fav on fav.hostscan_guid = s.hostscan_guid
		where fav.vuln_id IN (59,169)
		group by s.hostscan_guid
	) s
	join VULNERABILITY v on v.vuln_id = s.vuln_id
), fail_auth_scope(hostscan_guid, vuln_id, vuln_name) as (
	select hostscan_guid, s.vuln_id, vuln_name
	from (
		select s.hostscan_guid, max(vuln_id) as vuln_id
		from scope s
		join fndappvuln fav on fav.hostscan_guid = s.hostscan_guid
		where fav.vuln_id IN (5452,7291,9972,9974)
		group by s.hostscan_guid
	) s
	join VULNERABILITY v on v.vuln_id = s.vuln_id
)

select s.os, network_id, network_name, s.ip, s.hostname, s.netbiosname, audit_id, sas.vuln_id, sas.vuln_name, nas.vuln_id as none_auth, nas.vuln_name as none_auth_vuln_name, fas.vuln_id as fail_auth, fas.vuln_name as fail_auth_vuln_name
from scope s
left join success_auth_scope sas on sas.hostscan_guid = s.hostscan_guid
left join none_auth_scope nas on nas.hostscan_guid = s.hostscan_guid
left join fail_auth_scope fas on fas.hostscan_guid = s.hostscan_guid
order by os, network_id
---------------modified puul data from last x days and display auth information

--------------CCM
The below query runs directly against the CCM database. If the customer needs it for SIH, then the table names all need to be prefixed with "nccm_"

Let me know if this helps.

;WITH AssetGroupCTE (RowNumber, AssetGroupId, Name, TreeLeftIndex, TreeRightIndex) AS
(
       SELECT 1, AssetGroupId, CAST(Name as varchar(8000)) as Name, TreeLeftIndex, TreeRightIndex
       FROM AssetGroup ag
       UNION ALL
       SELECT CT.RowNumber + 1, ag.AssetGroupId, CAST(ct.Name + '->' + ag.Name as varchar(8000)) as Name, ag.TreeLeftIndex, ag.TreeRightIndex
       FROM AssetGroup ag
       INNER JOIN AssetGroupCTE CT ON CT.TreeLeftIndex < ag.TreeLeftIndex and CT.TreeRightIndex > ag.TreeRightIndex
), AssetGroupAsset (AssetGroupId, HierarchyName, AssetGroupName, AssetId) as (
       select agc.AssetGroupId, agc.Name as HierarchyName, ag.Name as AssetGroupName, a.AssetId
       from AssetGROUPCTE agc
       JOIN (
              SELECT AssetGroupId, MAX(RowNumber) AS MaxRow
              FROM AssetGroupCTE
              GROUP BY AssetGroupId
       ) agr ON agr.MaxRow = agc.RowNumber and agc.AssetGroupId = agr.AssetGroupId
       join assetgroup ag on ag.AssetGroupId = agr.AssetGroupId
       join assetgroup ag2 on ag2.TreeLeftIndex >= ag.TreeLeftIndex and ag2.TreeRightIndex <= ag.TreeRightIndex
       join asset a on a.AssetGroupid = ag2.AssetGroupId
)
select ag.HierarchyName, ag.AssetGroupName, avg(ar.PercentCompliant) as AggPercentCompliant, max(riskscore) as AggRiskScore
from Asset a
join AssetRecord ar on ar.AssetRecordId = a.CurrentRecordId
join AssetGroupAsset ag on ag.AssetId = a.AssetId
where
       ar.PercentCompliant > -1
group by ag.HierarchyName, ag.AssetGroupName

-----------------------------------
SIH

As discussed, run "select * from vne" and if you still see the old vne, then run "delete from vne where 
vne_id = X" where X represents the vne_id that you want to delete.


delete from fndapp where hostscan_guid IN (select guid from HOST_SCAN where vne_id not in (select vne_id from vne))
delete from fndappvuln where hostscan_guid IN (select guid from HOST_SCAN where vne_id not in (select vne_id from vne))
delete from HOST_SCAN where vne_id not in (select vne_id from vne)
delete from HOST where vne_id not in (select vne_id from vne)
delete from AUDIT_TBL where vne_id not in (select vne_id from vne)
delete from AUDIT_IMPORT_FAILURE where vne_id not in (select vne_id from vne)
delete from SCAN_PROFILE where vne_id not in (select vne_id from vne)
delete from SIH_EXEC_SUMMARY_GROUP where vne_id not in (select vne_id from vne)
delete from VULNERABILITY where vne_id not in (select vne_id from vne)
delete from sih_group_all_members where group_member_id IN (select id from sih_group_member where vne_id not in (select vne_id from vne))
delete from sih_group_member where vne_id not in (select vne_id from vne)
delete from DATA_UPLOAD_SOURCES where vne_id not in (select vne_id from vne)
delete from DEVICE_PROFILER where vne_id not in (select vne_id from vne)
delete from SIH_IDENTITY_VNE_N_ACCESS where vne_id not in (select vne_id from vne)
delete from SIH_IDENTITY_VNE_NG_ACCESS where vne_id not in (select vne_id from vne)
delete from NETWORK where vne_id not in (select vne_id from vne)
delete from NETWORK_GROUP where vne_id not in (select vne_id from vne)
delete from NETWORK_GROUP_NETWORK where vne_id not in (select vne_id from vne)
delete from NETWORK_LIST where vne_id not in (select vne_id from vne)
delete from OS where vne_id not in (select vne_id from vne)
delete from OS_GROUP where vne_id not in (select vne_id from vne)
delete from OS_GROUP_OS where vne_id not in (select vne_id from vne)
delete from APPLICATION where vne_id not in (select vne_id from vne)
delete from SUMMARY_OS where vne_id not in (select vne_id from vne)
delete from SUMMARY_TOPN_APPS where vne_id not in (select vne_id from vne)
delete from SUMMARY_TOPN_RISKAPPS where vne_id not in (select vne_id from vne)
delete from SUMMARY_TOPN_SANS where vne_id not in (select vne_id from vne)
delete from SUMMARY_TOPN_VULNS where vne_id not in (select vne_id from vne)
delete from SUMMARY where vne_id not in (select vne_id from vne)

---------------------------------------------------------------------------------

vulnsinstance query

select h.os, h.ip, h.hostname, h.netbiosname, h.guid as host_guid, fav.hostscan_guid as host_scan_guid, fav.vuln_id, fav.vuln_name, v.vuln_score, v.risk, v.skill, fav.app_id, fav.app_name, fav.port, fav.protocol, fsa.end_date as first_detected_date, a.start_date, a.end_date, case when fav.hostscan_guid != fs.hostscan_guid then 0 else 1 end as is_new, times_detected, a.network_id, a.network_name
from HOST h
join HOST_SCAN hs on hs.host_guid = h.guid
join FNDAPPVULN fav on fav.hostscan_guid = hs.guid
join (
       select a.vne_id, a.network_id, a.audit_id as last_audit
       from (
              select a.vne_id, a.network_id, a.audit_id, RANK() OVER (PARTITION BY a.vne_id, a.network_id ORDER BY a.end_date DESC) as row_rank
              from AUDIT_TBL a
              join SCAN_PROFILE sp on sp.vne_id = a.vne_id and sp.scanprofile_id = a.scanprofile_id
              where sp.vuln_scanning = 1
                    and (a.aud_status IS NULL OR a.aud_status='Finished')
                       and a.upload_in_progress != 1
                       --and DATEDIFF(day,a.end_date,getdate()) <= 90
       ) a
       where row_rank = 1
) la on la.vne_id = hs.vne_id and la.last_audit = hs.audit_id
join AUDIT_TBL a on a.vne_id = la.vne_id and a.audit_id = la.last_audit
join (
    select hs.host_guid, fav.vuln_id, app_id, port, protocol, MIN(fav.hostscan_guid) as hostscan_guid, count(fav.hostscan_guid) as times_detected
    from HOST_SCAN hs
    join FNDAPPVULN fav on fav.hostscan_guid = hs.guid
    group by hs.host_guid, fav.vuln_id, app_id, port, protocol
) fs on fs.host_guid = h.guid and fs.vuln_id = fav.vuln_id and fs.app_id = fav.app_id and fs.port = fav.port and fs.protocol = fav.protocol
join HOST_SCAN hs2 on hs2.guid = fs.hostscan_guid
join AUDIT_TBL fsa on fsa.vne_id = hs2.vne_id and fsa.audit_id = hs2.audit_id
join vulnerability v on v.vuln_id = fav.vuln_id

----------------------------display all vulns with cvss > 7

SELECT fav.vuln_id, AVG(fav.vuln_score) as vuln_score, fav.max_cvss_base_score, hs_scans_out.host_guid as host_guid, nl.network_name, fav.port, fav.protocol, SUM(CASE WHEN ex.exception_id IS NULL THEN 0 ELSE 1 END) as excepted
FROM host_scan hs_scans_out
INNER JOIN audit_tbl atb ON atb.audit_id = hs_scans_out.audit_id and atb.vne_id = hs_scans_out.vne_id
INNER JOIN fndappvuln fav ON hs_scans_out.guid = fav.hostscan_guid
LEFT JOIN network_list nl ON nl.network_id = atb.network_id AND nl.vne_id = atb.vne_id
LEFT JOIN SIH_EXCEPTIONS_CACHE ex ON fav.guid = ex.fav_guid
WHERE ( EXISTS(
    SELECT 0
    FROM (
        SELECT hs.guid as hostscan_guid
        FROM host h
        INNER JOIN host_scan hs ON h.guid = hs.host_guid
        INNER JOIN audit_tbl atb ON hs.vne_id = atb.vne_id AND hs.audit_id = atb.audit_id
        LEFT JOIN network_list nl ON nl.network_id = atb.network_id AND nl.vne_id = atb.vne_id
        INNER JOIN (
            SELECT vne_id, audit_id
            FROM (
                SELECT atb.vne_id, atb.network_id, atb.audit_id, RANK() OVER (PARTITION BY atb.vne_id, atb.network_id ORDER BY atb.end_date DESC) as row_rank
                FROM audit_tbl atb
                WHERE ( atb.aud_status IS NULL OR atb.aud_status IN ('Finished') )
                AND ( atb.upload_in_progress != 1 )
            ) r
            WHERE ( row_rank = 1 )
        ) ca ON ca.vne_id = atb.vne_id AND ca.audit_id = atb.audit_id
        WHERE ( (nl.isglobalexclude <> 1) OR (nl.isglobalexclude IS NULL) )
        AND ( hostscan_guid = hs_scans_out.guid )
        GROUP BY hs.guid
        ) q
    WHERE ( q.hostscan_guid = hs_scans_out.guid ) and fav.max_cvss_base_score >= 7.0;
    ) )
AND ( nl.isglobalexclude=0 )
GROUP BY host_guid, fav.vuln_id, fav.max_cvss_base_score, nl.network_name, fav.port, fav.protocol

---------------------Display all vulns with cvss > 7 and join more tables for more columns
---------------------and sepearating mitigation, solution, decription

with vuln_d_m_s (description, solution, mitigation, vuln_id) as (select x.i.value('p[2]', 'NVARCHAR(MAX)') as [Description], x.i.value('p[3]', 'NVARCHAR(MAX)') as [Solution], x.i.value('p[4]', 'NVARCHAR(MAX)') as [Mitigation],
[vuln_id]
           FROM
           (
               SELECT [XML] = CONVERT(XML, CAST('<i><p>' 
                    + REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(cast([description] as nvarchar(max)), CHAR(39), '&apos;'), '"', '&quote;'), '&', '&amp;'), '<', '&lt;'), '>', '&lt;'),  'DESCRIPTION'+CHAR(10) , ' </p><p> '), 'SOLUTION'+CHAR(10), ' </p><p> '),  'MITIGATION'+CHAR(10), ' </p><p> ')
                    + ' </p></i>'
                    as VARCHAR(MAX)) 
                    ).query('.'),
                    vuln_id
from [VULNERABILITY]
                    where ([description] like '%DESCRIPTION'+CHAR(10)+'%'  
                    and [description] like '%SOLUTION'+CHAR(10)+'%'
                    and [description] like '%MITIGATION'+CHAR(10)+'%')
           ) As a
           CROSS APPLY
           [XML].nodes('i') AS x(i)
union all
select
x.i.value('p[2]', 'NVARCHAR(MAX)') as [Description],
x.i.value('p[3]', 'NVARCHAR(MAX)') as [Solution],
x.i.value('p[4]', 'NVARCHAR(MAX)') as [Mitigation],
[vuln_id]
           FROM
           (
               SELECT [XML] = CONVERT(XML, CAST('<i><p>' 
                    + REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(cast([description] as nvarchar(max)), CHAR(39), '&apos;'), '"', '&quote;'), '&', '&amp;'), '<', '&lt;'), '>', '&lt;'),  'DESCRIPTION'+CHAR(10) , ' </p><p> '), 'SOLUTION'+CHAR(10), ' </p><p> '),  'MITIGATION'+CHAR(10), ' </p><p> ')
                    + ' </p></i>'
                    as VARCHAR(MAX)) 
                    ).query('.'),
                    vuln_id
from [VULNERABILITY]
                    where ([description] like '%DESCRIPTION'+CHAR(10)+'%' ) 
                    and not ([description] like '%SOLUTION'+CHAR(10)+'%'
                    and [description] like '%MITIGATION'+CHAR(10)+'%')
           ) As a
           CROSS APPLY
           [XML].nodes('i') AS x(i)
union all
select
x.i.value('p[1]', 'NVARCHAR(MAX)') as [Description],
x.i.value('p[2]', 'NVARCHAR(MAX)') as [Solution],
x.i.value('p[3]', 'NVARCHAR(MAX)') as [Mitigation],
[vuln_id]
           FROM
           (
               SELECT [XML] = CONVERT(XML, CAST('<i><p>' 
                    + REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(cast([description] as nvarchar(max)), CHAR(39), '&apos;'), '"', '&quote;'), '&', '&amp;'), '<', '&lt;'), '>', '&lt;'),  'DESCRIPTION'+CHAR(10) , ' </p><p> '), 'SOLUTION'+CHAR(10), ' </p><p> '),  'MITIGATION'+CHAR(10), ' </p><p> ')
                    + ' </p></i>'
                    as VARCHAR(MAX)) 
                    ).query('.'),
                    vuln_id
from [VULNERABILITY]
                    where ([description] not like '%DESCRIPTION'+CHAR(10)+'%' ) 
                    and ([description] like '%SOLUTION'+CHAR(10)+'%'
                    and [description] like '%MITIGATION'+CHAR(10)+'%')
           ) As a
           CROSS APPLY
           [XML].nodes('i') AS x(i)
union all
select
x.i.value('p[1]', 'NVARCHAR(MAX)') as [Description],
x.i.value('p[2]', 'NVARCHAR(MAX)') as [Solution],
x.i.value('p[3]', 'NVARCHAR(MAX)') as [Mitigation],
[vuln_id]
           FROM
           (
               SELECT [XML] = CONVERT(XML, CAST('<i><p>' 
                    + REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(cast([description] as nvarchar(max)), CHAR(39), '&apos;'), '"', '&quote;'), '&', '&amp;'), '<', '&lt;'), '>', '&lt;'),  'DESCRIPTION'+CHAR(10) , ' </p><p> '), 'SOLUTION'+CHAR(10), ' </p><p> '),  'MITIGATION'+CHAR(10), ' </p><p> ')
                    + ' </p></i>'
                    as VARCHAR(MAX)) 
                    ).query('.'),
                    vuln_id
from [VULNERABILITY]
                    where ([description] not like '%DESCRIPTION'+CHAR(10)+'%' ) 
                    and not ([description] like '%SOLUTION'+CHAR(10)+'%'
                    and [description] like '%MITIGATION'+CHAR(10)+'%')
           ) As a
           CROSS APPLY
           [XML].nodes('i') AS x(i)
)
SELECT hh.hostname as DNS_Name,hh.domainname as NetBIOS_Domain,hh.netbiosname as NetBIOS_Name,hh.IP as IP,hh.os as OS ,hh.last_host_score as Host_Score,nl.network_name as IP360_Network,fav.vuln_id as Vulnerability_ID, fav.vuln_name as Vulnerability_Desc, 
AVG(fav.vuln_score) as Vulnerability_Score, v.risk as Risk, v.skill as Skill, v.strategy as Strategy, dms.description as Description , dms.solution as Solution, dms.mitigation as Mitigation,
fav.max_cvss_base_score, fav.max_cvss_temporal_score, vct.vector as temporal_vector, hs_scans_out.audit_id as Audit_ID, cve.cve_id, cve.cve_num, atb.end_date,
hs_scans_out.host_guid as host_guid,
fav.port, fav.protocol, SUM(CASE WHEN ex.exception_id IS NULL THEN 0 ELSE 1 END) as excepted
FROM host_scan hs_scans_out INNER JOIN audit_tbl atb ON atb.audit_id = hs_scans_out.audit_id and atb.vne_id = hs_scans_out.vne_id 
INNER JOIN fndappvuln fav ON hs_scans_out.guid = fav.hostscan_guid
LEFT JOIN network_list nl ON nl.network_id = atb.network_id AND nl.vne_id = atb.vne_id
LEFT JOIN SIH_EXCEPTIONS_CACHE ex ON fav.guid = ex.fav_guid
left join VULN_CVSS_TEMPORAL vct on vct.vuln_id = fav.vuln_id
left join host hh on hh.guid = hs_scans_out.host_guid -- hs_scans_out.guid
left join vulnerability v on v.vuln_id = fav.vuln_id
left join vuln_cve cve on cve.vuln_id = fav.vuln_id
left join vuln_d_m_s dms on dms.vuln_id = v.vuln_id
WHERE ( EXISTS (
    SELECT 0
    FROM (
        SELECT hs.guid as hostscan_guid
                FROM host h
        INNER JOIN host_scan hs ON h.guid = hs.host_guid
        INNER JOIN audit_tbl atb ON hs.vne_id = atb.vne_id AND hs.audit_id = atb.audit_id
        LEFT JOIN network_list nl ON nl.network_id = atb.network_id AND nl.vne_id = atb.vne_id
        INNER JOIN (
            SELECT vne_id, audit_id
            FROM (
                SELECT atb.vne_id, atb.network_id, atb.audit_id, RANK() OVER (PARTITION BY atb.vne_id, atb.network_id ORDER BY atb.end_date DESC) as row_rank
                FROM audit_tbl atb
                WHERE ( atb.aud_status IS NULL OR atb.aud_status IN ('Finished') )
                AND ( atb.upload_in_progress != 1 )
            ) r
            WHERE ( row_rank = 1 )
        ) ca ON ca.vne_id = atb.vne_id AND ca.audit_id = atb.audit_id
        WHERE ( (nl.isglobalexclude <> 1) OR (nl.isglobalexclude IS NULL) )
        AND ( hostscan_guid = hs_scans_out.guid )
        GROUP BY hs.guid
        ) q
    WHERE ( q.hostscan_guid = hs_scans_out.guid ) and fav.max_cvss_base_score >= 7.0
    ) )
AND ( nl.isglobalexclude=0 )
GROUP BY hs_scans_out.audit_id, host_guid, hh.IP, hh.hostname, hh.domainname, hh.netbiosname,hh.last_host_score, hh.os, fav.vuln_id, fav.max_cvss_base_score, nl.network_name, v.risk, v.skill, v.strategy, cve.cve_id, cve.cve_num, fav.port, fav.protocol, fav.vuln_name, dms.description, dms.mitigation, dms.solution, fav.max_cvss_temporal_score, vct.vector,atb.end_date;





---------------------------------same query but mitigation, description, solution in one column

SELECT hh.hostname,hh.domainname,hh.netbiosname,hh.IP,hh.os,hh.last_host_score,nl.network_name,fav.vuln_id, fav.vuln_name, 
AVG(fav.vuln_score) as vuln_score, v.risk, v.skill, v.strategy, cast(v.description as nvarchar(max)) as description,
fav.max_cvss_base_score, fav.max_cvss_temporal_score, vct.vector as temporal_vector, cve.cve_id, cve.cve_num, atb.end_date,
hs_scans_out.host_guid as host_guid,
fav.port, fav.protocol, SUM(CASE WHEN ex.exception_id IS NULL THEN 0 ELSE 1 END) as excepted
FROM host_scan hs_scans_out INNER JOIN audit_tbl atb ON atb.audit_id = hs_scans_out.audit_id and atb.vne_id = hs_scans_out.vne_id 
INNER JOIN fndappvuln fav ON hs_scans_out.guid = fav.hostscan_guid
LEFT JOIN network_list nl ON nl.network_id = atb.network_id AND nl.vne_id = atb.vne_id
LEFT JOIN SIH_EXCEPTIONS_CACHE ex ON fav.guid = ex.fav_guid
left join VULN_CVSS_TEMPORAL vct on vct.vuln_id = fav.vuln_id
left join host hh on hh.guid = hs_scans_out.host_guid -- hs_scans_out.guid
left join vulnerability v on v.vuln_id = fav.vuln_id
left join vuln_cve cve on cve.vuln_id = fav.vuln_id
WHERE ( EXISTS (
    SELECT 0
    FROM (
        SELECT hs.guid as hostscan_guid
                FROM host h
        INNER JOIN host_scan hs ON h.guid = hs.host_guid
        INNER JOIN audit_tbl atb ON hs.vne_id = atb.vne_id AND hs.audit_id = atb.audit_id
        LEFT JOIN network_list nl ON nl.network_id = atb.network_id AND nl.vne_id = atb.vne_id
        INNER JOIN (
            SELECT vne_id, audit_id
            FROM (
                SELECT atb.vne_id, atb.network_id, atb.audit_id, RANK() OVER (PARTITION BY atb.vne_id, atb.network_id ORDER BY atb.end_date DESC) as row_rank
                FROM audit_tbl atb
                WHERE ( atb.aud_status IS NULL OR atb.aud_status IN ('Finished') )
                AND ( atb.upload_in_progress != 1 )
            ) r
            WHERE ( row_rank = 1 )
        ) ca ON ca.vne_id = atb.vne_id AND ca.audit_id = atb.audit_id
        WHERE ( (nl.isglobalexclude <> 1) OR (nl.isglobalexclude IS NULL) )
        AND ( hostscan_guid = hs_scans_out.guid )
        GROUP BY hs.guid
        ) q
    WHERE ( q.hostscan_guid = hs_scans_out.guid ) and fav.max_cvss_base_score >= 7.0
    ) )
AND ( nl.isglobalexclude=0 )
GROUP BY host_guid, hh.IP, hh.hostname, hh.domainname, hh.netbiosname,hh.last_host_score, hh.os, fav.vuln_id, fav.max_cvss_base_score, nl.network_name, v.risk, v.skill, v.strategy, cve.cve_id, cve.cve_num, fav.port, fav.protocol, fav.vuln_name, cast(v.description as nvarchar(max)), fav.max_cvss_temporal_score, vct.vector,atb.end_date;









-----------

SIH-------------------------------------------------------


DECLARE @THERECKONING DATETIME
SET @THERECKONING = '1/1/2016'

;with _prev_vuln as (
       select distinct h.guid, vuln_id
       from host h
       join host_scan hs on hs.host_guid = h.guid
       join audit_tbl a on a.audit_id = hs.audit_id and a.vne_id = hs.vne_id
       join fndappvuln fav on fav.hostscan_guid = hs.guid
       where
              a.end_date < @THERECKONING
)

select distinct h.guid, fav.vuln_id, fav.vuln_name, fav.app_name
from host h
join host_scan hs on hs.host_guid = h.guid
join audit_tbl a on a.audit_id = hs.audit_id and a.vne_id = hs.vne_id
join fndappvuln fav on fav.hostscan_guid = hs.guid
left outer join _prev_vuln pv on pv.guid = h.guid and pv.vuln_id = fav.vuln_id
where
       a.end_date >= @THERECKONING and pv.vuln_id IS NULL
	  
CCM------------------------------

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[GetCCMCategoryCrosstabPrint] 
@CategoryName nvarchar(64)
AS 
----------------------------------------------------------------------------- 
----- Expected and Actuals for Michael stinson for CCM Data 
---: Fw: CCM data query--expected and actuals 
-----------------------------------------------------------------------------
--InventoryPropertyIds are not the same between CCM installs; you may need to
--change them when running this query against a different CCM instance
set transaction isolation level read uncommitted

DECLARE @query NVARCHAR(4000)

DECLARE @cols NVARCHAR(2000)
SELECT  @cols = COALESCE(@cols + ',[' + ip.PropertyName + ']',
                         '[' + ip.PropertyName + ']')
FROM  InventoryCategory ic
join InventoryProperty ip on ic.InventoryCategoryId = ip.InventoryCategoryId
where ic.CategoryName = @CategoryName

SET @query = N'select AssetId,IP,Hostname,CategoryName,UniqueName,DisplayName,'+@cols +' from (
select a.AssetId, ar.IP, ar.Hostname, ic.CategoryName,aii.UniqueName,DisplayName,invp.PropertyName,
isNull(isNull(isNull(cast(isp.PropertyValue as nvarchar(max)), issp.PropertyValue), ibp.PropertyValue), iip.PropertyValue) as PropertyValue
from Asset a 
inner join AssetRecord ar on a.CurrentRecordId = ar.AssetRecordId 
inner join AssetInventoryItem aii on a.AssetId = aii.AssetId 
inner join InventoryItemChange iic on aii.AssetInventoryItemId = iic.AssetInventoryItemId 
inner join InventoryCategory ic on aii.InventoryCategoryId = ic.InventoryCategoryId 
inner join ItemProperty ip on ip.ItemPropertyId = iic.ItemPropertyId 
inner join InventoryProperty invp on ip.InventoryPropertyId = invp.InventoryPropertyId 
inner join Revision rev on rev.RevisionId = iic.RevisionId 
left outer join ItemShortStringProperty issp on ip.ItemPropertyId = issp.ItemPropertyId 
left outer join ItemStringProperty isp on ip.ItemPropertyId = isp.ItemPropertyId 
left outer join ItemBoolProperty ibp on ip.ItemPropertyId = ibp.ItemPropertyId 
left outer join ItemIntProperty iip on ip.ItemPropertyId = iip.ItemPropertyId 
where iic.NextRevisionId = 2147483646 
and CategoryName = ''' + @CategoryName + '''
and iic.IsDeleted = 0
) p PIVOT ( MAX(PropertyValue) for PropertyName IN (' + @cols + ') ) as pvt'

--PRINT(@query)
exec(@query)

GO

EXEC [dbo].[GetCCMCategoryCrosstabPrint]'Users'
GO
DROP PROCEDURE [dbo].[GetCCMCategoryCrosstabPrint]
GO

--------------------
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'CCMComplianceByAsset')
	DROP PROCEDURE CCMComplianceByAsset
GO

CREATE PROCEDURE CCMComplianceByAsset
	@AssetIP nvarchar(18)
AS 
with _ccmrr as (
    select AssetId,[Id] as RuleId,[Policy] as PolicyId,[State]
    from (
        select a.AssetId, aii.UniqueName,invp.PropertyName,isNull(issp.PropertyValue, iip.PropertyValue) as PropertyValue, iic.NextRevisionId
        from Asset a 
        inner join AssetInventoryItem aii on a.AssetId = aii.AssetId
        inner join InventoryItemChange iic on aii.AssetInventoryItemId = iic.AssetInventoryItemId
        inner join ItemProperty ip on ip.ItemPropertyId = iic.ItemPropertyId
        inner join InventoryProperty invp on ip.InventoryPropertyId = invp.InventoryPropertyId
        left outer join ItemShortStringProperty issp on ip.ItemPropertyId = issp.ItemPropertyId
        left outer join ItemIntProperty iip on ip.ItemPropertyId = iip.ItemPropertyId
        where
            iic.NextRevisionId = 2147483646 and
            iic.IsDeleted = 0 and 
            aii.InventoryCategoryId = 4
    ) p PIVOT ( MAX(PropertyValue) for PropertyName IN ([Id],[Policy],[State]) ) as pvt
),
_ccmtr as (
        select AssetId,TestId,RuleId,PolicyId,[Actual],[Expected],[State]
        from (
                select
                    a.AssetId,
                    case when charindex(' ', aii.UniqueName) > 0 then 
                        cast(parsename(replace(left(aii.UniqueName, charindex(' ',aii.UniqueName)-1),':','.'),1) as int)
                    else
                        cast(parsename(replace(aii.UniqueName,':','.'),1) as int)
                    end as TestId,
                    case when charindex(' ', aii.UniqueName) > 0 then 
                        cast(parsename(replace(left(aii.UniqueName, charindex(' ',aii.UniqueName)-1),':','.'),2) as int)
                    else
                        cast(parsename(replace(aii.UniqueName,':','.'),2) as int)
                    end as RuleId,
                    case when charindex(' ', aii.UniqueName) > 0 then 
                        cast(parsename(replace(left(aii.UniqueName, charindex(' ',aii.UniqueName)-1),':','.'),3) as int)
                    else
                        cast(parsename(replace(aii.UniqueName,':','.'),3) as int)
                    end as PolicyId,
                    invp.PropertyName,
                    isNull(cast(isp.PropertyValue as nvarchar(max)),issp.PropertyValue) as PropertyValue
                from Asset a 
                inner join AssetInventoryItem aii on a.AssetId = aii.AssetId
                inner join InventoryItemChange iic on aii.AssetInventoryItemId = iic.AssetInventoryItemId
                inner join ItemProperty ip on ip.ItemPropertyId = iic.ItemPropertyId
                inner join InventoryProperty invp on ip.InventoryPropertyId = invp.InventoryPropertyId
                left outer join ItemShortStringProperty issp on ip.ItemPropertyId = issp.ItemPropertyId
                left outer join ItemStringProperty isp on ip.ItemPropertyId = isp.ItemPropertyId
                where
                        iic.NextRevisionId = 2147483646
                        and iic.IsDeleted = 0
                        and aii.InventoryCategoryId = 5
        ) p PIVOT ( MAX(PropertyValue) for PropertyName IN ([Actual],[Expected],[State]) ) as pvt
),
_ccmpr as (
        select AssetId,PolicyId,[Last Evaluated],[State]
        from (
                select a.AssetId,aii.UniqueName as PolicyId,invp.PropertyName, issp.PropertyValue
                from Asset a 
                inner join AssetInventoryItem aii on a.AssetId = aii.AssetId
                inner join InventoryItemChange iic on aii.AssetInventoryItemId = iic.AssetInventoryItemId
                inner join ItemProperty ip on ip.ItemPropertyId = iic.ItemPropertyId
                inner join InventoryProperty invp on ip.InventoryPropertyId = invp.InventoryPropertyId
                inner join ItemShortStringProperty issp on ip.ItemPropertyId = issp.ItemPropertyId
                where
                iic.NextRevisionId = 2147483646 
                and iic.IsDeleted = 0
                and aii.InventoryCategoryId = 3
        ) p PIVOT ( MAX(PropertyValue) for PropertyName IN ([Last Evaluated],[State]) ) as pvt
)
select ag.Name as assetgroup, ar.hostname, ar.IP, ar.os + ' ' + ar.osversion AS os, ar.CompState as compliancestate, pr.State as policycompliancestate, cp.Name as policyname, cr.Name as rulename, ct.Name as testname, ctt.Name as testtype, tr.state as teststate, tr.Expected, tr.Actual,convert(datetime,cast(pr.[Last Evaluated] as datetime),120) as lastscandate
from _ccmpr pr
join _ccmrr rr on pr.PolicyId = rr.PolicyId and pr.AssetId = rr.AssetId
join _ccmtr tr on tr.PolicyId = rr.PolicyId and tr.RuleId = rr.RuleId and tr.AssetId = rr.AssetId
join Asset a on a.AssetId = pr.AssetId
join AssetRecord ar on ar.AssetRecordId = a.CurrentRecordId
join CompPolicy cp on cp.CompPolicyId = pr.PolicyId
join CompRule cr on cr.CompRuleId = rr.RuleId
join CompTest ct on ct.CompTestId = tr.TestId
join CompTestType ctt on ctt.CompTestTypeId = ct.CompTestTypeId
join CompRuleTestAsn crta on crta.CompRuleId = tr.RuleId and crta.CompTestId = tr.TestId
join CompPolicyRuleAsn cpra on cpra.CompPolicyId = tr.PolicyId and cpra.CompRuleId = tr.RuleId
join AssetGroup ag on ag.AssetGroupId = a.AssetGroupId
where
    crta.CompRuleCriteriaId != 1 and
    cpra.CompRuleCriteriaId != 1 and
	ar.IP = @AssetIP
GO

--exec CCMComplianceByAsset '127.0.0.1'

EXEC [dbo].[CCMComplianceByAsset] '10.248.230.109'
GO
DROP PROCEDURE [dbo].[CCMComplianceByAsset]
GO

-------------------
select ic.InventoryCategoryId, ic.CategoryName, PropertyName, ip.Description
from InventoryCategory ic
join InventoryProperty ip on ip.InventoryCategoryId = ic.InventoryCategoryId
where
	ic.IsCustom = 0 and
	ic.IsSystem = 1 and
	ip.IsCustom = 0 and
	ip.IsSystem = 1
order by ic.InventoryCategoryId

-----------------------
display all assets and their advanced scans if it contains FIM files
SELECT
               'Asset Group' as Type,
               sc.AssetGroupId as TypeId,
               st.ScanTaskID,
               st.ScanTaskName,
               st.Enabled as ScanTaskEnabled,
               cn.NodeName,
               cn.NodeValue,
               ar.IP
FROM ScanTask st
JOIN ScanConfig sc ON sc.ScanConfigId = st.ScanConfigId
join assetgroup ag on ag.AssetGroupId = sc.AssetGroupId
JOIN Configurationnode cn on cn.configurationid = st.configurationid
join Asset as a on a.AssetGroupId = ag.AssetGroupId
join AssetRecord ar on a.CurrentRecordId = ar.AssetRecordId

where st.TaskType = 2 and NodeName = 'path'

UNION ALL
SELECT
               'Meta Asset' as Type,
               sc.MetaAssetId as TypeId,
               st.ScanTaskID,
               st.ScanTaskName,
               st.Enabled as ScanTaskEnabled,
               cn.NodeName,
               cn.NodeValue,
               ar.IP
FROM ScanTask st
JOIN ScanConfig sc ON sc.ScanConfigId = st.ScanConfigId
join metaasset ma on ma.MetaAssetId = sc.MetaAssetId
JOIN Configurationnode cn on cn.configurationid = st.configurationid
join Asset as a on a.MetaAssetId = ma.MetaAssetId
join AssetRecord ar on a.CurrentRecordId = ar.AssetRecordId
where st.TaskType = 2 and NodeName = 'path'

UNION ALL
SELECT
               'Asset' as Type,
               sc.AssetId as TypeId,
               st.ScanTaskID,
               st.ScanTaskName,
               st.Enabled as ScanTaskEnabled,
               cn.NodeName,
               cn.NodeValue,
			   ar.IP
FROM ScanTask st
JOIN ScanConfig sc ON sc.ScanConfigId = st.ScanConfigId
join asset a on a.AssetId = sc.AssetId
JOIN Configurationnode cn on cn.configurationid = st.configurationid
join AssetRecord ar on a.CurrentRecordId = ar.AssetRecordId
where st.TaskType = 2 and NodeName = 'path'

UNION ALL
SELECT
               'Network Profile' as Type,
               sc.NetworkProfileId as TypeId,
               st.ScanTaskID,
               st.ScanTaskName,
               st.Enabled as ScanTaskEnabled,
               cn.NodeName,
               cn.NodeValue,
               ar.IP
FROM ScanTask st
JOIN ScanConfig sc ON sc.ScanConfigId = st.ScanConfigId
join networkprofile np on np.NetworkProfileId = sc.NetworkProfileId
JOIN Configurationnode cn on cn.configurationid = st.configurationid
join Asset as a on a.NetworkProfileId = np.NetworkProfileId 
join AssetRecord ar on a.CurrentRecordId = ar.AssetRecordId

where st.TaskType = 2 and NodeName = 'path'

----------------------------------------------
display all assets and their group
select ag.Name as AssetGroupName, np.ProfileName, ar.IP, ar.Hostname, ar.OS, ar.OSVersion, Licensed, Up
from Asset a
join AssetRecord ar on a.CurrentRecordId = ar.AssetRecordId
join AssetGroup ag on ag.AssetGroupId = a.AssetGroupId
join MetaAsset mag on mag.MetaAssetId = a.MetaAssetId
join NetworkProfile np on np.NetworkProfileId = a.NetworkProfileId
order by ag.Name
---------------------------------------------
display all scans configured at all levels
SELECT
               'Asset Group' AS Type,
               ag.Name,
               st.ScanTaskID,
               st.ScanTaskName,
               st.EnableTrace,
               CASE st.TaskType
                              WHEN 0 THEN 'Discovery Ping Sweep'
                              WHEN 1 THEN 'Port Scan'
                              WHEN 2 THEN 'Advanced Scan'
                              WHEN 4 THEN 'Web Content Scan'
                              WHEN 5 THEN 'Vulnerability Scan'
                              WHEN 7 THEN 'Alert'
                              WHEN 8 THEN 'Gather Host Information'
                              WHEN 9 THEN 'Compliance Policy Evaluate'
                              WHEN 10 THEN 'SCAP Content Scan'
                              ELSE 'Unknown'
               END AS TaskType,
               st.Enabled
FROM ScanTask st
JOIN ScanConfig sc ON sc.ScanConfigId = st.ScanConfigId
JOIN AssetGroup ag ON ag.AssetGroupId = sc.AssetGroupId
UNION ALL
SELECT
               'Network Profile' AS Type,
               ProfileName AS Name,
               st.ScanTaskID,
               st.ScanTaskName,
               st.EnableTrace,
               CASE st.TaskType
                              WHEN 0 THEN 'Discovery Ping Sweep'
                              WHEN 1 THEN 'Port Scan'
                              WHEN 2 THEN 'Advanced Scan'
                              WHEN 4 THEN 'Web Content Scan'
                              WHEN 5 THEN 'Vulnerability Scan'
                              WHEN 7 THEN 'Alert'
                              WHEN 8 THEN 'Gather Host Information'
                              WHEN 9 THEN 'Compliance Policy Evaluate'
                              WHEN 10 THEN 'SCAP Content Scan'
                              ELSE 'Unknown'
               END AS TaskType,
               st.Enabled
FROM ScanTask st
JOIN ScanConfig sc ON sc.ScanConfigId = st.ScanConfigId
JOIN NetworkProfile pf ON pf.NetworkProfileID = sc.NetworkProfileId
UNION ALL
SELECT
               'Meta Asset' AS Type,
               MetaAssetName AS Name,
               st.ScanTaskID,
               st.ScanTaskName,
               st.EnableTrace,
               CASE st.TaskType
                              WHEN 0 THEN 'Discovery Ping Sweep'
                              WHEN 1 THEN 'Port Scan'
                              WHEN 2 THEN 'Advanced Scan'
                              WHEN 4 THEN 'Web Content Scan'
                              WHEN 5 THEN 'Vulnerability Scan'
                              WHEN 7 THEN 'Alert'
                              WHEN 8 THEN 'Gather Host Information'
                              WHEN 9 THEN 'Compliance Policy Evaluate'
                              WHEN 10 THEN 'SCAP Content Scan'
                              ELSE 'Unknown'
               END AS TaskType,
               st.Enabled
FROM ScanTask st
JOIN ScanConfig sc ON sc.ScanConfigId = st.ScanConfigId
JOIN MetaAsset ma ON ma.MetaAssetId = sc.MetaAssetId
UNION ALL
SELECT
               'Asset' AS Type,
               ar.hostname + ' (' + ar.IP + ')' AS Name,
               st.ScanTaskID,
               st.ScanTaskName,
               st.EnableTrace,
               CASE st.TaskType
                              WHEN 0 THEN 'Discovery Ping Sweep'
                              WHEN 1 THEN 'Port Scan'
                              WHEN 2 THEN 'Advanced Scan'
                              WHEN 4 THEN 'Web Content Scan'
                              WHEN 5 THEN 'Vulnerability Scan'
                              WHEN 7 THEN 'Alert'
                              WHEN 8 THEN 'Gather Host Information'
                              WHEN 9 THEN 'Compliance Policy Evaluate'
                              WHEN 10 THEN 'SCAP Content Scan'
                              ELSE 'Unknown'
               END AS TaskType,
               st.Enabled
FROM ScanTask st
JOIN ScanConfig sc ON sc.ScanConfigId = st.ScanConfigId
JOIN Asset a ON a.AssetId = sc.AssetId
JOIN AssetRecord ar on ar.AssetRecordId = a.CurrentRecordId
order by Type
-----------------------------
display all advanced scans profiles with FIM paths
SELECT
               'Asset Group' as Type,
               sc.AssetGroupId as TypeId,
               st.ScanTaskID,
               st.ScanTaskName,
               st.Enabled as ScanTaskEnabled,
               cn.NodeName,
               cn.NodeValue
FROM ScanTask st
JOIN ScanConfig sc ON sc.ScanConfigId = st.ScanConfigId
join assetgroup ag on ag.AssetGroupId = sc.AssetGroupId
JOIN Configurationnode cn on cn.configurationid = st.configurationid
where st.TaskType = 2 and NodeName = 'path'
UNION ALL
SELECT
               'Meta Asset' as Type,
               sc.MetaAssetId as TypeId,
               st.ScanTaskID,
               st.ScanTaskName,
               st.Enabled as ScanTaskEnabled,
               cn.NodeName,
               cn.NodeValue
FROM ScanTask st
JOIN ScanConfig sc ON sc.ScanConfigId = st.ScanConfigId
join metaasset ma on ma.MetaAssetId = sc.MetaAssetId
JOIN Configurationnode cn on cn.configurationid = st.configurationid
where st.TaskType = 2 and NodeName = 'path'
UNION ALL
SELECT
               'Asset' as Type,
               sc.AssetId as TypeId,
               st.ScanTaskID,
               st.ScanTaskName,
               st.Enabled as ScanTaskEnabled,
               cn.NodeName,
               cn.NodeValue
FROM ScanTask st
JOIN ScanConfig sc ON sc.ScanConfigId = st.ScanConfigId
join asset a on a.AssetId = sc.AssetId
JOIN Configurationnode cn on cn.configurationid = st.configurationid
where st.TaskType = 2 and NodeName = 'path'
UNION ALL
SELECT
               'Network Profile' as Type,
               sc.NetworkProfileId as TypeId,
               st.ScanTaskID,
               st.ScanTaskName,
               st.Enabled as ScanTaskEnabled,
               cn.NodeName,
               cn.NodeValue
FROM ScanTask st
JOIN ScanConfig sc ON sc.ScanConfigId = st.ScanConfigId
join networkprofile np on np.NetworkProfileId = sc.NetworkProfileId
JOIN Configurationnode cn on cn.configurationid = st.configurationid
where st.TaskType = 2 and NodeName = 'path'
-----------------------------------
CCM and SIH maintenance queries
use for105db
GO
exec sp_updatestats

USE for105db
GO
-- Declare variables
SET NOCOUNT ON;
DECLARE @tablename VARCHAR(128);
DECLARE @execstr VARCHAR(255);
DECLARE @objectid INT;
DECLARE @indexid INT;
DECLARE @frag decimal;
DECLARE @maxfrag decimal;
-- Decide on the maximum fragmentation to allow for.
SELECT @maxfrag = 30.0;
-- Declare a cursor.
DECLARE tables CURSOR FOR
SELECT CAST(TABLE_SCHEMA AS VARCHAR(100))
+'.'+CAST(TABLE_NAME AS VARCHAR(100))
AS Table_Name
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE';
-- Create the table.
CREATE TABLE #fraglist (
ObjectName CHAR(255),
ObjectId INT,
IndexName CHAR(255),
IndexId INT,
Lvl INT,
CountPages INT,
CountRows INT,
MinRecSize INT,
MaxRecSize INT,
AvgRecSize INT,
ForRecCount INT,
Extents INT,
ExtentSwitches INT,
AvgFreeBytes INT,
AvgPageDensity INT,
ScanDensity decimal,
BestCount INT,
ActualCount INT,
LogicalFrag decimal,
ExtentFrag decimal);
-- Open the cursor.
OPEN tables;
-- Loop through all the tables in the database.
FETCH NEXT
FROM tables
INTO @tablename;
WHILE @@FETCH_STATUS = 0
BEGIN;
-- Do the showcontig of all indexes of the table
INSERT INTO #fraglist
EXEC ('DBCC SHOWCONTIG (''' + @tablename + ''')
WITH FAST, TABLERESULTS, ALL_INDEXES, NO_INFOMSGS');
FETCH NEXT
FROM tables
INTO @tablename;
END;

-- Close and deallocate the cursor.
CLOSE tables;
DEALLOCATE tables;
-- Declare the cursor for the list of indexes to be defragged.
DECLARE indexes CURSOR FOR
SELECT ObjectName, ObjectId, IndexId, LogicalFrag
FROM #fraglist
WHERE LogicalFrag >= @maxfrag
AND INDEXPROPERTY (ObjectId, IndexName, 'IndexDepth') > 0;
-- Open the cursor.
OPEN indexes;
-- Loop through the indexes.
FETCH NEXT
FROM indexes
INTO @tablename, @objectid, @indexid, @frag;
WHILE @@FETCH_STATUS = 0

BEGIN;
PRINT 'Executing DBCC INDEXDEFRAG (0, ' + RTRIM(@tablename) + ',
' + RTRIM(@indexid) + ') - fragmentation currently '
+ RTRIM(CONVERT(VARCHAR(15),@frag)) + '%';
SELECT @execstr = 'DBCC INDEXDEFRAG (0, ' + RTRIM(@objectid) + ',
' + RTRIM(@indexid) + ')';
EXEC (@execstr);
FETCH NEXT
FROM indexes
INTO @tablename, @objectid, @indexid, @frag;
END;
-- Close and deallocate the cursor.
CLOSE indexes;
DEALLOCATE indexes;
-- Delete the temporary table.
DROP TABLE #fraglist;
GO
----------------------------------------------
