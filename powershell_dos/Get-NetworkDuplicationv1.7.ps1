<#
    
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
	
=========================================
CHANGELOG:
=========================================
0.1   Initial Client Release Testing
1.0   Client release
1.4   Client Release 09/17/2018 by Jesus Ordonez
1.6   Client Release 11/02/2018 by Jesus Ordonez 
#>

#--------------------------------------------------------------[Params]------------------------------------------------------------
Param(
[STRING]$VNE, # VNE IP
[STRING]$password,
#[STRING]$NetworkName,
[BOOLEAN]$TestConnection,
[STRING]$ExportPath
)
if(!$TestConnection){$TestConnection = $false}
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
################ ********************* ####################
# Get IP address information for CIDR Notation networks
################ ********************* ####################
Function Get-IPV4NetworkStartIP ($strNetwork)
{
$StrNetworkAddress = ($strNetwork.split("/"))[0]
$NetworkIP = ([System.Net.IPAddress]$StrNetworkAddress).GetAddressBytes()
[Array]::Reverse($NetworkIP)
$NetworkIP = ([System.Net.IPAddress]($NetworkIP -join ".")).Address
$StartIP = $NetworkIP +1
#Convert To Double
If (($StartIP.Gettype()).Name -ine "double")
{
$StartIP = [Convert]::ToDouble($StartIP)
}
$StartIP = [System.Net.IPAddress]$StartIP
Return $StartIP
}
Function Get-IPV4NetworkEndIP ($strNetwork)
{
$StrNetworkAddress = ($strNetwork.split("/"))[0]
[int]$NetworkLength = ($strNetwork.split("/"))[1]
$IPLength = 32-$NetworkLength
$NumberOfIPs = ([System.Math]::Pow(2, $IPLength)) -1
$NetworkIP = ([System.Net.IPAddress]$StrNetworkAddress).GetAddressBytes()
[Array]::Reverse($NetworkIP)
$NetworkIP = ([System.Net.IPAddress]($NetworkIP -join ".")).Address
$EndIP = $NetworkIP + $NumberOfIPs
If (($EndIP.Gettype()).Name -ine "double")
{
$EndIP = [Convert]::ToDouble($EndIP)
}
$EndIP = [System.Net.IPAddress]$EndIP
Return $EndIP
}
################ ********************* ####################
# Tests if an IP is in the same subnet
################ ********************* ####################
Function Test-SameSubnet { 
param ( 
[parameter(Mandatory=$true)] 
[Net.IPAddress] 
$ip1, 

[parameter(Mandatory=$true)] 
[Net.IPAddress] 
$ip2, 

[parameter()] 
[alias("SubnetMask")] 
[Net.IPAddress] 
$mask ="255.255.255.0" 
) 

if (($ip1.address -band $mask.address) -eq ($ip2.address -band $mask.address)) {$true} 
else {$false} 

}
################ ********************* ####################
# Converts Min and Max IPs for CIDR's
################ ********************* ####################
function Get-ValidIPAddressinRange
{
    <#
    .Synopsis
       Takes the IP Address and the Mask value as input and returns all possible IP
    .DESCRIPTION
       The Function takes the IPAddress and the Subnet mask value to generate a list of all possible IP addresses in the Network, including Start, Max, and broadcast
   
    .EXAMPLE
        Specify the IPaddress in the CIDR notation
        PS C:\> Get-ValidIPAddressinRange -IP 10.10.10.0/24
    .EXAMPLE
       Specify the IPaddress and mask separately (Non-CIDR notation)
        PS C:\> Get-ValidIPAddressinRange -IP 10.10.10.0 -Mask 24
    .EXAMPLE
       Specify the IPaddress and mask separately (Non-CIDR notation)
        PS C:\> Get-ValidIPAddressinRange -IP 10.10.10.0 -Mask 255.255.255.0
    .INPUTS
       System.String
    .OUTPUTS
       [System.Net.IPAddress[]]
    .NOTES
       Credits given to the original post in LINK
       Updated to correct examples - Chris Hudson
    .LINK
        http://www.indented.co.uk/index.php/2010/01/23/powershell-subnet-math/

    #>
        [CmdletBinding(DefaultParameterSetName='CIDR', 
                      SupportsShouldProcess=$true, 
                      ConfirmImpact='low')]
        [OutputType([ipaddress[]])]
        Param
        (
            # Param1 help description
            [Parameter(Mandatory=$true, 
                       ValueFromPipeline=$true,
                       ValueFromPipelineByPropertyName=$true, 
                       ValueFromRemainingArguments=$false 
                        )]
            [ValidateScript({
                            if ($_.contains("/"))
                                { # if the specified IP format is -- 10.10.10.0/24
                                    $temp = $_.split('/')   
                                    If (([ValidateRange(0,32)][int]$subnetmask = $temp[1]) -and ([bool]($temp[0] -as [ipaddress])))
                                    {
                                        Return $true
                                    }
                                }                           
                            else
                            {# if the specified IP format is -- 10.10.10.0 (along with this argument to Mask is also provided)
                                if ( [bool]($_ -as [ipaddress]))
                                {
                                    return $true
                                }
                                else
                                {
                                    throw "IP validation failed"
                                }
                            }
                            })]
            [Alias("IPAddress","NetworkRange")] 
            [string]$IP,

            # Param2 help description
            [Parameter(ParameterSetName='Non-CIDR')]
            [ValidateScript({
                            if ($_.contains("."))
                            { #the mask is in the dotted decimal 255.255.255.0 format
                                if (! [bool]($_ -as [ipaddress]))
                                {
                                    throw "Subnet Mask Validation Failed"
                                }
                                else
                                {
                                    return $true 
                                }
                            }
                            else
                            { #the mask is an integer value so must fall inside range [0,32]
                               # use the validate range attribute to verify it falls under the range
                                if ([ValidateRange(0,32)][int]$subnetmask = $_ )
                                {
                                    return $true
                                }
                                else
                                {
                                    throw "Invalid Mask Value"
                                }
                            }
                        
                             })]
            [string]$mask
        )

        Begin
        {
            Write-Verbose "Function Starting"
            #region Function Definitions
        
            Function ConvertTo-DecimalIP {
              <#
                .Synopsis
                  Converts a Decimal IP address into a 32-bit unsigned integer.
                .Description
                  ConvertTo-DecimalIP takes a decimal IP, uses a shift-like operation on each octet and returns a single UInt32 value.
                .Parameter IPAddress
                  An IP Address to convert.
              #>
   
              [CmdLetBinding()]
              [OutputType([UInt32])]
              Param(
                [Parameter(Mandatory = $True, Position = 0, ValueFromPipeline = $True)]
                [Net.IPAddress]$IPAddress
              )
 
              PROCESS 
              {
                $i = 3; $DecimalIP = 0;
                $IPAddress.GetAddressBytes() | ForEach-Object { $DecimalIP += $_ * [Math]::Pow(256, $i); $i-- }
 
                Write-Output $([UInt32]$DecimalIP)
              }
            }

            Function ConvertTo-DottedDecimalIP 
            {
            <#
            .Synopsis
                Returns a dotted decimal IP address from either an unsigned 32-bit integer or a dotted binary string.
            .Description
                ConvertTo-DottedDecimalIP uses a regular expression match on the input string to convert to an IP address.
            .Parameter IPAddress
                A string representation of an IP address from either UInt32 or dotted binary.
            #>
 
            [CmdLetBinding()]
            [OutputType([ipaddress])]
            Param(
            [Parameter(Mandatory = $True, Position = 0, ValueFromPipeline = $True)]
            [String]$IPAddress
                  )
   
                  PROCESS
                  {
                    Switch -RegEx ($IPAddress) 
                    {
                      "([01]{8}\.){3}[01]{8}" 
                      {
                        Return [String]::Join('.', $( $IPAddress.Split('.') | ForEach-Object { [Convert]::ToUInt32($_, 2) } ))
                      }

                      "\d" 
                      {
                        $IPAddress = [UInt32]$IPAddress
                        $DottedIP = $( For ($i = 3; $i -gt -1; $i--) {
                          $Remainder = $IPAddress % [Math]::Pow(256, $i)
                          ($IPAddress - $Remainder) / [Math]::Pow(256, $i)
                          $IPAddress = $Remainder
                         } )
        
                        Write-Output $([ipaddress]([String]::Join('.', $DottedIP)))
                      }

                      default 
                      {
                        Write-Error "Cannot convert this format"
                      }
                    }
                  }
            }
             #endregion Function Definitions
        }

        Process
        {
            Switch($PSCmdlet.ParameterSetName)
            {
                "CIDR"
                {
                    Write-Verbose "Inside CIDR Parameter Set"
                    $temp = $ip.Split("/")
                    $ip = $temp[0]
                     #The validation attribute on the parameter takes care if this is empty
                    $mask = ConvertTo-DottedDecimalIP ([Convert]::ToUInt32($(("1" * $temp[1]).PadRight(32, "0")), 2))                            
                }

                "Non-CIDR"
                {
                    Write-Verbose "Inside Non-CIDR Parameter Set"
                    If (!$Mask.Contains("."))
                      {
                        $mask = ConvertTo-DottedDecimalIP ([Convert]::ToUInt32($(("1" * $mask).PadRight(32, "0")), 2))
                      }

                }
            }
            #now we have appropraite dotted decimal ip's in the $ip and $mask
            $DecimalIP = ConvertTo-DecimalIP -IPAddress $ip
            $DecimalMask = ConvertTo-DecimalIP $Mask

            $Network = $DecimalIP -BAnd $DecimalMask
            $Broadcast = $DecimalIP -BOr ((-BNot $DecimalMask) -BAnd [UInt32]::MaxValue)
            
            [pscustomobject]@{
                                NetworkIP=( ConvertTo-DottedDecimalIP -IPAddress $Network);
                                BroadcastIP=(ConvertTo-DottedDecimalIP -IPAddress $Broadcast);
                                HostMin = (ConvertTo-DottedDecimalIP -IPAddress ($Network + 1));
                                HostMax = (ConvertTo-DottedDecimalIP -IPAddress ($Broadcast -1))
                            }
            <# uncomment the below if you want the all the IP Addresses...I just need Network & Broadcast
            For ($i = $($Network + 1); $i -lt $Broadcast; $i++) {
                ConvertTo-DottedDecimalIP $i
                    }
            #>
             
                       
            
        }
        End
        {
            Write-Verbose "Function Ending"
        }
    }
