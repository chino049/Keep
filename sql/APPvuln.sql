select nc_vuln.vuln_id, nc_vuln.name as vuln_name, 
       nc_vuln.application as vuln_app, 
       nc_vuln_rule.vuln_rule_id as vuln_rule_id, 
       nc_vuln_rule.application_id as vuln_rule_app_id, 
       nc_application_vuln.application_id as app_vuln_id, 
       nc_application.name as app_name, 
       nc_application.parent as app_parent 
       from nc_application_vuln 
       join nc_application using (application_id) 
       join nc_vuln using (vuln_id) 
       join nc_vuln_rule using (vuln_id) 
       where nc_vuln.vuln_id = 22440  and nc_application_vuln.application_id = 3079;



select nc_vuln.vuln_id, nc_vuln.name as vuln_name, 
       nc_vuln_rule.vuln_rule_id as vuln_rule_id, 
       nc_vuln_rule.application_id as vuln_rule_app_id, 
       nc_application_vuln.application_id, nc_application.name as app_name, 
       nc_application.parent as app_parent 
       from nc_application_vuln 
       join nc_application using (application_id)
       join nc_vuln using (vuln_id) 
       join nc_vuln_rule using (vuln_id) 
       where nc_vuln.vuln_id = 22440 and nc_application.application_id = 3079;


select nc_application_vuln.vuln_id as app_vuln_vulnID, nc_application_vuln.application_id as app_vuln_appID, nc_application.name as app_name, nc_vuln.name as vuln_name, nc_application.parent as app_parent from nc_application_vuln join nc_application using (application_id) join nc_vuln using (vuln_id) where vuln_id = 57117 and application_id = 3079 or application_id = 10640 order by vuln_id;

select name, application_id, parent from nc_application where application_id =5838 or application_id = 3079 or application_id = 10686 or application_id = 10640 or application_id = 8709 or application_id = 8970 order by parent;

select nc_application_vuln.vuln_id as app_vuln_vulnID, nc_application_vuln.application_id as app_vuln_appID, nc_application.name as app_name, nc_vuln.name as vuln_name, nc_application.parent as app_parent from nc_application_vuln join nc_application using (application_id) join nc_vuln using (vuln_id) where vuln_id = 22440 and application_id = 1843 or application_id = 3079 order by vuln_id;

--------------

select nc_application_vuln.vuln_id as app_vuln_vulnID, nc_application_vuln.application_id as app_vuln_appID, nc_application.name as app_name, nc_vuln.name as vuln_name, nc_application.parent as app_parent from nc_application_vuln join nc_application using (application_id) join nc_vuln using (vuln_id) where vuln_id = 3595 and application_id = 3409;
 app_vuln_vulnid | app_vuln_appid |                   app_name                   |                           vuln_name                            | app_parent 
-----------------+----------------+----------------------------------------------+----------------------------------------------------------------+------------
            3595 |           3409 | Microsoft Windows Direct SMB Session Service | MS04-011: Microsoft Windows LSASS Buffer Overrun Vulnerability |        385
(1 row)

jopVNEzaragoza ice=# select nc_application_vuln.vuln_id as app_vuln_vulnID, nc_application_vuln.application_id as app_vuln_appID, nc_application.name as app_name, nc_vuln.name as vuln_name, nc_application.parent as app_parent from nc_application_vuln join nc_application using (application_id) join nc_vuln using (vuln_id) where vuln_id = 57117 and application_id = 3079 ;
 app_vuln_vulnid | app_vuln_appid |     app_name     |                            vuln_name                            | app_parent 
-----------------+----------------+------------------+-----------------------------------------------------------------+------------
           57117 |           3079 | Windows Registry | MS12-076: Excel SST Invalid Length Use After Free Vulnerability |       8709

select vuln_id, application_id, nc_application.name  from nc_vuln_application join nc_application using (application_id)  where vuln_id = 3595;
 vuln_id | application_id |                     name                     
---------+----------------+----------------------------------------------
    3595 |           3409 | Microsoft Windows Direct SMB Session Service

select vuln_id, application_id,  nc_application.name from nc_vuln_application join nc_application using (application_id)  where vuln_id = 57117;
 vuln_id | application_id |       name       
