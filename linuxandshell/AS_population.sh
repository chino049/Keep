#!/usr/bin/sh
#   Author: jordonez
#   This only applies to 683 upgrade 
#   Populate nc_auth_server table, with a FQDN hostname from IP, and Realm from the user path
#

PUTFQDNHERE='put FQDN here'
ASSERVERS=`/hive/vendor/pgsql/bin/psql -U postgres -d ice -c "select hostname from nc_auth_server where hostname ~ E'^[0-9]{1,3}(\.[0-9]{1,3}){3}$' " `
RC=$?

if [ $RC -eq 0 ]
then
	for IP in ${ASSERVERS}
	do
        	# the select command will displays dashes, which breaks the nslookup command. 
        	dashes=`echo $IP | grep "\-\-\-" `
              	RCdashes=$?

                if [ $RCdashes -ne 0 ] 
                then
               		NSLOOK=`nslookup $IP`
                        RC=$?
                        if [ $RC -eq 0 ]
                        then
				matchGrep=`echo ${NSLOOK} | grep "name =" `
			        RCmatch=$?	
                                if [ $RCmatch -eq 0 ]
                                then
					matchDNS=`echo ${matchGrep} | cut -d = -f 2 | /hive/vendor/bin/perl -pe ' s/\.$//g; s/^\s+//g;' `
                                	/hive/vendor/pgsql/bin/psql -U postgres -d ice -c "update nc_auth_server set hostname =  '${matchDNS}' where auth_ip = '${IP}' "
					RCpsql=$?
					if [ $RCpsql -eq 0 ]
        				then
                				echo "update of Authentication server's name to FQDN successful."
        				else
                				echo "FAIL to update Authentication server's name to FQDN"
	                                	/hive/vendor/pgsql/bin/psql -U postgres -d ice -c "update nc_auth_server set hostname = '${PUTFQDNHERE}' where auth_ip = '${IP}' "
        				fi
				else
					echo "FAIL No IP to FQDN match found for update. No updating of Authentication server's name to FQDN"
	                               	/hive/vendor/pgsql/bin/psql -U postgres -d ice -c "update nc_auth_server set hostname = '${PUTFQDNHERE}' where auth_ip = '${IP}' "
                                fi
		        else 
				echo "FAIL nslookup. Can not run nslookup"
	                        /hive/vendor/pgsql/bin/psql -U postgres -d ice -c "update nc_auth_server set hostname = '${PUTFQDNHERE}' where auth_ip = '${IP}' "
			fi 
                fi
        done
fi


KRSERVERS=`/hive/vendor/pgsql/bin/psql -U postgres -d ice -c "select auth_realm from nc_auth_server where auth_realm like '%cn%' "  `
RC=$?

if [ $RC -eq 0 ]
then
        for LP in $KRSERVERS 
        do
		# the select command will displays dashes, which breaks the nslookup command. 
                dashes=`echo $LP | grep "\-\-\-" `
                RCdashes=$?

                if [ $RCdashes -ne 0 ] 
                then
                        matchKR=`echo $LP | grep "cn=" | /hive/vendor/bin/perl -pe 's/.*?dc=([^,]*),?/$1\./g' | sed -e 's/\s*\.$//g' | tr [a-z] [A-Z] `
                        RCmatch=$?
                        if [ $RCmatch -eq 0 ]
                        then
                        	/hive/vendor/pgsql/bin/psql -U postgres -d ice -c "update nc_auth_server set auth_realm = '${matchKR}' where auth_realm = '${LP}' "
				RCpsql=$?
                                if [ $RCpsql -eq 0 ] 
                                then    
                                        echo "update of Authentication server's Realm successful."
                                else   
                                	echo "FAIL to update Authentication server's Realm field"
				fi
                        else
				echo "FAIL Empty LDAP path field. Can not update Authentication server's Realm field"
			fi      
                fi
        done
fi