# Example to get all IP's for a CIDR
# Get-ValidIPAddressinRange -ip 192.168.0.1/24
################ ********************* ####################
# Lists all individual IPs in a range 
################ ********************* ####################
function Get-AllIPsInRange 
{
<# 
  .SYNOPSIS  
   Get the IP addresses in a range 
   
  .EXAMPLE 
   Get-IPrange -start 192.168.8.2 -end 192.168.8.20 
  .EXAMPLE 
   Get-IPrange -ip 192.168.8.2 -mask 255.255.255.0 
  .EXAMPLE 
   Get-IPrange -ip 192.168.8.3 -cidr 24 
#> 
 
param 
( 
  [string]$start, 
  [string]$end, 
  [string]$ip, 
  [string]$mask, 
  [int]$cidr 
) 
 
function IP-toINT64 () { 
  param ($ip) 
 
  $octets = $ip.split(".") 
  return [int64]([int64]$octets[0]*16777216 +[int64]$octets[1]*65536 +[int64]$octets[2]*256 +[int64]$octets[3]) 
} 
 
function INT64-toIP() { 
  param ([int64]$int) 

  return (([math]::truncate($int/16777216)).tostring()+"."+([math]::truncate(($int%16777216)/65536)).tostring()+"."+([math]::truncate(($int%65536)/256)).tostring()+"."+([math]::truncate($int%256)).tostring() )
} 
 
if ($ip) {$ipaddr = [Net.IPAddress]::Parse($ip)} 
if ($cidr) {$maskaddr = [Net.IPAddress]::Parse((INT64-toIP -int ([convert]::ToInt64(("1"*$cidr+"0"*(32-$cidr)),2)))) } 
if ($mask) {$maskaddr = [Net.IPAddress]::Parse($mask)} 
if ($ip) {$networkaddr = new-object net.ipaddress ($maskaddr.address -band $ipaddr.address)} 
if ($ip) {$broadcastaddr = new-object net.ipaddress (([system.net.ipaddress]::parse("255.255.255.255").address -bxor $maskaddr.address -bor $networkaddr.address))} 
 
if ($ip) { 
  $startaddr = IP-toINT64 -ip $networkaddr.ipaddresstostring 
  $endaddr = IP-toINT64 -ip $broadcastaddr.ipaddresstostring 
} else { 
  $startaddr = IP-toINT64 -ip $start 
  $endaddr = IP-toINT64 -ip $end 
} 
 
 
for ($i = $startaddr; $i -le $endaddr; $i++) 
{ 
  INT64-toIP -int $i 
}

}
# Example to take output from Get-ValidIPAddressInRange
# Get-AllIPsInRange -start $ips.HostMin -end $ips.HostMax
#$gaia = Get-AllIPsInRange -start '10.10.10.1' -end '10.10.10.100' 
#$gaia