---------+----------------+------------------
   57117 |           3079 | Windows Registry

---------------------------------------------------------------------------------------------
SELECT nc_vuln_rule.application_id as vuln_rule_app_id, nc_application_tree.name as app_tree_name, nc_vuln_rule.app_match_required as vuln_rule_app_match, nc_vuln_result.host_id as vuln_rule_host_id, nc_host.ip_address as host_ip_add
                          FROM nc_application_tree 
                          INNER JOIN 
                          (select custom_vuln_id AS vuln_id, application_id FROM nc_custom_vuln_application 
                          UNION ALL 
                          SELECT vuln_id, application_id FROM nc_vuln_application) 
                          AS vuln_application USING (application_id) 
                          join nc_vuln_rule using (vuln_id) 
                          join nc_vuln_result using (vuln_id) 
                          join nc_host using (host_id) 
                          WHERE vuln_application.vuln_id = 12176 and nc_vuln_result.audit_id = 464 and nc_host.ip_address = '10.64.0.85';

----------------------------------------------------------------------------------------------
 SELECT vuln_id, nc_vuln_application.application_id, nc_vuln_rule.vuln_rule_id, nc_vuln_rule.vuln_id, nc_vuln_rule.application_id 
                          FROM nc_vuln_application 
                          join nc_vuln_rule using (vuln_id) 
                          where vuln_id = 12176 ;

vuln_id | application_id | vuln_rule_id | vuln_id | application_id 
---------+----------------+--------------+---------+----------------
   12176 |           3079 |       330341 |   12176 |           3409
   12176 |           3079 |       330339 |   12176 |           3409
   12176 |           3079 |       594506 |   12176 |           3241
   12176 |           3079 |       594507 |   12176 |           3332
   12176 |           3079 |       594508 |   12176 |           4657
   12176 |           3079 |       594509 |   12176 |           8949
   12176 |           3079 |       594510 |   12176 |           8957


------------------------------------------------from db_ontology.inv 
SELECT application_id as id, name 
                          FROM nc_application_tree 
                          INNER JOIN 
                          (select custom_vuln_id AS vuln_id, application_id FROM nc_custom_vuln_application 
                          UNION ALL 
                          SELECT vuln_id, application_id FROM nc_vuln_application) 
                          AS vuln_application USING (application_id) 
                          WHERE vuln_application.vuln_id = 12176; 

----------------------------------------------------
SELECT vuln_id, application_id FROM nc_vuln_application WHERE nc_vuln_application.vuln_id = 12176;
 vuln_id | application_id 
---------+----------------
   12176 |           3079

-----------------------------------------------------using nc_vuln_application.application_id
SELECT vuln_id, nc_vuln_application.application_id as vuln_app_app_id, nc_vuln_rule.application_id as vuln_rule_app_id, nc_vuln_rule.vuln_rule_id as vuln_rule_id, nc_vuln_rule.app_match_required as vuln_rule_match, nc_application_tree.name as app_tree_name
                           FROM nc_vuln_application
                           join nc_vuln_rule using (vuln_id)
                           join nc_application_tree on nc_application_tree.application_id = nc_vuln_application.application_id
                           WHERE nc_vuln_application.vuln_id = 12176 and vuln_rule_id = 330341;

-------------------------------------------------------using nc_vuln_rule.application_id
SELECT vuln_id, nc_vuln_rule.application_id as vuln_rule_app_id, nc_vuln_rule.vuln_rule_id as vuln_rule_id, nc_vuln_rule.app_match_required as vuln_rule_match, nc_application_tree.name as app_tree_name
                           FROM nc_vuln_application
                           join nc_vuln_rule using (vuln_id)
                           join nc_application_tree on nc_application_tree.application_id = nc_vuln_rule.application_id
                           WHERE nc_vuln_application.vuln_id = 12176 and vuln_rule_id = 330341;

-----------------------------------------------------

SELECT application_id as id, name FROM nc_application_tree
INNER JOIN
(select custom_vuln_id AS vuln_id, application_id FROM nc_custom_vuln_application
UNION ALL
SELECT vuln_id, application_id FROM nc_vuln_rule) AS vuln_rule USING (application_id)
WHERE vuln_rule.vuln_id = 12176;



