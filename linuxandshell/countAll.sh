#!/usr/bin/sh

All=`/hive/vendor/pgsql/bin/psql -d ice -U postgres -t -c "select tablename from pg_tables where tablename ~ 'nc';" `

for row in $All
do
        eachrow=`/hive/vendor/pgsql/bin/psql -d ice -U postgres -t -c "select count(*) from $row;" `
        echo $eachrow
        
done