function Get-Range {
Param ($IPRange)
    #$ComparedIPs = $Null
    $IPRange1 = Get-ValidIPAddressinRange -ip $IPRange
    #write-host "range 1" $IPRange1
    $IPList = Get-AllIPsInRange -start $IPRange1.HostMin -end $IPRange1.HostMax
	#write-host "Range 1 " $IPList 
	return $IPList
}	


function Get-RangeList {
Param ($IPRange1Be,$IPRange1En)
	#write-host "IPRange1Be" $IPRange1Be
	#write-host "IPRange1En" $IPRange1En
    $IPList1 = Get-AllIPsInRange -start $IPRange1Be -end $IPRange1En
   	#write-host "Range List" $IPList1 
	return $IPList1 
}




Function Run-MySQLQuery {

Param(
[Parameter(
Mandatory = $true,
ParameterSetName = '',
ValueFromPipeline = $true)]
[string]$query,
[Parameter(
Mandatory = $true,
ParameterSetName = '',
ValueFromPipeline = $true)]
[string]$connectionString
)
Begin {
	Write-Verbose "Starting Begin Section"
}

Process {
	Write-Verbose "Starting Process Section"
	try {
		# load MySQL driver and create connection
		Write-Verbose "Create Database Connection"
		# You could also could use a direct Link to the DLL File
		# $mySQLDataDLL = "C:\scripts\mysql\MySQL.Data.dll"
		# [void][system.reflection.Assembly]::LoadFrom($mySQLDataDLL)
		[void][System.Reflection.Assembly]::LoadWithPartialName("MySql.Data")
		$connection = New-Object MySql.Data.MySqlClient.MySqlConnection
		$connection.ConnectionString = $ConnectionString
		Write-Verbose "Open Database Connection"
		$connection.Open()

		# Run MySQL Querys
		Write-Verbose "Run MySQL Querys"
		$command = New-Object MySql.Data.MySqlClient.MySqlCommand($query, $connection)
		$dataAdapter = New-Object MySql.Data.MySqlClient.MySqlDataAdapter($command)	
		$dataSet = New-Object System.Data.DataSet
		$recordCount = $dataAdapter.Fill($dataSet, "data")
		$dataSet.Tables["data"] | out-string # Format-Table
	} catch {
		Write-Host "Could not run MySQL Query" $Error[0]
	}

	Finally {
		Write-Verbose "Close Connection"
		$connection.Close()
	}
}

End {
	Write-Verbose "Starting End Section"
}
}


	
#----------------------------
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
    # Write-host "Connecting using readonly and provided password"
    }
    else
    {
    # encode credentials
    Write-host "Connecting using readonly and provided password`n"
    }
