fqdnHostname()	{
	#
	#	Populate nc_auth_server table, with a FQDN hostname from IP, and Realm from the user path
	#
	ME="fqdnHostname"
	LOG_FILE=${LOG_FILE:?"${ME}: Error, LOG_FILE is undefined."}
        PSQL=${PSQL:?"${ME}: Error, PSQL is undefined."}
        SQL_ERROR=${SQL_ERROR:?"${ME}: Error, SQL_ERROR is undefined."}
	USERNAME_LIST=${USERNAME_LIST:?"${ME}: Error, USERNAME_LIST is undefined."}
	DATABASE="ice"

	ASCMD="select hostname from nc_auth_server"
	ASSERVERS=`${PSQL} -d ${DATABASE} -c ${ASCMD}` 
	RC=$?

	if [ $RC -eq 0 ]
	then
        	for IP in ${ASSERVERS} 
        	do
			# the select command will displays dashes, which breaks the nslookup command. 
                	dashes=`echo $IP | grep "\-\-\-" `
                	RCdashes=$?

			# This will help determine an existing authentication server, with a valid FQDN
                	existingServerRC=`echo $IP | grep ".com" `
                	RCexistingServer=$?

                	if [ $RCdashes -ne 0 ] && [ $RCexistingServer -ne 0 ]
                	then
                        	NSLOOK=`nslookup $IP`
                        	RC=$?
                        	if [ $RC -eq 0 ]
                        	then
                                	matchDNS=`echo ${NSLOOK} | grep "name =" | cut -d = -f 2 | sed -e 's/\.$//g'`
                                	RCmatch=$?
                                	if [ $RCmatch -eq 0 ]
                                	then
                                        	${PSQL} -d ${DATABASE} -c "update nc_auth_server set hostname =  '${matchDNS}' where auth_ip = '${IP}' "
						RCpsql=$?
						if [ $RCpsql -eq 0 ]
        					then
                					write_log "update of Authentication server's name to FQDN successful."
        					else
                					write_log "Fail to update Authentication server's name to FQDN!"
        					fi
                                	fi
                        	fi
                	fi
        	done
	fi

	KRCMD="select ldap_path from nc_auth_server where auth_realm = '' or auth_realm is NULL and ldap_path is not NULL"
	KRSERVERS=


