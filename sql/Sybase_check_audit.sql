/* sql statements for ASE 15.0 up */
set proc_return_status off 
go
set nocount on
go

declare @dbversion int
declare @sqltxt varchar(1024)
select @dbversion=value from master..sysconfigures where config=122

print "**********************************************************************************************************************************"
print "3.3.6 Assign strong password to 'sa' user login :"
if @dbversion = 12500
	select  password from master..syslogins where name = "sa"
else
begin
	select @sqltxt = 'select password from master..syslogins where name = "sa"'
	exec (@sqltxt)
end
go

print "**********************************************************************************************************************************"
print "3.3.7-1 Install auditing database sybsecurity :"
declare @sybsecdb varchar(30)
select @sybsecdb = name from master..sysdatabases where name='sybsecurity'

if @sybsecdb is NULL
print "<<<<<<< sybsecurity database is not installed !!! >>>>>>> "
else
select @sybsecdb
go

print "**********************************************************************************************************************************"
print "3.3.7-2 Install auditing database sybsecurity (number of system log tables, Min 3):"
print ""
declare @sybsecdb varchar(30)
select @sybsecdb = name from master..sysdatabases where name='sybsecurity'

if @sybsecdb is NULL
print "<<<<<<< sybsecurity database is not installed !!! >>>>>>> "
else
begin

	declare @dbversion int
	declare @sqltxt varchar(2048)
	select @dbversion=value from master..sysconfigures where config=122

	if @dbversion = 12500
	begin
		select @sqltxt='select distinct o.name
		from sybsecurity..sysobjects o, sybsecurity..syssegments s, sybsecurity..sysindexes i, master..sysusages msu, master..sysdevices msf
		where o.id = i.id and s.segment = i.segment
		and (o.name like "sysaudits_%")
		and msu.dbid = (select dbid from master..sysdatabases where name = "sybsecurity")
		and msu.vstart between msf.low and msf.high
		and msu.segmap &power(2,s.segment) > 0
		order by o.name'
		exec (@sqltxt)
	end
	else
	begin
       		  select @sqltxt = 'select distinct o.name
       		  from sybsecurity..sysobjects o, sybsecurity..syssegments s, sybsecurity..sysindexes i, master..sysusages msu, master..sysdevices msf
       		  where o.id = i.id and s.segment = i.segment
        		  and (o.name like "sysaudits_%")
       		  and msu.dbid = (select dbid from master..sysdatabases where name = "sybsecurity")
       		  and msu.vdevno = msf.vdevno
       		  and msu.segmap &power(2,s.segment) > 0
	         order by s.name, o.name, msf.name'
	    exec (@sqltxt)
	end
end
go

print "**********************************************************************************************************************************"
print "3.3.8 Enable auditing :"
exec sp_configure "auditing"
go

print "**********************************************************************************************************************************"
print "3.3.10 Remove any sample databases or scripts that may have been installed during the installation process (i.e., Pubs)."
select name from master..sysdatabases where name in ("pubs")
go

print "**********************************************************************************************************************************"
print "3.3.11 Remove, or lock any login ids created during install which are not required. For accounts which are locked, change the default passwords and use strong passwords."
declare @dbversion int
declare @sqltxt varchar(1024)
select @dbversion=value from master..sysconfigures where config=122

if @dbversion = 12500
	select  name, pwdate, password from master..syslogins
else
begin
	select @sqltxt = 'select  name from master..syslogins where name in ("dba","entldbdbo","entldbreader","jagadmin","PIAdmin","pkiuser","portalAdmin","pso","sccadmin","uafadmin")
			and password is not null'
	exec (@sqltxt)
end
go

print "**********************************************************************************************************************************"
print "3.4.1 sp_configure .use security services. (Windows only)"
declare @sybversion varchar(255)
select @sybversion = upper(@@version)

if @sybversion NOT LIKE '%WINDOWS%'
print "This server is not Windows, not applicable."
else
begin
exec sp_configure "use security services"
end
go

print "**********************************************************************************************************************************"
print "3.4.2 sp_configure 'unified login required' (applies only when using a third party security mechanism)"
declare @sybauthmech char(255)
select @sybauthmech = UPPER(@@authmech)
if @sybauthmech = "ASE"
print @sybauthmech
else
exec sp_configure "unified login required"
go


print "**********************************************************************************************************************************"
print "3.4.4 sp_configure 'enable ssl (AIX Only)'"
declare @sybversion varchar(255)
select @sybversion = upper(@@version)

if @sybversion NOT LIKE '%AIX%' or @sybversion not like "%RS6000%"
print "This server is not AIX, not applicable."
else
begin
exec sp_configure "enable ssl"
end
go

print "**********************************************************************************************************************************"
print "3.4.6 sp_configure minimum password length"
exec sp_configure "minimum password length"
go

print "**********************************************************************************************************************************"
print "3.4.7 sp_configure maximum failed logins"
exec sp_configure "maximum failed logins"
go

print "**********************************************************************************************************************************"
print "3.4.8 sp_configure 'auditing'"
exec sp_configure "auditing"
go

Print "**********************************************************************************************************************************"
print "3.4.12 sp_configure xp_cmdshell context"
exec  sp_configure "xp_cmdshell context"
go

Print "**********************************************************************************************************************************"
print "3.4.13 sp_configure start mail session"
exec sp_configure "start mail session"
go

Print "*****************************************************************"
print "3.4.16 sp_configure allow updates to system tables"
exec sp_configure "allow updates to system tables"
go

print "**********************************************************************************************************************************"
print "3.6.1 Ensure server auditing is enabled." /*DUPLICATE*/
exec sp_configure "auditing"
go

print "**********************************************************************************************************************************"
print "3.6.4 sp_audit"
/*checking if sybsecurity database exists */
declare @sybsecdb varchar(30)
select @sybsecdb = name from sybsystemprocs..sysobjects where name='sp_displayaudit' and type = 'P'
if @sybsecdb is NULL
print "<<<<<<< sp_displayaudit stored procedure is not installed !!! >>>>>>>"
else
begin
	exec sp_displayaudit global,oper_role
	exec sp_displayaudit global,sa_role
	exec sp_displayaudit global,sso_role
end
go

print "**********************************************************************************************************************************"
print "3.6.16 sp_audit (fail only)"
/*checking if sybsecurity database exists */
declare @sybsecdb varchar(30)
select @sybsecdb = name from sybsystemprocs..sysobjects where name='sp_displayaudit' and type = 'P'
if @sybsecdb is NULL
print "<<<<<<< sp_displayaudit stored procedure is not installed !!! >>>>>>>"
else
begin
	exec sp_displayaudit global,login
end
go

print "**********************************************************************************************************************************"
print "3.6.18 sp_audit (rpc)"
/*checking if sybsecurity database exists */
declare @sybsecdb varchar(30)
select @sybsecdb = name from sybsystemprocs..sysobjects where name='sp_displayaudit' and type = 'P'
if @sybsecdb is NULL
print "<<<<<<< sp_displayaudit stored procedure is not installed !!! >>>>>>>"
else
begin
	exec sp_displayaudit global,rpc
end
go

print "**********************************************************************************************************************************"
declare @dt datetime 
select @dt = getdate()
print "Report Ended On :%1!" ,@dt
go

