
<#
.SYNOPSIS
    This script is designed to capture scan activity analysis information of IP360 
.DESCRIPTION
    This script is designed to capture scan results information of IP360 
    
    THIS SCRIPT IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED  
    OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR  
    FITNESS FOR A PARTICULAR PURPOSE, AND/OR NONINFRINGEMENT. 

    This script is not supported under any Tripwire standard support program or service.  
    The script is provided AS IS without warranty of any kind. Tripwire further disclaims all 
    implied warranties including, without limitation, any implied warranties of merchantability 
    or of fitness for a particular purpose. The entire risk arising out of the use or performance 
    of the sample and documentation remains with you. In no event shall Tripwire, its authors, 
    or anyone else involved in the creation, production, or delivery of the script be liable for  
    any damages whatsoever (including, without limitation, damages for loss of business profits,  
    business interruption, loss of business information, or other pecuniary loss) arising out of  
    the use of or inability to use the sample or documentation, even if Tripwire has been advised  
    of the possibility of such damages. 
    WITHOUT LIMITING THE GENERALITY OF THE FOREGOING, TRIPWIRE HAS NO OBLIGATION TO INDEMNIFY OR 
    DEFEND RECIPIENT AGAINST CLAIMS RELATED TO INFRINGEMENT OF INTELLECTUAL PROPERTY RIGHTS.
	
.PARAMETER VNE
    IP360 VnE Manager IP address of hostname
.PARAMETER Password
    Tripwire password for the external readonly username for PostgreSQL access
.PARAMETER TestConnection
    (Optional) Adds a "preflight" check to verify if database access is possible on 5432 - set to $true to run (otherwise disabled by default)
.PARAMETER StartDate 
    (Optional) The start date and time of the range of time for which the report will be generated
.PARAMETER EndDateTime 
    (Optional) The end date and time of the range of time for which the report will be generated	
.PARAMETER CustomerName 
    (Optional) The name of a customer/tenant to report on


.INPUTS
    N/A

.OUTPUTS
    Tabular data 

.NOTES
    Version:           0.1 - Initial Test Release
    Author:            Tripwire Professional Services (Jesus Ordonez)
    Client Name:       Mantech
    Creation Date:     August 2018
    
.EXAMPLE
    Get-ScanActivityAnalysisReport -vne "192.168.0.73" -password "yourpasswordhere"
    
    Generates Scan Activity and Networks with disabled or not configured scans report
	
.EXAMPLE
    Get-ScanActivityAnalysisReport -vne "192.168.0.73" -password "yourpasswordhere" -TestConnection "true" 
    
    Carries out a database connection attempt before providing scan exceptions 
	
.EXAMPLE	
	Get-ScanActivityAnalysisReport -vne "192.168.0.73" -password "yourpasswordhere" -CustomerName "DH"

	Provides Scan Activity and Networks report for a sub-customer which name cotains DH
	
.EXAMPLE	
	Get-ScanActivityAnalysisReport -vne "192.168.0.73" -password "yourpasswordhere" -StartDate 2018-09-05 -EndDate 2018-09-10
	
	Provides Scan Activity and Networks report for specific dates
		
	

#>
#Requires -Version 4.0

#--------------------------------------------------------------[Params]------------------------------------------------------------
Param(
[STRING]$VNE, # VNE IP
[STRING]$password,
[string]$StartDate,
[string]$EndDate,
[BOOLEAN]$TestConnection,
[string]$CustomerName
)
# Default parameters if not set
#if(!$StartDate){$StartDate = '2018-01-01 00:00:00'}
#if(!$EndDate){$EndDate = '2100-12-31 00:00:00'}
if(!$EndDate){$EndDate = (get-date).tostring("yyyy-MM-dd HH:mm:ss") }
if(!$StartDate){$StartDate = (get-date).AddDays(-30).tostring("yyyy-MM-dd HH:mm:ss") }
if(!$TestConnection){$TestConnection = $false}
if(!$CustomerName){$CustomerName = '%%'}