-----------------------------------------------------
SELECT vuln_id, application_id FROM nc_vuln_application WHERE vuln_id = 5555;
 vuln_id | application_id 
---------+----------------
    5555 |           1352

SELECT vuln_id, application_id FROM nc_vuln_application WHERE vuln_id = 22362;
 vuln_id | application_id 
---------+----------------
   22362 |           3079

------------------------------------------------------

SELECT vuln_id, nc_vuln_application.application_id as vuln_app_app_id, nc_vuln_rule.application_id as vuln_rule_app_id, nc_vuln_rule.vuln_rule_id as vuln_rule_id, nc_vuln_rule.app_match_required as vuln_rule_match, nc_application_tree.name as app_tree_name
				FROM nc_vuln_application
				join nc_vuln_rule using (vuln_id)
				join nc_application_tree on nc_application_tree.application_id = nc_vuln_application.application_id
				WHERE nc_vuln_application.vuln_id = 5555;

 vuln_id | vuln_app_app_id | vuln_rule_app_id | vuln_rule_id | vuln_rule_match |               app_tree_name               
---------+-----------------+------------------+--------------+-----------------+-------------------------------------------
    5555 |            1352 |             3241 |       158066 | t               | Microsoft Windows NetBIOS Session Service
    5555 |            1352 |             3332 |       158067 | t               | Microsoft Windows NetBIOS Session Service
    5555 |            1352 |             2112 |       158068 | t               | Microsoft Windows NetBIOS Session Service
    5555 |            1352 |                  |        25629 | t               | Microsoft Windows NetBIOS Session Service
    5555 |            1352 |             3409 |        25630 | t               | Microsoft Windows NetBIOS Session Service
(5 rows)

SELECT vuln_id, nc_vuln_rule.application_id as vuln_rule_app_id, nc_vuln_rule.vuln_rule_id as vuln_rule_id, nc_vuln_rule.app_match_required as vuln_rule_match, nc_application_tree.name as app_tree_name
				FROM nc_vuln_application
				join nc_vuln_rule using (vuln_id)
				join nc_application_tree on nc_application_tree.application_id = nc_vuln_rule.application_id
				WHERE nc_vuln_application.vuln_id = 5555;
 vuln_id | vuln_rule_app_id | vuln_rule_id | vuln_rule_match |                app_tree_name                 
---------+------------------+--------------+-----------------+----------------------------------------------
    5555 |             3241 |       158066 | t               | Windows 2000
    5555 |             3332 |       158067 | t               | Windows XP
    5555 |             2112 |       158068 | t               | Windows 2003 Release
    5555 |             3409 |        25630 | t               | Microsoft Windows Direct SMB Session Service
(4 rows)

SELECT vuln_id, nc_vuln_application.application_id as vuln_app_app_id, nc_vuln_rule.application_id as vuln_rule_app_id, nc_vuln_rule.vuln_rule_id as vuln_rule_id, nc_vuln_rule.app_match_required as vuln_rule_match, nc_application_tree.name as app_tree_name
                           FROM nc_vuln_application
                           join nc_vuln_rule using (vuln_id)
                           join nc_application_tree on nc_application_tree.application_id = nc_vuln_application.application_id
                           WHERE nc_vuln_application.vuln_id = 22362;
 vuln_id | vuln_app_app_id | vuln_rule_app_id | vuln_rule_id | vuln_rule_match |  app_tree_name   
---------+-----------------+------------------+--------------+-----------------+------------------
   22362 |            3079 |             8957 |       464507 | t               | Windows Registry
   22362 |            3079 |             5000 |       464506 | t               | Windows Registry
   22362 |            3079 |             3241 |       463858 | t               | Windows Registry
   22362 |            3079 |             8949 |       669083 | t               | Windows Registry
   22362 |            3079 |             8946 |       669082 | t               | Windows Registry
   22362 |            3079 |             8863 |       669081 | t               | Windows Registry
   22362 |            3079 |             8861 |       669080 | t               | Windows Registry
   22362 |            3079 |             4657 |       669079 | t               | Windows Registry
   22362 |            3079 |             8974 |       669084 | t               | Windows Registry
