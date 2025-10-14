$qn = @"
select n.network_id--, n.name, c.name  
from nc_network n
join nc_customer c on n.customer_id=c.customer_id
where n.deleted = 'f'
and c.name like '%$CustomerName%'
order by c.name;
"@
#Execute query
$net = PGDBQuery -DBConnectionString $DBConnectionString -query $qn 
#$net
$cand = New-Object System.Collections.ArrayList

#$AllNet=@()
#$AllfoundNet = New-Object System.Collections.ArrayList
foreach($rowE in $net) {
	$rowE.Split(":")
	$aud = [int]$rowE[0]
	#$aud
#	$rowE
}	