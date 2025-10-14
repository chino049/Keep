(Select-String -Path .\Tabular.rel -Pattern "(.*):(.*)_v(.*)").Matches.groups[2,3].Value
$co=(Select-String -Path .\Tabular.rel –Pattern "(.*):(.*)_v(.*)").Matches.groups[2].Value ; $ve=(Select-String -Path .\Tabular.rel -Pattern "(.*):(.*)_v(.*)").Matches.groups[3].Value ; echo $co",V"$ve
powershell (Select-String -Path c:\Tabular\Tab.rel -Pattern """(.*):(.*)_v(.*)""").Matches.groups[3].Value
powershell -Version 2.0 $ve=(Select-String -Path c:\Tabular\Tab.rel -Pattern """BINARY_REL_NAME:(.*)""") ; $ve -split '_v' , 2
powershell (Select-String -Path c:\Tabular\Tab.rel -Pattern """(.*):(.*)_v(.*)""").Matches.groups[3].Value
powershell -Version 2.0 $ve=(Select-String -Path c:\Tabular\Tab.rel -Pattern """BINARY_REL_NAME:(.*)""") ; $fred = $ve -split ('_v'); echo $fred[1]
powershell -Version 2.0 $ve=(Select-String -Path c:\Tabular\Tab.rel -Pattern """BINARY_REL_NAME:(.*)""") ; $modVer = $ve -split ('_v'); echo $modVer[1]
