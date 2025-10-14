#!/usr/bin/sh

VAR=`psql -c "select ldap_path from nc_auth_server where auth_realm = '' or auth_realm is NULL and ldap_pat
h is not NULL" `
RC=$?

if [ $RC -eq 0 ]
then
        for LP in $VAR
        do
                greep=`echo $LP | grep "\-\-\-" `
                RCgreep=$?
                if [ $RCgreep -ne 0 ]
                then
                        matchKR=`echo $LP | grep "cn=" | /hive/vendor/bin/perl -pe 's/.*?dc=([^,]*),?/$1\./
g' | sed -e 's/\s*\.$//g' `
                        RCmatch=$?

                        echo $matchKR
                        #cleanKR='echo $match

                        if [ $RCmatch -eq 0 ]
                        then
                                echo $matchKR
                                mak=`psql -c "update nc_auth_server set auth_realm = '${matchKR}' where lda
p_path = '${LP}' "`
                        fi
                fi
        done
fi

