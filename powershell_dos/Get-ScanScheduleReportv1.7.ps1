<#
.DESCRIPTION
    This script is designed to capture scan schedules of IP360 
    
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
    Get-ScanScheduleReport -vne "192.168.0.73" -password "yourpasswordhere"
    
    Generates scan exceptions report
		
.EXAMPLE
    Get-ScanScheduleReport -vne "192.168.0.73" -password "yourpasswordhere" -TestConnection "true" 
    
    Carries out a database connection attempt before providing scan exceptions 
	
.EXAMPLE	
	Get-ScanScheduleReport -vne "192.168.0.73" -password "yourpasswordhere" -CustomerName "DH"

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
#Write-host "`nThis script provides Scan Schedules report`n"
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

$qjos = @"
select c.name as Customer__Name, --c.customer_id as ID, 
nsc.next_scan_time as Next__Scheduled__Execution, nsc.name as Scan__Name, n.name as Network__Name,
nsp.name as Scan__Profile, p.name as pool,
nsc.last_completed_audit as Last__Execution, st.name as Type,
xpath('//scanProfile/@timezone', config::xml)::text as TZ,
case when xpath_exists('//scanProfile/constraints/scanFrequency', config::xml) then
     case when xpath_exists('//scanProfile/constraints/scanFrequency/periodic', config::xml) then 'Recurring'
     when xpath_exists('//scanProfile/constraints/scanFrequency/byMonth', config::xml) then 'Scheduled'
     when xpath_exists('//scanProfile/constraints/scanFrequency/byWeek', config::xml) then 'Scheduled'
	 --when xpath_exists('//scanProfile/constraints/scanFrequency/byMonthWeek', config::xml) then 'Scheduled'
     else 'Continuous' end
else 'Continuous' end as schedule,
xpath('//scanProfile/constraints/scanFrequency/periodic/@count', config::xml)::text as Freq__count, --scanFrequencyRecurringCount,
xpath('//scanProfile/constraints/scanFrequency/periodic/@unit', config::xml)::text as Freq__unit, -- scanFrequencyRecurringUnit,
case
     when xpath_exists('//scanProfile/constraints/scanFrequency/byMonthWeek', config::xml) then xpath('//scanProfile/constraints/scanFrequency/byMonthWeek/@scansPerDay', config::xml)::text
     when xpath_exists('//scanProfile/constraints/scanFrequency/byWeek', config::xml) then xpath('//scanProfile/constraints/scanFrequency/byWeek/@scansPerDay', config::xml)::text
     when xpath_exists('//scanProfile/constraints/scanFrequency/byMonth', config::xml) then xpath('//scanProfile/constraints/scanFrequency/byMonth/@scansPerDay', config::xml)::text
end as per__day, --scanFrequencyScheduledScansPerDay,
case
     when xpath_exists('//scanProfile/constraints/scanFrequency/byMonthWeek', config::xml) then xpath('//scanProfile/constraints/scanFrequency/byMonthWeek/@unit', config::xml)::text
     when xpath_exists('//scanProfile/constraints/scanFrequency/byWeek', config::xml) then xpath('//scanProfile/constraints/scanFrequency/byWeek/@unit', config::xml)::text
     when xpath_exists('//scanProfile/constraints/scanFrequency/byMonth', config::xml) then xpath('//scanProfile/constraints/scanFrequency/byMonth/@unit', config::xml)::text
end as sched__unit, --scanFrequencyScheduledUnit,
case
     when xpath_exists('//scanProfile/constraints/scanFrequency/byMonthWeek', config::xml) then xpath('//scanProfile/constraints/scanFrequency/byMonthWeek/@daysOfMonthWeek', config::xml)::text
     when xpath_exists('//scanProfile/constraints/scanFrequency/byWeek', config::xml) then xpath('//scanProfile/constraints/scanFrequency/byWeek/@daysOfWeek', config::xml)::text
     when xpath_exists('//scanProfile/constraints/scanFrequency/byMonth', config::xml) then xpath('//scanProfile/constraints/scanFrequency/byMonth/@daysOfMonth', config::xml)::text
end as days, --scanFrequencyScheduledDays,
xpath('//scanProfile/constraints/scanWindow/@start', config::xml)::text as Window__start, --scanWindowsStart,
xpath('//scanProfile/constraints/scanWindow/@end', config::xml)::text as Window__end --scanWindowEnd
from nc_scan_config nsc
join nc_scan_profile as nsp on nsc.scan_profile_id=nsp.scan_profile_id
join nc_scan_type st on st.scan_type_id=nsp.scan_profile_type_id
join nc_network as n on n.network_id=nsc.network_id
join nc_customer as c on n.customer_id=c.customer_id
join nc_pool p on nsc.pool_id=p.pool_id 
where nsc.active = 't' and n.active = 't' and nsp.active = 't'
and c.name like '%$CustomerName%'
order by c.customer_id;
"@

# Execute query 
$net  = PGDBQuery -DBConnectionString $DBConnectionString -query $qjos | out-gridview -Title "$vne Enabled Scan Schedule"
PGDBQuery -DBConnectionString $DBConnectionString -query $qjos | Export-Csv -path .\$vne-Get-ScanScheduleReport.csv -NoTypeInformation


