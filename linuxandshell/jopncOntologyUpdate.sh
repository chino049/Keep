#!/bin/sh
#------------------------------------------------------------------------------
#	Invoke the Ontology Update Script.
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
#	Validate the environment.
#------------------------------------------------------------------------------
#JOP . /usr/lib/vne/script-env/ncScriptEnv.sh
./ncScriptEnv.sh

NC_FUNCTION_DIR=${NC_FUNCTION_DIR:?"Error, environment variable NC_FUNCTION_DIR is undefined."}

#------------------------------------------------------------------------------
#	Unalias.
#------------------------------------------------------------------------------
unalias -a

#------------------------------------------------------------------------------
#	Load Functions.
#------------------------------------------------------------------------------
. ${NC_FUNCTION_DIR}/get_DATE.sh
. ${NC_FUNCTION_DIR}/get_EXECNAME.sh
. ${NC_FUNCTION_DIR}/get_LOGFILE.sh
. ${NC_FUNCTION_DIR}/put_starting.sh
. ${NC_FUNCTION_DIR}/put_stopping.sh

#------------------------------------------------------------------------------
#	Local variables.
#------------------------------------------------------------------------------
	#--------------------------------
	#	Independent
	#--------------------------------
NC_EXECNAME=`get_EXECNAME`	# This script.
NC_TIMESTAMP=`get_DATE`		# Timestamp for log file (YYYYMMDD).
unset LD_LIBRARY_PATH

	#--------------------------------
	#	Dependent
	#--------------------------------
LOG_FILE=`get_LOGFILE`		# Send all output to this file.

#------------------------------------------------------------------------------
#	Write Starting message.
#------------------------------------------------------------------------------
put_starting	>> $LOG_FILE

#------------------------------------------------------------------------------
#	Run the executable.
#------------------------------------------------------------------------------
echo "Starting 'Ontology Update' at `date`."	>> $LOG_FILE
admincli -c "vne.aspl.update latest"  >> $LOG_FILE 2>&1
RC=$?

if	[ $RC -eq 0 ]
then
	echo "'Ontology Update' completed successfully at `date`."	>> $LOG_FILE
else
	echo "'Ontology Update' failed at `date`."			>> $LOG_FILE
	echo "The exit code is '${RC}'."		>> $LOG_FILE
fi

#------------------------------------------------------------------------------
#	Clean-up.
#------------------------------------------------------------------------------
put_stopping	>> $LOG_FILE

#------------------------------------------------------------------------------
#	Exit.
#------------------------------------------------------------------------------