$password = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($password))
# Set connection string
$DBConnectionString = "Driver={PostgreSQL ANSI(x64)};Server=$VNE;Port=$DBPort;Database=$DBName;Uid=$DBUser;Pwd=$Password;sslmode=require;"
# Test Connection (if required)
If($TestConnection -eq $True){Check-PGDB}


# Query to retrieve data
Write-Host "**************** Agency Networks Duplication IP360 *****************`n" -ForegroundColor Green

$qn = @"
    select c.name as CustomerName, n.name as NetworkName,
--	n.active as NetworkActive, 
       n.network_id as NetworkId
		,nr.range as range
		--, nr.exclude as exclude
--	nsp.name as ScanProfileName, nsp.active as ScanProfileActive, nsc.name as ScanConfigurationName 
	--nsc.pool_id, 
--	nsc.active as ScanConfigurationActive, nsp.vuln_scan as VulnScan
	from nc_network as n
--	left join nc_scan_config nsc on n.network_id=nsc.network_id
	left join nc_customer as c on n.customer_id=c.customer_id
	join nc_network_range as nr on n.network_id=nr.network_id	
--	left join nc_scan_profile as nsp on nsp.scan_profile_id=nsc.scan_profile_id
	--left join nc_pool p on nsc.pool_id=p.pool_id 
	where n.deleted = 'f'
	and nr.exclude = 'f'
--	and n.network_type ='default' -- field available on 9.0 
	and c.name like '%$CustomerName%'
	and c.deleted = 'f'
--	and nsp.vuln_scan = 't' 
	order by c.customer_id, n.network_id;

"@

# Execute query
$net1  = PGDBQuery -DBConnectionString $DBConnectionString -query $qn #| format-table 


# Examples
#$ex=Get-Range("10.10.10.0/24")
#$ex2=Get-RangeList -IPRange1Be "20.20.20.1" -IPRange1En "20.20.20.100"
#$ex
#$ex2