#---------------------------------------------------------[Initialisations]--------------------------------------------------------
#Set Error Action to Silently Continue
$ErrorActionPreference = "SilentlyContinue"
#----------------------------------------------------------[Declarations]----------------------------------------------------------
#Script Version
$ScriptVersion = "1.0"
# These are really static for Tripwire IP360, but to support customisation in the future, are set as variables here
$DBPort = "5432"
$DBName = "ice"
$DBUser = "readonly"
#-----------------------------------------------------------[Functions]------------------------------------------------------------
################ ********************* ####################
# Postgres Database Connection Testing
################ ********************* ####################
function Check-PGDB{
    # Checks for PGDB requirements
    Write-Host "Powershell version is " $PSVersionTable.PSVersion -ForegroundColor Gray
    $ODBCDSNs = Get-OdbcDsn
    $ODBCDrivers = Get-OdbcDriver
    # Does PostgresSQL exist:
    $PostGresversion = $ODBCDSNs | Where-Object {$_.Name -like "Postg*"}
    if ($PostGresversion.Count -eq 0)
        {
        Write-Host "No Postgres DSN found - only the following were found" -ForegroundColor Red
        Write-host $ODBCDSNs.name   -ForegroundColor Gray
        }
    else{
        Write-host "Postgres ODBCSDSN found" -ForegroundColor Gray
        Write-host $PostGresversion  -ForegroundColor Gray
        }
    Write-host "Testing network connection to VNE" -ForegroundColor Gray
    $NetworkTest = Test-NetConnection $VNE -Port $DBPort
    Write-host "$VNE remote port $DBPort gave a TCP test result of" $NetworkTest.TcpTestSucceeded -ForegroundColor Gray
}
################ ********************* ####################
# PostgreSQL Query Function
################ ********************* ####################
function PGDBQuery{
    param ($query,
    $DBConnectionString)
    $DBConn = New-Object System.Data.Odbc.OdbcConnection;
    $DBConn.ConnectionString = $DBConnectionString;
    $DBConn.Open();
    $SQLcmd = New-object System.Data.Odbc.OdbcCommand($query,$DBConn)
    $ds = New-Object system.Data.DataSet
    (New-Object system.Data.odbc.odbcDataAdapter($SQLcmd)).fill($ds) | out-null
    $DBConn.close()
    return $ds.Tables[0]
}

#-----------------------------------------------------------[Execution]------------------------------------------------------------

# Build connection settings
#Write-host "`nThis script provides Scan Activity report`n"
if(!$VNE){
    # Missing VNE IP/hostname
    $VNE = Read-Host "Please enter a valid IP360 VNE Address"
    } 
	else {
		if($TestConnection -like "true") {
			Write-host "Attempting to connect to $VnE"
			$testnetconnect = Test-NetConnection -Port 5432 -ComputerName $Vne   
			if ($testnetconnect.TcpTestSucceeded -eq $True){
				Write-host "Connection successful on port 5432"
            } else {
				Write-host "Unable to establish connection to $VnE on port 5432- please check firewall configuration"
				#Exit
			}
		}
	}	

# Check for credentials
if(!$password)
    {
    # prompt for credentials
    Write-host "Credentials required"
    Exit
    # $password = Read-host -Prompt "Please enter your PostgreSQL user password" -AsSecureString # Not working at Mantech currently
}

$password = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($password))
# Set connection string
#$DBConnectionString = "Driver={PostgreSQL UNICODE(x64)};Server=$VNE;Port=$DBPort;Database=$DBName;Uid=$DBUser;Pwd=$Password;"
$DBConnectionString = "Driver={PostgreSQL ANSI(x64)};Server=$VNE;Port=$DBPort;Database=$DBName;Uid=$DBUser;Pwd=$Password;sslmode=require;"
# If test connection is enabled, now is a wise time to check it!
If($TestConnection -eq $True){Check-PGDB}


# Query to retrieve audit data
$q = @"
select c.name as customer__name, --c.customer_id, 
a.audit_id as audit__id, a.name as scan__name , st.name as scan__type, 
	   ast.host_count as total__hosts__found,
       ast.vuln_count as Vuln__Count, ast.average_host_score as Average__host__Score, a.start_date as start__date, a.end_date as end__date, a.elapsed_seconds/60 as Minutes,
	   a.ontology_version as ASPL, --n.network_id, 
	   n.Name as Network__Name, sp.name as Scan__Profile__Name, p.name as Pool__Name
	   
	   --, astatus.status as Audit__Status 
from nc_scan_config_audits sca
join nc_audit a on a.audit_id=sca.audit_id
join nc_network n on a.network_id=n.network_id 
join nc_scan_type st on a.scan_type_id=st.scan_type_id
join nc_audit_stats ast on a.audit_id=ast.audit_id
join nc_scan_profile as sp on a.scan_profile_id=sp.scan_profile_id
join nc_pool as p on a.pool_id=p.pool_id
join nc_audit_status as astatus on a.status_id=astatus.status_id 
join nc_customer as c on sp.customer_id=c.customer_id
where a.end_date > '$StartDate' and a.end_date < '$EndDate' 
and c.name like '%$CustomerName%'
and ast.vuln_count > 0
and astatus.status_id = 4
order by  c.customer_id, a.end_date desc; 
"@

# Execute query
$scans  = PGDBQuery -DBConnectionString $DBConnectionString -query $q | out-gridview -Title "$vne Completed Scans Activity"
PGDBQuery -DBConnectionString $DBConnectionString -query $q | Export-Csv -path .\$vne-Get-ScanActivityAnalysisReportCompletedScans.csv -NoTypeInformation


