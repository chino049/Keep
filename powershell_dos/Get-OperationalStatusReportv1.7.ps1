<#
.DESCRIPTION
    This script is designed to capture operational information for IP360
    
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
.PARAMETER MaxNetworkScanAge
    (Optional) Accepts a time value (in days) for maximum age of scan permitted before alerting - default of 3 days
.PARAMETER MaxScanDuration
    (Optional) Accepts a time value (in minutes) for maximum duration permitted for a scan before alerting - default 480 minutes (8 hours)
.PARAMETER TestConnection
    (Optional) accepts $true or $false to enable an additional pre-run check on ODBC and network access to the VNE
.PARAMETER CustomerName 
    (Optional) The name of a sub-customer to report on	


.INPUTS
    N/A

.OUTPUTS
    Tabular data 

.NOTES
    Version:           0.1 - Initial Test Release
    Author:            Tripwire Professional Services - Jesus Ordonez
    Client Name:       Mantech
    Creation Date:     August 2018
    
.EXAMPLE
    Get-OperationalStatusReport -vne "192.168.0.73" -password "yourpasswordhere"
    
    Generates a status report

.EXAMPLE
    Get-OperationalStatusReport -vne "192.168.0.73" -password "yourpasswordhere" -ExportPath "C:\temp\output.txt"
    
    Generates a status report and exports to text

.EXAMPLE
    Get-OperationalStatusReport -vne "192.168.0.73" -password "yourpasswordhere" -MaxScanDuration 1440
    
    Generates a status report including alerts for any scans exceeding 1440 minutes (24 hours)

.EXAMPLE
    Get-OperationalStatusReport -vne "192.168.0.73" -password "yourpasswordhere" -MaxNetworkScanAge 7
    
    Generates a status report including alerts for any networks that haven't been scanned in the last 7 days

.EXAMPLE
    Get-OperationalStatusReport -vne "192.168.0.73" -password "yourpasswordhere" -TestConnection $true
    
    Generates a status report with extra debug communication information

#>
#Requires -Version 4.0


#--------------------------------------------------------------[Params]------------------------------------------------------------
Param(
[STRING]$VNE, # VNE IP
[STRING]$password,
#[STRING]$NetworkName,
[string]$CustomerName,
[BOOLEAN]$TestConnection,
[INT]$MaxNetworkScanAge,
[INT]$MaxScanDuration
)
# Default parameters if not set
if(!$maxnetworkscanage){$maxnetworkscanage = 3}
if(!$maxscanduration){$maxscanduration = 480}
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
#Write-host "`nThis script provides Scan Exceptions report`n"
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
$DBConnectionString = "Driver={PostgreSQL ANSI(x64)};Server=$VNE;Port=$DBPort;Database=$DBName;Uid=$DBUser;Pwd=$Password;sslmode=require;"
# If test connection is enabled, now is a wise time to check it!
If($TestConnection -eq $True){Check-PGDB}


# Execute query
#ice=# select * from nc_audit_status;
# status_id |   status
#-----------+-------------
#         1 | In Progress
#         2 | Failed
#         3 | Cancelled
#         4 | Finished
#         5 | Paused
#         6 | Auto-Paused
#         7 | Suspended
#         8 | Pending

$qs = @"
select c.name as customer__name, a.audit_id as audit__id, ast.status as scan__status, a.end_date as end__date, 
--a.network_id as network__id, 
	   sp.name as scan__profile__name, n.name as network__name
from nc_audit a 
join nc_scan_profile sp on a.scan_profile_id=sp.scan_profile_id 
join nc_network n on n.network_id=a.network_id
join nc_customer c on n.customer_id=c.customer_id
join nc_audit_status ast on ast.status_id=a.status_id
where a.status_id in (2,3,5,6,7,8) 
and c.name like '%$CustomerName%'
and n.deleted = 'f'
order by c.name;
"@

$failedscans  = PGDBQuery -DBConnectionString $DBConnectionString -query $qs | out-gridview -Title "$vne Scans States"
PGDBQuery -DBConnectionString $DBConnectionString -query $qs | Export-Csv -path .\$vne-Get-OperationalStatusReportScanStates.csv -NoTypeInformation


