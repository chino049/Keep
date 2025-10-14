get_PSEUDO_LOGFILE()
{
	#----------------------------------------------------------------------
	#	Hide the true log file name from the end-user.
	#----------------------------------------------------------------------
	THE_LOGFILE=${1:?"get_PSEUDO_LOGFILE: Error, you must specify a log file."}
	NC_FUNCTION_DIR=${NC_FUNCTION_DIR:?"get_PSEUDO_LOGFILE: Error, environment variable NC_FUNCTION_DIR is undefined."}

	#----------------------------------------------------------------------
	#	Common Functions.
	#----------------------------------------------------------------------
	. ${NC_FUNCTION_DIR}/dosql.sh
	. ${NC_FUNCTION_DIR}/get_EXECNAME.sh

	#----------------------------------------------------------------------
	#	Local variables.
	#----------------------------------------------------------------------
	NC_EXECNAME=${NC_EXECNAME:=`get_EXECNAME`}
	SQL=/tmp/${NC_EXECNAME}.get_PSEUDO_LOGFILE.sql.$$	# SQL commands.
	SQL_ERROR=/tmp/${NC_EXECNAME}.get_PSEUDO_LOGFILE.err.$$	# SQL errors.

	#----------------------------------------------------------------------
	#	Determine the pseudo log file name.
	#----------------------------------------------------------------------
	echo "select nc_put_errorlog('${THE_LOGFILE}');"	> $SQL
	PSEUDO_LOGFILE="`dosql $SQL 2> $SQL_ERROR`"

	if	[ \( ! -z "$PSEUDO_LOGFILE" \)  -a \( ! -s $SQL_ERROR \) ]
	then
		#--------------------------------------------------------------
		#	Refer the user to the pseudo log file.
		#--------------------------------------------------------------
		RESULT="${PSEUDO_LOGFILE}"
	else
		#--------------------------------------------------------------
		#	Refer the user to the true log file.
		#	SQL error prevents generation of PSEUDO_LOGFILE.
		#--------------------------------------------------------------
		RESULT="`basename ${THE_LOGFILE}`"
	fi

	echo $RESULT

	#----------------------------------------------------------------------
	#	Clean-up.
	#----------------------------------------------------------------------
	rm -f $SQL $SQL_ERROR
}
