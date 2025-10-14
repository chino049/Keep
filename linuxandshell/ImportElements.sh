#!/bin/bash

# PRE-REQS before Running this Script:
#
# Description:
#       Import Elements --
#
# Usage:
#       ImportElement.sh - no arguments
#
# Revisions:
#       1.0     trushton        2017-06-02
#

#
# Env Variables Section:
#
TECHOME=/usr/local/tripwire/tecommander/bin
export TECHOME

SCRIPTHOME=/usr/local/tripwire/Scripts
export SCRIPTHOME

# Due to a potential race condition in Task post exection actions, we need to sleep her
sleep 1m

# Do a Baseline Elements Report to see what elements have been updated
$TECHOME/tecommander.sh report -t baselineelements_rpt -q -w NMAP -x "Output Monitoring" -T BEReport -F xml -o $SCRIPTHOME/tmp/BEReport-$$.xml -P "BooleanCriterio,currentVersionsOnly,true,displayCriteriaAtEnd,true:RelativeTimeRangeCriterion,1,hour,In the last 1 hour"

# Only need to proceed if any results have been returned
if ! grep -q '<Integer name="reportTotal">0</Integer>' $SCRIPTHOME/tmp/BEReport-$$.xml
then
        # Convert to csv format
        $TECHOME/tecommander.sh betocsv -q -i $SCRIPTHOME/tmp/BEReport-$$.xml -o $SCRIPTHOME/tmp/BEReport-$$.csv

        # Delete the xml file
        rm -f $SCRIPTHOME/tmp/BEReport-$$.xml

        IFS='
        '

        #for import in `cat $SCRIPTHOME/tmp/BEReport.csv`
        for import in `cat $SCRIPTHOME/tmp/BEReport-$$.csv`
        do
                if [ x${import} != "x" ]
                then
                        #
                        # Skip header line
                        #
                        if grep -q -v "Node,Total" <<< $import
                        then
                                printf "\n*********************"
                                #
                                # Format of a line from the Baseline Elements Report
                                #
                                # |<----Export Node Name---->| |<---Full name of element to export
            ---->| |PromotionTime|
                                # grescan04.intra.grenergy.com,/usr/local/tripwire/te/agent/data/integrations/whitelist/data/processed/cmbrgiga02.intra.grenergy.cm_ports_policy.txt,4/19/17 3:47 PM,...Rest of line ignored...
                                #                                                                                                      ^--Node Name to Import To -
^ ^-Import Name--^

                                # Get the node name of the host that we need to grab the element from
                                export_node=$(cut -d',' -f 1 <<< $import)
                                export export_node
                                echo export_node= $export_node

                                # Get the element name to export
                                export_element_name=$(cut -d',' -f 2 <<< $import)
                                export export_element_name
                                echo export_element_name= $export_element_name

                                # Next get the node name to import the new content into.
                                import_node=$(cut -d '/' -f 12 <<< $export_element_name | cut -d'_' -f 1)
                                export import_node
                                echo import_node= $import_node

                                # Get the name of the element you want to import
                                import_element_name=$(cut -d '/' -f 12 <<< $export_element_name | cut -d'_' --complement -f 1)
                                echo import_element_name= $import_element_name
                                export import_element_name

                                # Create a zero-lentgh file with the name of the element we wish to import
                                touch $SCRIPTHOME/tmp/$import_element_name

                                # Now export the element contents
                                echo Exporting element contents
                                $TECHOME/tecommander.sh export -q -n "$export_node" -e "$export_element_name" -o $SCRIPTHOME/tmp/$import_element_name

                                # Determine under which rule the element needs to be imported - Documentation, FIM, or Policy
                                if grep -q "policy" <<< $import_element_name
                                then
                                        echo Importing Policy Content
                                        $TECHOME/tecommander.sh createextcontent -q -n "$import_node" -r "Network Ports - Policy - Ext" -e "$import_element_name" T BASELINE -F $SCRIPTHOME/tmp/$import_element_name
                                elif grep -q "documentation" <<< $import_element_name
                                then
                                        echo Importing Documentation Content
                                        $TECHOME/tecommander.sh createextcontent -q -n "$import_node" -r "Network Ports - Documentation - Ext" -e "$import_elementname" -T BASELINE -F $SCRIPTHOME/tmp/$import_element_name
                                elif grep -q "fim" <<< $import_element_name
                                then
                                        echo Importing FIM Content
                                        $TECHOME/tecommander.sh createextcontent -q -n "$import_node" -r "Network Ports - FIM - Ext" -e "$import_element_name" -T BASELINE -F $SCRIPTHOME/tmp/$import_element_name
                                fi

                                # Remove temporary file
                                rm -f $SCRIPTHOME/tmp/$import_element_name

                        fi
                fi
        done

        #
        # Cleanup /tmp directory
        #
        rm -f $SCRIPTHOME/tmp/BEReport-$$.csv
else
        # Delete the xml file
        rm -f $SCRIPTHOME/tmp/BEReport-$$.xml

        echo No changes found - Nothing to do
fi

exit 0