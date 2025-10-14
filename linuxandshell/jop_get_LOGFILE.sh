NC_FUNCTION_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )";    export NC_FUNCTION_DIR
NC_LOG_DIR=/data/log/vne;                                               export NC_LOG_DIR
#------------------------------------------------------------------------------
#       Define the PostgreSQL environment.
#------------------------------------------------------------------------------
PGDATABASE=ice;                         export PGDATABASE
PGDATA=/data/pgsql/9.2/data;            export PGDATA
PGUSER=ironwood;                        export PGUSER
PGPASSWORD=ironwood;                    export PGPASSWORD
PATH="/usr/pgsql-9.2/bin/pg_ctl:$PATH"; export PATH
#LD_LIBRARY_PATH="/hive/vendor/lib:/hive/vendor/pgsql/lib";     export LD_LIBRARY_PATH



get_LOGFILE()
{
        echo "Begin"
	#----------------------------------------------------------------------
	#	Determine the file name where messages will be logged.
	#----------------------------------------------------------------------
	NC_FUNCTION_DIR=${NC_FUNCTION_DIR:?"get_LOGFILE: Error, environment variable NC_FUNCTION_DIR is undefined."}
	NC_LOG_DIR=${NC_LOG_DIR:?"get_LOGFILE: Error, environment variable NC_LOG_DIR is undefined."}

	#----------------------------------------------------------------------
	#	Common Functions.
	#----------------------------------------------------------------------
	. ${NC_FUNCTION_DIR}/get_EXECNAME.sh
	. ${NC_FUNCTION_DIR}/get_TIMESTAMP.sh

	#----------------------------------------------------------------------
	#	Construct the file name.
	#----------------------------------------------------------------------
	NC_EXECNAME=${NC_EXECNAME:=`get_EXECNAME`}
	NC_TIMESTAMP=${NC_TIMESTAMP:=`get_TIMESTAMP`}

	echo "${NC_LOG_DIR}/${NC_EXECNAME}.${NC_TIMESTAMP}.log"
}
get_LOGFILE

