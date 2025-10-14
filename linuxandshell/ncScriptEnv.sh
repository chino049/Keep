#!/bin/sh
#------------------------------------------------------------------------------
#	Define the nCircle Script Environment.
#------------------------------------------------------------------------------
NC_FUNCTION_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";	export NC_FUNCTION_DIR
NC_LOG_DIR=/data/log/vne;						export NC_LOG_DIR
#------------------------------------------------------------------------------
#	Define the PostgreSQL environment.
#------------------------------------------------------------------------------
PGDATABASE=ice;				export PGDATABASE
PGDATA=/data/pgsql/9.2/data;		export PGDATA
PGUSER=ironwood;			export PGUSER
PGPASSWORD=ironwood;			export PGPASSWORD
PATH="/usr/pgsql-9.2/bin/pg_ctl:$PATH";	export PATH
#LD_LIBRARY_PATH="/hive/vendor/lib:/hive/vendor/pgsql/lib";	export LD_LIBRARY_PATH
#------------------------------------------------------------------------------
#	Exit.
#------------------------------------------------------------------------------
