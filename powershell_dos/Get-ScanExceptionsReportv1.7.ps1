<#
.DESCRIPTION
    This script is designed to capture scan exceptions and gaps of IP360 
    
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
    Get-ScanExceptionsReport -vne "192.168.0.73" -password "yourpasswordhere"
    
    Generates scan exceptions report
		
.EXAMPLE
    Get-ScanExceptionsReport -vne "192.168.0.73" -password "yourpasswordhere" -TestConnection "true" 
    
    Carries out a database connection attempt before providing scan exceptions 
	
.EXAMPLE	
	Get-ScanExceptionsReport -vne "192.168.0.73" -password "yourpasswordhere" -CustomerName "DH"

	Provides scan exceptions report for a sub-customer which name cotains DH
	
#>
#Requires -Version 4.0


#--------------------------------------------------------------[Params]------------------------------------------------------------
Param(
[STRING]$VNE, # VNE IP
[STRING]$password,
[BOOLEAN]$TestConnection,
[string]$CustomerName
)
# Default parameters if not set
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


# Query to retrieve network information
$qnN = @"
    select c.name as Customer__Name, n.name as Network__Name, 
	(case when n.active  = '1' then 'active' when n.active = '0' then 'inactive' end) as Network__Active,
	--n.network_id as NetworkId, 
	nsp.name as Scan__Profile__Name, 
	(case when nsp.active = '1' then 'active' when nsp.active = '0' then 'inactive' end) as Scan__Profile__Active, nsc.name as Scan__Configuration__Name, 
	(case when nsc.active = '1' then 'active' when nsc.active = '0' then 'inactive' end) as Scan__Configuration__Active
 	--(case when nsp.vuln_scan = '1' then 'yes' when nsp.vuln_scan = '0' then 'no' end) as Vuln__Scan,  -- field availabel on ip360 9.0
	--nr.range as include
	from nc_network as n
	left join nc_scan_config nsc on n.network_id=nsc.network_id
	left join nc_customer as c on n.customer_id=c.customer_id
	left join nc_scan_profile as nsp on nsp.scan_profile_id=nsc.scan_profile_id
	--join nc_network_range nr on n.network_id=nr.network_id
	--left join nc_pool p on nsc.pool_id=p.pool_id 
	where n.deleted = 'f'
	and (n.active = 'f' or n.active = 't' and ((nsp.active = 'f' or nsp.active is NULL) or (nsc.active = 'f' or nsc.active is NULL)))
	--and n.network_type ='default'  -- field availabel on ip360 9.0
	--and nr.exclude = 'f'
	and c.name like '%$CustomerName%'
	and c.deleted = 'f'
--	and nsp.vuln_scan = 't' 
	order by c.customer_id, n.network_id;
"@
$netN  = PGDBQuery -DBConnectionString $DBConnectionString -query $qnN | out-gridview -Title "$vne Network Scan Exceptions"
PGDBQuery -DBConnectionString $DBConnectionString -query $qnN | Export-Csv -path .\$vne-Get-ScanExceptionsReportNetworkExceptions.csv -NoTypeInformation

	