$allsubcname  = New-Object System.Collections.ArrayList
$allsubcinfo  = New-Object System.Collections.ArrayList
$ip360range   = New-Object System.Collections.ArrayList
$result   	  = New-Object System.Collections.ArrayList	

[void]$result.Add("**************** Agency Networks Duplication IP360*****************")

#$net1

foreach ($h in $net1) {
	# Loop through ip360 networks and create a list of sub-customers and
	[void]$allsubcname.Add($h.Item("customername"))
}
$allsubcname = $allsubcname | select -uniq
#$allsubcname

foreach ($hum in $net1) {
	$ip360range="empty"
	if ($hum.item("range") -like ('*-*') ) {
		$ri=$hum.item("range").Split('-')
		$ip360range=Get-RangeList -RangeList -IPRange1Be $ri[0] -IPRange1En $ri[1]
		#write-host "ip360.", $ri[0], $ri[1]
	} elseif ($hum.Item("range") -like ('*/*') ) {
		$ip360range=Get-Range($hum.item("range"))
		#write-host "ip360 ", $hum.item("range")
	} elseif ($hum.Item("range") -like ('*.*.*.*') ) {
		$ip360range=$hum.Item("range").trim()
		#write-host "ip360 ", $hum.item("range")
	} else {
		write-host "Not processing" $hum.Item("customername") " " $hum.Item("networkid") " " $hum.Item("networkname") " " $hum.Item("range")
	}
	if($ip360range -ne "empty") {
		#write-host "-----dxxxxx--------------"  $hum.Item("networkid") $hum.Item("networkname") $ip360range,
		[void]$allsubcinfo.Add($hum.Item("customername")+"|"+$hum.Item("networkid")+"|"+$hum.Item("networkname")+"|"+$hum.Item("range")+"|"+$ip360range)						
	} 
}

#write-host "-------------------------------------------------------"
function compareNets {
Param ($IPRange1,$IPRange2)

	$res=New-Object System.Collections.ArrayList


	$netw1=$IPRange1.split(" ")
	$netw2=$IPRange2.split(" ")
	
	#$netw2
	
	foreach($a in $netw1) {
		#write-host "-z-", $a 
		foreach($b in $netw2) {
		#write-host "-zz-", $b 
			if ($a.trim() -eq $b.trim()) {
				$found="y"
				#write-host "MATCHED" , $a.trim(), $b.trim() 
				[void]$res.Add($a)
			}
		}
	}		
	#$res
	return $res
}

$exc=New-Object System.Collections.ArrayList

foreach ($cus1 in $allsubcinfo) {
	$cus1Split=$cus1.split("|")
	$seen=""
	#write-host "--xxxx--" $fa
	foreach ($cus2 in $allsubcinfo) {
		$cus2Split=$cus2.split("|")
		if($cus1Split[0] -eq $cus2Split[0]) {
			if($cus1Split[1] -ne $cus2Split[1]) {
				$seen=$cus1Split[1]+$cus2Split[1]
				#write-host "--excs----" $seen
				if($exc.Contains($seen)) {
				#	write-host "Seen before" $seen " in " $exc
				} else {
					#write-host "Will compare " $cus1Split[0] $cus1Split[1] $cus1Split[2] " and " $cus2Split[0] $cus2Split[1] $cus2Split[2]
					[void]$exc.Add($cus1Split[1]+$cus2Split[1])
					[void]$exc.Add($cus2Split[1]+$cus1Split[1])
					$com=compareNets -IPRange1 $cus1Split[4] -IPRange2 $cus2Split[4]	
					if ($com -ne $null) {
						write-host "Comparing networks " $cus1Split[0] $cus1Split[1] $cus1Split[2] " and " $cus2Split[0] $cus2Split[1] $cus2Split[2]
						write-host "IP duplication found", $com
						write-host " "
					}
				}	
			} else {
				#write-host "Not comparing " $cus1Split[0] $cus1Split[1]  " and " $cus2Split[0] $cus2Split[1]
			}			
		}	
	}	 
}

#$result | Out-File ./IP360-SN-Comparison.txt


#if($ExportPath  -ne $null){
	# Remove pre-existing report
#	Remove-Item $ExportPath
#	Write-host "Exporting to", $ExportPath
#	$CSVExportFile | Out-File -FilePath $ExportPath -Force
#	$result | Out-File -FilePath $ExportPath -Force 
#}


Remove-Variable TestConnection, ExportPath