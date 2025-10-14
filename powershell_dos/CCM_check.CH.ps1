$CCMserver = Read-Host -Prompt "Please enter your CCM server host" # "192.168.189.215"
$user = Read-Host -Prompt "Enter your username" # "admin"
$pw = Read-Host -Prompt "Enter your password" # "CTr1p-C4!MS4udi"
$uri = "http://$CCMServer/ncircleweb/webclientapi.asmx?WSDL"
# $credentials = Get-Credential
$api = New-WebServiceProxy -uri $uri 
$session = $api.login($user,$pw)
$api.GetCCMVersion()
# **************************** get policies ******************************************************
# build the soap envelope
$xmltosend = @"
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ncir="http://ncircle.com/">
   <soapenv:Header/>
   <soapenv:Body>
      <ncir:GetPolicies>
         <!--Optional:-->
         <ncir:session>$session</ncir:session>
         <!--Optional:-->
      </ncir:GetPolicies>
   </soapenv:Body>
</soapenv:Envelope>
"@
# send to the appropriate URL
$uri = "http://$ccmserver/ncircleweb/webclientapi.asmx"
$policies = Invoke-RestMethod -uri $uri -Body $xmltosend -Method post -ContentType "text/xml"
#You can view everything with
#$policies.OuterXml
#or you're more likely interested in
$policies.Envelope.Body.GetPoliciesResponse.GetPoliciesResult.CompPolicy | fl Description
# **************************** get assets ******************************************************
$xmltosend = @"
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ncir="http://ncircle.com/">
   <soapenv:Header/>
   <soapenv:Body>
      <ncir:GetAssets>
         <!--Optional:-->
         <ncir:session>$session</ncir:session>
      </ncir:GetAssets>
   </soapenv:Body>
</soapenv:Envelope>
"@
$assets = Invoke-RestMethod -uri $uri -Body $xmltosend -Method post -ContentType "text/xml"
# Show assets
$assets.Envelope.Body.GetAssetsResponse.GetAssetsResult.AssetInfo.AssetRecord # ConvertTo-Csv | Out-File C:\temp\output.csv
# **************************** get scan engines ******************************************************
$xmltosend = @"
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ncir="http://ncircle.com/">
   <soapenv:Header/>
   <soapenv:Body>
      <ncir:GetScanEngines>
         <!--Optional:-->
         <ncir:session>$session</ncir:session>
      </ncir:GetScanEngines>
   </soapenv:Body>
</soapenv:Envelope>
"@
$scanengines = Invoke-RestMethod -uri $uri -Body $xmltosend -Method post -ContentType "text/xml"
# Show the scan engines
$scanengines.Envelope.Body.GetScanEnginesResponse.GetScanEnginesResult.ScanEngine 
