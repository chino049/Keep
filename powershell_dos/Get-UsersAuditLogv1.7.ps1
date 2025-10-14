<#
.DESCRIPTION
    This script is designed to capture status information of IP360 DP's 
    
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
     Get-UsersAuditLog -vne "192.168.0.73" -password "ip360@tripwire.com"
	 
     Lists Users 

.EXAMPLE
    Get-UsersAuditLog -vne "192.168.0.73" -password "yourpasswordhere" -TestConnection "true" 
    
    Carries out a database connection attempt before providing Users 
	
.EXAMPLE	
	Get-UsersAuditLog -vne "192.168.0.73" -password "yourpasswordhere" -CustomerName "DH"

	Provides a Userss report for a sub-customer


#>
#Requires -Version 4.0


#--------------------------------------------------------------[Params]------------------------------------------------------------
Param(
[STRING]$VNE, 
[STRING]$password,
[string]$CustomerName,
[BOOLEAN]$TestConnection,
[STRING]$ExportPath,
[STRING]$Limit
)
# Default parameters if not set
if(!$TestConnection){$TestConnection = $false}
if(!$CustomerName){$CustomerName = '%%'}
if(!$Limit){$Limit = '500'}
#---------------------------------------------------------[Initialisations]--------------------------------------------------------
#Set Error Action to Silently Continue
#$ErrorActionPreference = "SilentlyContinue"
#----------------------------------------------------------[Declarations]----------------------------------------------------------
#Script Version
$ScriptVersion = "1.1"
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

#$password = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($password))

# Set connection string
$DBConnectionString = "Driver={PostgreSQL ANSI(x64)};Server=$VNE;Port=$DBPort;Database=$DBName;Uid=$DBUser;Pwd=$Password;sslmode=require;"

# Test Connection (if required)
If($TestConnection -eq $True){Check-PGDB}

#Check if nc_appliance is accessible 
$queryApp = @"
select name from nc_appliance;
"@
# Execute query
$queryresultApp = PGDBQuery -DBConnectionString $DBConnectionString -query $queryApp
if (!$queryresultApp) { write-host "`nPlease ensure nc_appliance is readable`n"}

# Query to retrieve data
$query = @"
select c.name as customer__name, l.first as first__name, l.middle as middle__name, l.last as last__name, l.email as email, 
l.last_login as last__login, l.disabled_time as disabled__time, --aus.name as AD__name, 
l.user_name as AD__name 
from nc_login l left outer join nc_customer c on l.customer_id=c.customer_id 
--left outer join nc_auth_server aus on l.auth_server_id=aus.auth_server_id 
where c.deleted = 'f' and l.deleted = 'f' 
and c.name like '%$CustomerName%'
order by c.name, l.last, l.first;
"@
$queryresult = PGDBQuery -DBConnectionString $DBConnectionString -query $query | out-gridview -Title "$vne Users Information"
PGDBQuery -DBConnectionString $DBConnectionString -query $query | Export-Csv -path .\$vne-Get-UsersAuditLogUsers.csv -NoTypeInformation

$queryAu = @"
select c.name as customer__name, l.first as first, l.last as last, auc.name as component, au.element_name as name, au.time_stamp as time__stamp 
from nc_audit_log au 
join nc_login l on l.login_id=au.login_id
join nc_customer c on c.customer_id = l.customer_id
join nc_audit_component auc on au.audit_component_id=auc.audit_component_id 
and c.name like '%$CustomerName%'
order by au.time_stamp 
limit '$Limit';
"@
$queryresult = PGDBQuery -DBConnectionString $DBConnectionString -query $queryAu | out-gridview -Title "$vne Audit Information"
PGDBQuery -DBConnectionString $DBConnectionString -query $queryAu | Export-Csv -path .\$vne-Get-UsersAuditLogAudit.csv -NoTypeInformation