(9 rows)

SELECT vuln_id, nc_vuln_rule.application_id as vuln_rule_app_id, nc_vuln_rule.vuln_rule_id as vuln_rule_id, nc_vuln_rule.app_match_required as vuln_rule_match, nc_application_tree.name as app_tree_name
                           FROM nc_vuln_application
                           join nc_vuln_rule using (vuln_id)
                           join nc_application_tree on nc_application_tree.application_id = nc_vuln_rule.application_id
                           WHERE nc_vuln_application.vuln_id = 22362;
 vuln_id | vuln_rule_app_id | vuln_rule_id | vuln_rule_match |      app_tree_name      
---------+------------------+--------------+-----------------+-------------------------
   22362 |             8957 |       464507 | t               | Windows XP x64
   22362 |             5000 |       464506 | t               | Windows XP (32 bit)
   22362 |             3241 |       463858 | t               | Windows 2000
   22362 |             8949 |       669083 | t               | Windows 2003 x64
   22362 |             8946 |       669082 | t               | Windows Vista x64
   22362 |             8863 |       669081 | t               | Windows Server 2008
   22362 |             8861 |       669080 | t               | Windows Vista
   22362 |             4657 |       669079 | t               | Windows 2003
   22362 |             8974 |       669084 | t               | Windows Server 2008 x64


select application_id, vuln_id, vuln_rule_id, rule_id, app_match_required, host_id from nc_vuln_rule join nc_vuln_result using (vuln_id) where vuln_id = 5555 and audit_id = 464;

select application_id, vuln_id, vuln_rule_id, rule_id, app_match_required, host_id from nc_vuln_rule join nc_vuln_result using (vuln_id) where vuln_id = 5555 and audit_id = 464 and host_id = 54897;

select vuln_id, audit_id, host_id, rule_id from nc_vuln_result where audit_id = 464 and vuln_id = 5555  and host_id = 54897;
select vuln_id, audit_id, host_id, rule_id from nc_vuln_result where audit_id = 464 and vuln_id = 22362 and host_id = 55162;

select vuln_id, audit_id, host_id, rule_id, application_id from nc_vuln_result join nc_vuln_rule using (vuln_id) where audit_id = 464 and vuln_id = 5555  and host_id = 54897;
select vuln_id, audit_id, host_id, rule_id, application_id from nc_vuln_result join nc_vuln_rule using (vuln_id) where audit_id = 464 and vuln_id = 22362  and host_id = 55162;


select vuln_id, audit_id, host_id, rule_id, application_id, name from nc_vuln_result join nc_vuln_rule using (vuln_id) join nc_application_tree using (application_id) where audit_id = 464 and vuln_id = 22362  and host_id = 55162;
 vuln_id | audit_id | host_id | rule_id | application_id |          name           
---------+----------+---------+---------+----------------+-------------------------
   22362 |      464 |   55162 |  669083 |           8957 | Windows XP x64
   22362 |      464 |   55162 |  669083 |           5000 | Windows XP (32 bit)
   22362 |      464 |   55162 |  669083 |           3241 | Windows 2000
   22362 |      464 |   55162 |  669083 |           8949 | Windows 2003 x64
   22362 |      464 |   55162 |  669083 |           8946 | Windows Vista x64
   22362 |      464 |   55162 |  669083 |           8863 | Windows Server 2008
   22362 |      464 |   55162 |  669083 |           8861 | Windows Vista
   22362 |      464 |   55162 |  669083 |           4657 | Windows 2003
   22362 |      464 |   55162 |  669083 |           8974 | Windows Server 2008 x64

select vuln_id, audit_id, host_id, rule_id, application_id, name from nc_vuln_result join nc_vuln_rule using (vuln_id) join nc_application_tree using (application_id) where audit_id = 464 and vuln_id = 5555  and host_id = 54897;
 vuln_id | audit_id | host_id | rule_id | application_id |                     name                     
