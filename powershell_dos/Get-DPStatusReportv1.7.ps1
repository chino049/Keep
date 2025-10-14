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
     Get-DPStatusReport -vne "192.168.0.73" -password "ip360@tripwire.com"
	 
     Lists the status of all DPs

.EXAMPLE
    Get-DPStatusReport -vne "192.168.0.73" -password "yourpasswordhere" -TestConnection "true" 
    
    Carries out a database connection attempt before providing the status of a specific DP
	
.EXAMPLE	
	Get-DPStatusReport -vne "192.168.0.73" -password "yourpasswordhere" -CustomerName "DH"

	Provides a DP Status report for a sub-customer

.EXAMPLE
    Get-DPStatusReport -vne "192.168.0.73" -password "yourpasswordhere" -ExportPath "C:\temp\output.txt"
    
    Provides a DP Status report file in C:\temp\output.txt

#>
#Requires -Version 4.0



#--------------------------------------------------------------[Params]------------------------------------------------------------
Param(
[STRING]$VNE, 
[STRING]$password,
[string]$CustomerName,
[BOOLEAN]$TestConnection
)
# Default parameters if not set
if(!$TestConnection){$TestConnection = $false}
if(!$CustomerName){$CustomerName = '%%'}

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
#Write-host "`nThis script provides Device Profilers report`n"
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
select c.name as Customer__Name, a.name as DP__Name, p.name as Pool__Name, a.ip_address as DP__IP, a.remote_ip as Remote__IP, 
	(case when s.last_update + (5 * interval '1 minute') > now() then 'online' else 'offline' end) as DP__Status, a.ontology_version as ASPL,
	s.last_update as Last__Update, a.appliance_id as DP__ID, aht.canonical_name as Hardware__Type, a.software_version as Version,
	(case when a.is_local = '1' then 'internal' else 'external' end) as DP__Local
	--,a.cloud as Cloud, a.error as Error  
from nc_appliance a
JOIN nc_customer_appliance ca on a.appliance_id=ca.appliance_id
JOIN nc_customer c on c.customer_id=ca.customer_id
JOIN nc_appliance_hardware_type aht on a.hardware_type_id=aht.hardware_type_id 
JOIN nc_appliance_status s on a.appliance_id=s.appliance_id
JOIN nc_pool p on p.pool_id=a.pool_id  
and c.name like '%$CustomerName%' 
and c.deleted = 'f'
order by c.name;
"@

# Execute query
$queryresult = PGDBQuery -DBConnectionString $DBConnectionString -query $query | out-gridview -Title "$vne Device Profilers Status  "

#creates the CSV file
PGDBQuery -DBConnectionString $DBConnectionString -query $query | Export-Csv -path .\$vne-Get-DPStatusReport.csv -NoTypeInformation

