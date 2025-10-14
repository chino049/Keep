#!/usr/bin/sh

VAR=`psql -c "select hostname from nc_auth_server"`
RC=$?

#echo $VAR
if [ $RC -eq 0 ]
then
        for IP in $VAR
        do
                greep=`echo $IP | grep "\-\-\-" `
                RCgreep=$?

                graap=`echo $IP | grep "hostname" `
                RCgraap=$?

                griip=`echo $IP | grep ".com" `
                RCgriip=$?


#               echo $RCgreep $RCgraap $RCgriip

                if [ $RCgreep -ne 0 ] && [ $RCgraap -ne 0 ] && [ $RCgriip -ne 0 ]
                then
                        ns=`nslookup $IP`
                        RC=$?
                        if [ $RC -eq 0 ]
                        then
                                matchDNS=`echo $ns | grep "name =" `
                                RCmatch=$?
                                if [ $RC -eq 0 ]
                                then
                                        echo $matchDNS
                                fi
                        fi
                fi
        done
fi