---------+----------+---------+---------+----------------+----------------------------------------------
    5555 |      464 |   54897 |  158068 |           3241 | Windows 2000
    5555 |      464 |   54897 |  158068 |           3332 | Windows XP
    5555 |      464 |   54897 |  158068 |           2112 | Windows 2003 Release
    5555 |      464 |   54897 |  158068 |           3409 | Microsoft Windows Direct SMB Session Service

select vuln_id, audit_id, application_id, name from nc_vuln_result inner join nc_application_vuln using (vuln_id) join nc_application_tree using (application_id) where audit_id = 464 and vuln_id = 22362 and host_id = 55162;


 select host_id , nc_vuln.application as vuln_app, nc_vuln_application.application_id as vuln_app_id, a.name as vuln_app_name, nc_vuln_rule.application_id as vuln_rule_app_id, nc_application_tree.name as rule_app_tree_name from nc_vuln_result inner join nc_vuln on nc_vuln_result.vuln_id = nc_vuln.vuln_id inner join nc_vuln_rule on nc_vuln_result.rule_id = nc_vuln_rule.vuln_rule_id inner join nc_vuln_application on nc_vuln.vuln_id = nc_vuln_application.vuln_id join nc_application_tree on nc_vuln_rule.application_id = nc_application_tree.application_id join nc_application_tree as a on nc_vuln_application.application_id  = a.application_id where nc_vuln_rule.vuln_id = 22362 and audit_id = 464;


SELECT vuln_id, nc_vuln_rule.application_id as vuln_rule_app_id, nc_vuln_rule.vuln_rule_id as vuln_rule_id, nc_vuln_rule.app_match_required as vuln_rule_match, nc_application_tree.name as app_tree_name
                           FROM nc_vuln_application
                           join nc_vuln_rule using (vuln_id)
                           join nc_application_tree on nc_application_tree.application_id = nc_vuln_rule.application_id join nc_vuln_result using (vuln_id)
                           WHERE nc_vuln_application.vuln_id = 22362 and host_id = 55162 and audit_id = 464;



select nc_vuln_result.vuln_result_id as vuln_res_id, nc_vuln_result.vuln_id as vuln_res_vuln_id , nc_vuln_result.rule_id as vuln_res_rule_id, nc_vuln_rule.vuln_rule_id as vuln_rule_rule_id from nc_vuln_result join nc_vuln_rule on nc_vuln_result.rule_id = nc_vuln_rule.vuln_rule_id where audit_id = 464 and nc_vuln_result.vuln_id = 22362;

select nc_vuln_result.vuln_result_id as vuln_res_id, nc_vuln_result.vuln_id as vuln_res_vuln_id , nc_vuln_result.rule_id as vuln_res_rule_id, nc_application_rule.application_rule_id as app_rule_rule_id from nc_vuln_result join nc_application_rule on nc_application_rule.application_rule_id = nc_vuln_result.rule_id where audit_id = 464 and nc_vuln_result.vuln_id = 22362;

select nc_vuln_result.vuln_result_id as vuln_res_id, nc_vuln_result.vuln_id as vuln_res_vuln_id , nc_vuln_result.rule_id as vuln_res_rule_id, nc_vuln_rule.vuln_rule_id as vuln_rule_rule_id, nc_vuln_rule.application_id as vuln_rule_app_id from nc_vuln_result join nc_vuln_rule on nc_vuln_result.rule_id = nc_vuln_rule.vuln_rule_id where audit_id = 464 and nc_vuln_result.vuln_id = 22362 and host_id = 55162;

select nc_vuln_result.vuln_result_id as vuln_res_id, nc_vuln_result.vuln_id as vuln_res_vuln_id , nc_vuln_result.rule_id as vuln_res_rule_id, nc_vuln_rule.vuln_rule_id as vuln_rule_rule_id, nc_vuln_rule.application_id as vuln_rule_app_id from nc_vuln_result join nc_vuln_rule on nc_vuln_result.rule_id = nc_vuln_rule.vuln_rule_id where audit_id = 464 and nc_vuln_result.vuln_id = 5555 and host_id = 54897;

