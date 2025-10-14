serial-number:9999999999

#!/bin/sh
# Property of nCircle 
# Date: 10/12/2010
# Author:       Jesus Ordonez
# 
# This script truncates Ontology files prior to current ontology version


CheckUpstream() {
	# If the vne is an upstream, it will not truncate any files
	Up=`/hive/vendor/pgsql/bin/psql -t -d ice -U postgres -c "select count(*) from nc_upgrade_client"`;
	if [ $Up -gt 0 ]
	then
		echo "This is an Upstream VnE. Will not truncate nor delete files"
		exit
	fi
}

GetOntologyVersion() {
        OntVer=`/hive/vendor/pgsql/bin/psql -t -d ice -U postgres -c "select ontology_version from nc_version"` 
        RC_ont=$?

        if [ $RC_ont -ne 0 ]
        then
                echo "[ERROR] reading Ontology version "
        else
		OntArr=$(echo ${OntVer} | tr "," " ")
		echo "Installed Ontology versions are" $OntArr
		for x in ${OntArr} ;
		do
    			if `echo $x | grep "base" 1>/dev/null 2>&1`
			then
				vneBase=`echo $x | grep "base"`
				vneCom=`echo $x | grep "base" | cut -d _ -f2 | cut -d . -f1 | cut -d - -f2`
				vneBaseVer=`echo $x | grep "base" | cut -d _ -f2 | cut -d . -f1 | cut -d - -f3`
			elif `echo $x | grep "nonpci" 1>/dev/null 2>&1`
                        then
                                vneNonpci=`echo $x | grep "nonpci"`
				vneNonVer=`echo $x | grep "nonpci" | cut -d _ -f2 | cut -d . -f1 | cut -d - -f3`
			elif `echo $x | grep "pci" 1>/dev/null 2>&1`
                        then
                                vnePci=`echo $x | grep "pci"`
				vnePciVer=`echo $x | grep "pci" | cut -d _ -f2 | cut -d . -f1 | cut -d - -f3`
			elif `echo $x | grep "spider" 1>/dev/null 2>&1`
                        then
                                vneSpider=`echo $x | grep "spider"`
				vneSpiderVer=`echo $x | grep "spider" | cut -d _ -f2 | cut -d . -f1 | cut -d - -f3`
			elif `echo $x | grep "web" 1>/dev/null 2>&1`
                        then
                                vneWeb=`echo $x | grep "web"`
				vneWebVer=`echo $x | grep "web" | cut -d _ -f2 | cut -d . -f1 | cut -d - -f3`
                        fi
		done
	fi
}

ReplaceNulls() {
	 if [ -z $vneBaseVer  ]
         then
		OntBaseFiles=`ls /hive/upgrades | grep ontology_base`
         	for row in ${OntBaseFiles} ;
                do
			if `echo $row | grep "base" 1>/dev/null 2>&1`
			then
                		vneBaseVer=`echo $row | grep "base" | cut -d _ -f2 | cut -d . -f1 | cut -d - -f3`
			fi
		done
	fi
	if [ -z $vneNonVer ]
	then
		OntNonFiles=`ls /hive/upgrades | grep ontology_nonpci`
		for row in ${OntNonFiles} ;
		do
			if `echo $row | grep "nonpci" 1>/dev/null 2>&1`
                        then
                                vneNonVer=`echo $row | grep "nonpci" | cut -d _ -f2 | cut -d . -f1 | cut -d - -f3`
                        fi
                done
	fi
	if [ -z $vnePciVer ]
	then
		OntPciFiles=`ls /hive/upgrades | grep ontology_pci`
                for row in ${OntPciFiles} ;
                do
                        if `echo $row | grep "ontology_pci" 1>/dev/null 2>&1`
                        then
                                vnePciVer=`echo $row | grep "pci" | cut -d _ -f2 | cut -d . -f1 | cut -d - -f3`
                        fi
                done
	fi
	if  [ -z $vneSpiderVer ]
        then
                OntSpiderFiles=`ls /hive/upgrades | grep ontology_spider`
                for row in ${OntSpiderFiles} ;
                do
                        if `echo $row | grep "spider" 1>/dev/null 2>&1`
                        then
                                vneSpiderVer=`echo $row | grep "spider" | cut -d _ -f2 | cut -d . -f1 | cut -d - -f3`
                        fi
                done
	fi
	if [ -z $vneWebVer ]
	then
		OntWebFiles=`ls /hive/upgrades | grep ontology_web`
                for row in ${OntWebFiles} ;
                do
                        if `echo $row | grep "web" 1>/dev/null 2>&1`
                        then
                                vneWebVer=`echo $row | grep "web" | cut -d _ -f2 | cut -d . -f1 | cut -d - -f3`
                        fi
                done
	fi
}

TruncateFiles() {
	OntOLDFiles=`ls /hive/upgrades | grep ontology-`
	for lin in $OntOLDFiles ;
	do
		echo "Truncate based on Prior to Modular Ontology" $lin
                truncate -s 0 /hive/upgrades/$lin
	done
		
	OntFiles=`ls /hive/upgrades | grep ontology_`
	for r in $OntFiles ;
	do
		fileCom=`echo $r | cut -d _ -f2 | cut -d . -f1 | cut -d - -f2`
		if [ $vneCom -gt $fileCom ]
                then
                        echo "Truncate based on Ont Comp Level" $r
			truncate -s 0 /hive/upgrades/$r
		elif `echo $r | grep "base" 1>/dev/null 2>&1` 
		then 
			fileBaseVer=`echo $r | cut -d _ -f2 | cut -d . -f1 | cut -d - -f3`
			if [ $vneBaseVer -gt $fileBaseVer ] 
			then
				echo "Truncate based on Ont Base Version Level" $r
				truncate -s 0 /hive/upgrades/$r 
			fi	
		elif `echo $r | grep "nonpci"  1>/dev/null 2>&1`
		then
			fileNonVer=`echo $r | cut -d _ -f2 | cut -d . -f1 | cut -d - -f3`
			if [ $vneNonVer -gt $fileNonVer ]
			then
				echo "Truncate based on Ont Nonpci Version Level" $r
				truncate -s 0 /hive/upgrades/$r
			fi 
		elif `echo $r | grep "pci" 1>/dev/null 2>&1`  
		then
			filePciVer=`echo $r | cut -d _ -f2 | cut -d . -f1 | cut -d - -f3`
			if [ $vnePciVer -gt $filePciVer ]
			then
				echo "Truncate based on Ont PCI Version Level" $r
				truncate -s 0 /hive/upgrades/$r
			fi
		elif `echo $r | grep "spider" 1>/dev/null 2>&1` 
                then
			fileSpiderVer=`echo $r | cut -d _ -f2 | cut -d . -f1 | cut -d - -f3`
			if [ $vneSpiderVer -gt $fileSpiderVer ]
			then
				echo "Truncate based on Ont Spider Version Level" $r
				truncate -s 0 /hive/upgrades/$r
                        fi
		elif `echo $r | grep "web" 1>/dev/null 2>&1`
                then
			fileWebVer=`echo $r | cut -d _ -f2 | cut -d . -f1 | cut -d - -f3`
			if [ $vneWebVer -gt $fileWebVer ]
			then
				echo "Truncate based on Ont Web Version Level" $r
				truncate -s 0 /hive/upgrades/$r
			fi
		fi
	done
}


CheckUpstream
GetOntologyVersion
ReplaceNulls
TruncateFiles
