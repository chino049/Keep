get_message_text()
{
	#----------------------------------------------------------------------
	#	Command Line Arguments.
	#----------------------------------------------------------------------
	MY_NAME="get_message_text"
	MESSAGE_NAME=${1:?"${MY_NAME}: Error, you must specify a message name."}
	PARAMETER_FILE=${2:?"${MY_NAME}: Error, you must specify a file containing message parameters."}
	MESSAGE_FILE="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"/message.txt

	#----------------------------------------------------------------------
	#	Environment.
	#----------------------------------------------------------------------
	NC_FUNCTION_DIR=${NC_FUNCTION_DIR:?"${MY_NAME}: Error, environment variable NC_FUNCTION_DIR is undefined."}

	#----------------------------------------------------------------------
	#	Common Functions.
	#----------------------------------------------------------------------
	
	#----------------------------------------------------------------------
	#	Generate the SQL to retrieve the message text.
	#----------------------------------------------------------------------
	MESSAGE_TEXT=`grep ${MESSAGE_NAME} $MESSAGE_FILE`
	if [ "${MESSAGE_TEXT}" = "" ]
	then
		MESSAGE_TEXT="No Message for message name $MESSAGE_NAME"
		echo "${MESSAGE_TEXT}" 
	else
		SED_FILE="/tmp/${MY_NAME}.$$.sed"		# Arguments to "sed".

		#----------------------------------------------------------------------
		#	Substitute for placeholders in the message text.
		#----------------------------------------------------------------------
		exec <${PARAMETER_FILE}
		while read RECORD
		do
			VAR_NAME="`echo $RECORD | awk -F= '{print $1}'`"
			VAR_VALUE="`echo $RECORD | awk -F= '{print $2}'`"

			echo "s#@${VAR_NAME}@#"${VAR_VALUE}"#g" >> $SED_FILE
		done
	
		#----------------------------------------------------------------------
		#	Display the message text.
		#----------------------------------------------------------------------
		echo "${MESSAGE_TEXT}" | awk -F "|" '{print $2}' | sed -f ${SED_FILE}
	
		#----------------------------------------------------------------------
		#	Clean-up.
		#----------------------------------------------------------------------
		rm -f	${SED_FILE} 
	fi
	
	#----------------------------------------------------------------------
	#	Return.
	#----------------------------------------------------------------------
	return
}