---------
select nc_vuln_result.vuln_result_id as vuln_res_id, nc_vuln_result.vuln_id as vuln_res_vuln_id , nc_vuln_result.rule_id as vuln_res_rule_id, nc_vuln_rule.vuln_rule_id as vuln_rule_rule_id, nc_vuln_rule.application_id as vuln_rule_app_id, nc_application_tree.name from nc_vuln_result join nc_vuln_rule on nc_vuln_result.rule_id = nc_vuln_rule.vuln_rule_id join nc_application_tree using (application_id) where audit_id = 464 and nc_vuln_result.vuln_id = 5555 and host_id = 54897;
 vuln_res_id | vuln_res_vuln_id | vuln_res_rule_id | vuln_rule_rule_id | vuln_rule_app_id |         name         
-------------+------------------+------------------+-------------------+------------------+----------------------
     3333662 |             5555 |           158068 |            158068 |             2112 | Windows 2003 Release
(1 row)

jopVNEzaragoza ice=# select nc_vuln_result.vuln_result_id as vuln_res_id, nc_vuln_result.vuln_id as vuln_res_vuln_id , nc_vuln_result.rule_id as vuln_res_rule_id, nc_vuln_rule.vuln_rule_id as vuln_rule_rule_id, nc_vuln_rule.application_id as vuln_rule_app_id, nc_application_tree.name from nc_vuln_result join nc_vuln_rule on nc_vuln_result.rule_id = nc_vuln_rule.vuln_rule_id join nc_application_tree using (application_id) where audit_id = 464 and nc_vuln_result.vuln_id = 22362 and host_id = 55162;
 vuln_res_id | vuln_res_vuln_id | vuln_res_rule_id | vuln_rule_rule_id | vuln_rule_app_id |       name       
-------------+------------------+------------------+-------------------+------------------+------------------
     3347461 |            22362 |           669083 |            669083 |             8949 | Windows 2003 x64
(1 row)

select nc_vuln_result.host_id as vuln_res_host_id, nc_vuln_result.vuln_result_id as vuln_res_id, nc_vuln_result.vuln_id as vuln_res_vuln_id , nc_vuln_result.rule_id as vuln_res_rule_id, nc_vuln_rule.vuln_rule_id as vuln_rule_rule_id, nc_vuln_rule.application_id as vuln_rule_app_id, nc_application_tree.name from nc_vuln_result join nc_vuln_rule on nc_vuln_result.rule_id = nc_vuln_rule.vuln_rule_id join nc_application_tree using (application_id) where audit_id = 464 and nc_vuln_result.vuln_id = 22439;
 vuln_res_host_id | vuln_res_id | vuln_res_vuln_id | vuln_res_rule_id | vuln_rule_rule_id | vuln_rule_app_id |                 name                 
------------------+-------------+------------------+------------------+-------------------+------------------+--------------------------------------
            54907 |     3336928 |            22439 |           752448 |            752448 |             9045 | Microsoft Report Viewer 2008 Release
            54887 |     3331149 |            22439 |           752448 |            752448 |             9045 | Microsoft Report Viewer 2008 Release
            55162 |     3347472 |            22439 |           752438 |            752438 |             8949 | Windows 2003 x64
            54919 |     3338402 |            22439 |           752438 |            752438 |             8949 | Windows 2003 x64
            54892 |     3332582 |            22439 |           752438 |            752438 |             8949 | Windows 2003 x64
            54873 |     3329341 |            22439 |           752438 |            752438 |             8949 | Windows 2003 x64
            54906 |     3336478 |            22439 |           752439 |            752439 |             8957 | Windows XP x64
            54886 |     3330735 |            22439 |           752440 |            752440 |             8975 | Windows Server 2008 x64 SP1
            54897 |     3333898 |            22439 |           752431 |            752431 |             4657 | Windows 2003


select nc_vuln_result.host_id as vuln_res_host_id, nc_vuln_result.vuln_result_id as vuln_res_id, nc_vuln_result.vuln_id as vuln_res_vuln_id , nc_vuln_result.rule_id as vuln_res_rule_id, nc_vuln_rule.vuln_rule_id as vuln_rule_rule_id, nc_vuln_rule.application_id as vuln_rule_app_id, nc_application_tree.name from nc_vuln_result join nc_vuln_rule on nc_vuln_result.rule_id = nc_vuln_rule.vuln_rule_id join nc_application_tree using (application_id) where audit_id = 464 and nc_vuln_result.vuln_id = 22439 and host_id = 55162;
 vuln_res_host_id | vuln_res_id | vuln_res_vuln_id | vuln_res_rule_id | vuln_rule_rule_id | vuln_rule_app_id |       name       
