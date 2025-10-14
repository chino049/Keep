get_email_recipient()	{
	#----------------------------------------------------------------------
	#	Determine the email recipient.
	#----------------------------------------------------------------------
	MY_NAME="get_email_recipient"

	#----------------------------------------------------------------------
	#	Command Line Arguments.
	#----------------------------------------------------------------------
	MODULE="${1}"

	#----------------------------------------------------------------------
	#	Email recipient is a function of MODULE.
	#----------------------------------------------------------------------
	if	[ ! -z "$MODULE" ]
	then
		MODULE="`echo ${MODULE} | tr \"[:lower:]\" \"[:upper:]\"`"
		MODULE="\$${MODULE}_MAILING_LIST"
		eval SEND_TO="`echo ${MODULE}`"
	fi

	if	[ -z "$SEND_TO" ]
	then
		SEND_TO="${NCIRCLE_MAILING_LIST}"
	fi

	echo "$SEND_TO"
}
