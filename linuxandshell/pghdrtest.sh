#!/bin/sh
for x in `find /sql/data/base/[0-9]* -type f -name '[0-9]*'`; do
        ./pg_filedump $x | grep "Invalid header" >/dev/null
        if [ $? -eq 0 ]; then
                echo "Found invalid headers in file: $x"
        fi
done

