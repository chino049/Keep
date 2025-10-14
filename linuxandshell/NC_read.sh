#!/usr/bin/sh

NCTABLES=`psql -d ice -c "select tablename from pg_tables where schemaname = 'public'"; `
RC=$?

if [ $RC -eq 0 ]
then
        for ROW in ${NCTABLES}
        do
                # the select command will displays dashes, which breaks the nslookup command.
                dashes=`echo $ROW  | grep "\-\-\-" `
                RCdashes=$?

                if [ $RCdashes -ne 0 ]
                then
                        if [  `expr $ROW : 'nc_'` != 0 ]
                        then
                                SEL=`psql -U postgres -d ice -c "select count(*) from $ROW "  `
                                echo $ROW
                                echo $SEL

                        fi
                fi
        done
fi