$res = New-Object System.Collections.Generic.List[System.Object]
$sca  = PGDBQuery -DBConnectionString $DBConnectionString -query $q 
$authdt = New-Object System.Data.DataTable "Authentication Summary"
$col1 = New-Object System.Data.DataColumn "audit__id",([int]) 
#$col2 = New-Object System.Data.DataColumn "SMB or WMI Success",([int])
$col2 = New-Object System.Data.DataColumn "Windows__OS",([int])
$col3 = New-Object System.Data.DataColumn "WMI__Failure",([int])
$col4 = New-Object System.Data.DataColumn "Windows credentials not configured",([int])
$col5 = New-Object System.Data.DataColumn "SSH credentials not configured",([int])
$col6 = New-Object System.Data.DataColumn "customer__name",([string])
$col7 = New-Object System.Data.DataColumn "network__name",([string])
$col9 = New-Object System.Data.DataColumn "scan__profile__name",([string])
$col8 = New-Object System.Data.DataColumn "total__hosts__found",([int])
$col10 = New-Object System.Data.DataColumn "success__percentage",([int])

$authdt.Columns.Add($col1)
$authdt.Columns.Add($col6)
$authdt.Columns.Add($col7)
$authdt.Columns.Add($col8)
$authdt.Columns.Add($col9)
$authdt.Columns.Add($col2)
$authdt.Columns.Add($col3)
$authdt.Columns.Add($col10)
$authdt.Columns.Add($col4)
$authdt.Columns.Add($col5)

foreach ($r in $sca){
		
	$cn     = $r.Item("customer__name")
	$aud_id = $r.Item("audit__id")
	$thc    = $r.Item("total__hosts__found")
	$nn     = $r.Item("network__name")
	$spn    = $r.Item("scan__profile__name")

	$qs = 
@"
		select count(distinct vr.host_id) 
		from nc_vuln_result as vr
		join nc_host as h on h.host_id=vr.host_id
		join nc_vuln as v on vr.vuln_id=v.vuln_id 
		join nc_os o on h.os_id=o.os_id
--	where (v.vuln_id = 5923 or v.vuln_id = 9973)
		where o.name like '%Windows%' 
		and vr.audit_id = '$aud_id';
"@
	# Execute query
	$winOS = PGDBQuery -DBConnectionString $DBConnectionString -query $qs 
	
	$qf = 
@"
		select count(distinct vr.host_id) 
		from nc_vuln_result as vr
		join nc_host as h on h.host_id=vr.host_id
		join nc_vuln as v on vr.vuln_id=v.vuln_id 
		join nc_os o on h.os_id=o.os_id
		--where (v.vuln_id = 5452 or v.vuln_id=9974)
		where v.vuln_id=9974
		and o.name like '%Windows%' 
		and vr.audit_id = '$aud_id';
"@
	# Execute query
	$smbFail  = PGDBQuery -DBConnectionString $DBConnectionString -query $qf
	
	$qsmbNotConfig = 
@"
		select count(distinct vr.host_id) 
		from nc_vuln_result as vr
		join nc_host as h on h.host_id=vr.host_id
		join nc_vuln as v on vr.vuln_id=v.vuln_id 
		
		join nc_os o on h.os_id=o.os_id
		where (v.vuln_id=30533)
		and o.name like '%Windows%' 
		and vr.audit_id = '$aud_id';
"@
	# Execute query
	$smbNC  = PGDBQuery -DBConnectionString $DBConnectionString -query $qsmbNotConfig
	
	$qsshNotConfig = 
@"
		select count(distinct vr.host_id) 
		from nc_vuln_result as vr
		join nc_host as h on h.host_id=vr.host_id
		join nc_vuln as v on vr.vuln_id=v.vuln_id 
		join nc_os o on h.os_id=o.os_id
		where (v.vuln_id=30535)
		and vr.audit_id = '$aud_id';
"@
	# Execute query
	$sshNC  = PGDBQuery -DBConnectionString $DBConnectionString -query $qsshNotConfig
		
	$authr = $authdt.NewRow()
	$authr["customer__name"] = $cn
	$authr["audit__id"] = $aud_id
	$authr["network__name"] = $nn
	$authr["scan__profile__name"] = $spn
	$authr["total__hosts__found"] = $thc
	$authr["scan__profile__name"] = $spn
	$authr["Windows__OS"] = $winOS.Item(0)
	$authr["WMI__Failure"] = $smbFail.Item(0)
	$succ = $winOS.Item(0) - $smbFail.Item(0)
	$authr["success__percentage"] = $succ * 100 / $winOS.Item(0) 
	$authr["Windows credentials not configured"] = $smbNC.Item(0)
	$authr["SSH credentials not configured"] = $sshNC.Item(0)
	$authdt.Rows.Add($authr)
}

$authdt | out-gridview -Title "$vne Authentication Summary"
$ress = $authdt | Export-Csv -path .\$vne-Get-ScanActivityAnalysisReportAuthenticationSummary.csv -NoTypeInformation


	