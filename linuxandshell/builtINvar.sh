#  $0             Name of this shell script itself.
#  $1             Value of first command line parameter (similarly $2, $3, etc)
#  $#             In a shell script, the number of command line parameters.
#  $*             All of the command line parameters.
#  $-             Options given to the shell.
#  $?             Return the exit status of the last command.
#  $$             Process id of script (really id of the shell running the script)

echo $0
echo $1
echo $#
echo $*
echo $-
echo $?
echo $$


