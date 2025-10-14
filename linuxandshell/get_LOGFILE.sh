get_LOGFILE()
{
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