------------------+-------------+------------------+------------------+-------------------+------------------+------------------
            55162 |     3347472 |            22439 |           752438 |            752438 |             8949 | Windows 2003 x64

select nc_application_tree.application_id, nc_application_tree.name from nc_vuln_result join nc_vuln_rule on nc_vuln_result.rule_id = nc_vuln_rule.vuln_rule_id join nc_application_tree using (application_id) where audit_id = 464 and nc_vuln_result.vuln_id = 22439 and host_id = 55162;
 application_id |       name       
----------------+------------------
           8949 | Windows 2003 x64


select public.nc_app_result_head.application_id, public.nc_application.name, lower(public.nc_application.name) as sort_col, public.nc_application.locally_detected,
                nc_comma_list(public.nc_app_result_head.port) as ports
                from public.nc_app_result_head inner join public.nc_application using (application_id)
                where public.nc_app_result_head.application_id != 0
                and public.nc_app_result_head.host_id = 55162
                group by 1, 2, 3, 4
                union
                select public.nc_app_result_head.protocol_id as application_id, public.nc_application_protocol.name, lower(public.nc_application_protocol.name) as sort_col, public.nc_application_protocol.locally_detected,
                nc_comma_list(public.nc_app_result_head.port) as ports
                from public.nc_app_result_head inner join public.nc_application_protocol on (public.nc_app_result_head.protocol_id = public.nc_application_protocol.application_id)
                where public.nc_app_result_head.application_id = 0
                and public.nc_app_result_head.protocol_id != 0
                and public.nc_app_result_head.host_id = 55162
                group by 1, 2, 3, 4


-------------------
                select public.nc_app_result_head.application_id, public.nc_vuln_result_head.vuln_id, public.nc_vuln.name, lower(public.nc_vuln.name) as sort_col, public.nc_vuln_result_head.score
                from public.nc_app_result_head inner join public.nc_application_vuln using (application_id)
                inner join public.nc_vuln_result_head using (vuln_id, host_id, port)
                inner join public.nc_vuln using (vuln_id)
                where public.nc_app_result_head.application_id != 0
                and public.nc_app_result_head.host_id = 55162
                group by 1, 2, 3, 4, 5
                union
                select public.nc_app_result_head.protocol_id as application_id, public.nc_vuln_result_head.vuln_id, public.nc_vuln.name, lower(public.nc_vuln.name) as sort_col, public.nc_vuln_result_head.score
                from public.nc_app_result_head inner join public.nc_application_vuln on (public.nc_app_result_head.protocol_id = public.nc_application_vuln.application_id)
                inner join public.nc_vuln_result_head using (vuln_id, host_id, port)
                inner join public.nc_vuln using (vuln_id)
                where public.nc_app_result_head.application_id = 0
                and public.nc_app_result_head.protocol_id != 0
                and public.nc_app_result_head.host_id = 55162
                group by 1, 2, 3, 4, 5
                order by sort_col

-------------------
select public.nc_vuln.vuln_id, public.nc_vuln.name, lower(public.nc_vuln.name) as sort_col, public.nc_vuln_result_head.score
                from public.nc_vuln_result_head inner join public.nc_vuln using (vuln_id)
                where public.nc_vuln_result_head.host_id = 55162 
                group by 1, 2, 3, 4
                union
                select public.nc_customer_vuln.customer_vuln_id as vuln_id, public.nc_customer_vuln.name, lower(public.nc_customer_vuln.name) as sort_col, public.nc_vuln_result_head.score
                from public.nc_vuln_result_head inner join public.nc_customer_vuln on (public.nc_vuln_result_head.vuln_id = public.nc_customer_vuln.customer_vuln_id)
                where public.nc_vuln_result_head.host_id = 55162
                group by 1, 2, 3, 4
                order by sort_col