$qrun = @"
select c.name as customer__name, a.audit_id as audit__id, a.Name as audit__name, n.Name as network__name, a.start_date as start__date, now() as now
from nc_scan_config_audits sca
right outer join nc_audit a on a.audit_id=sca.audit_id
join nc_network n on a.network_id=n.network_id
join nc_customer c on n.customer_id=c.customer_id
where a.status_id=1
and c.name like '%$CustomerName%'
and n.deleted = 'f'
--and a.elapsed_seconds is NULL -- paused by users
and (now() > a.start_date + ('$maxscanduration' * interval '1 minute') )
order by c.name;
"@

$longscans  = PGDBQuery -DBConnectionString $DBConnectionString -query $qrun | out-gridview -Title "$vne Scans Running for more than $MaxScanDuration minutes "
PGDBQuery -DBConnectionString $DBConnectionString -query $qrun | Export-Csv -path .\$vne-Get-OperationalStatusReportScanRunning.csv -NoTypeInformation

# query to display networks not scanned in x days but show last scan end date for all audits
$jj = @"
select c.name as customername, n.network_id as networkid, n.name as networkname, a.audit_id as audit_id, a.end_date as enddate
 from nc_network n
 join nc_customer c on n.customer_id=c.customer_id
 left join nc_audit a on a.network_id=n.network_id
 where n.network_id not in (select a.network_id from nc_audit a where a.status_id =4 and (a.end_date > (now() - ('$maxnetworkscanage' * interval '1 days') ) ) )
 and n.deleted ='f'
 and c.deleted ='f'
 and c.name like '%$CustomerName%'
 --and n.network_type = 'default'
 order by networkid;
"@

# query to display networks not scanned in x days grouped by 
$jjj = @"
select c.name as customer__name, n.network_id as network__id, n.name as network__name
 from nc_network n
 join nc_customer c on n.customer_id=c.customer_id
 left join nc_audit a on a.network_id=n.network_id
 where n.network_id not in (select a.network_id from nc_audit a where a.status_id =4 and (a.end_date > (now() - ('$maxnetworkscanage' * interval '1 days') ) ) )
 and n.deleted ='f'
 and c.deleted ='f'
 and c.name like '%$CustomerName%'
 --and n.network_type = 'default'
 group by c.name, n.network_id, n.name
 order by c.name
"@


$jjin = @"
select c.name as customername, n.network_id as networkid, n.name as networkname, a.audit_id as audit_id, a.end_date as enddate
 from nc_network n
 join nc_customer c on n.customer_id=c.customer_id
 left join nc_audit a on a.network_id=n.network_id
 where n.network_id in (select a.network_id from nc_audit a where a.status_id =4 and (a.end_date > (now() - ('$maxnetworkscanage' * interval '1 days') ) ) )
 and n.deleted ='f'
 and c.deleted ='f'
 and c.name like '%$CustomerName%'
 --and n.network_type = 'default'
 order by networkid;
"@

# query to display networks not scanned in x days but show last scan end date
$jjing = @"
select c.name as customer__name, n.network_id as network__id, n.name as network__name, a.audit_id as audit__id, a.start_date as start__date, a.end_date as end__date
from nc_network n
join nc_customer c on n.customer_id=c.customer_id
left join (
    select network_id, audit_id, start_date, end_date
    from (
        select network_id, audit_id, start_date, end_date, row_number() over (partition by a.network_id order by end_date desc) as rownum
        from nc_audit a
        where a.status_id = 4
    ) la
    where rownum = 1
) a on a.network_id = n.network_id
where n.network_id not in (select a.network_id from nc_audit a where a.status_id =4 and (a.end_date > (now() - ('$maxnetworkscanage' * interval '1 days') ) ) )
and n.deleted ='f'
and c.deleted ='f'
and c.name like '%$CustomerName%'
--and n.network_type = 'default'
order by customer__name, network__id;
"@

$unscannednetworks = PGDBQuery -DBConnectionString $DBConnectionString -query $jjing | out-gridview -Title "$vne Networks Not Scanned in $maxnetworkscanage days" 
PGDBQuery -DBConnectionString $DBConnectionString -query $jjing | Export-Csv -path .\$vne-Get-OperationalStatusReportNetworkNotScanned.csv -NoTypeInformation


