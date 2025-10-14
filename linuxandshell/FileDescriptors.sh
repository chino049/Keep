#!/usr/bin/sh

# Builtin variables
#  $0             Name of this shell script itself.
#  $1             Value of first command line parameter (similarly $2, $3, etc)
#  $#             In a shell script, the number of command line parameters.
#  $*             All of the command line parameters.
#  $-             Options given to the shell.
#  $?             Return the exit status of the last command.
#  $$             Process id of script (really id of the shell running the script)


# file descriptor 0 is standard in
# file descriptor 1 is standard out
# file descriptor 2 is standard error 

# file I/O
# program > file    - program output gets redirected to file 
# program < file    - program reads inout from file  
# program >> file   - program output gets appended to file  
# program | program - ptogram output gets piped into program 

# 2 > file          - output from stream with descriptor is redirected to a file
# 1 >> file         - output from stream with descriptor is appended to a file
# 1 >& 0            - merge output from stream to stream 
# 1 <& 2	    - merge input from stream to stream 

echo "Enter name of file to display "
read fileTodisplay
LOG='/tmp/shell.OUT'

echo `cat  $fileTodisplay  > $LOG 2>&1  `
#if [$? -ne 0];
if [$? != 0];
then
	echo `cat $LOG` ;
fi


