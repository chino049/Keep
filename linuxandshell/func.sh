#!/bin/sh
#       Local functions.
up() {
	file=`ls /data/jordonez/shell`
	echo "Please wait while getting files"
	echo $file 
}

down() {
	dow=`du -h`
	echo "getting disk usage  " $dow

}

echo "Running program"
up
down

