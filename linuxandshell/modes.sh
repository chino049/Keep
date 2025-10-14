#!/bin/sh

MODES="reboot manual maintenance upgrade normal"
MODEFILE="vnemode"

# NORMAL also includes all processes from MAINTENANCE
NORMAL="reportd eventd hostd cheserver cron schedulerd"
UPGRADE="apache-upgrade postgres sshd ched"
MAINTENANCE="apache dbd postgres sshd ched imageserver objectapi objectapixx"
MANUAL=""
REBOOT=""


usage() {
        echo "Usage: $0 [-d] <mode> [LOCK PID]"
        echo "  Where mode is one of: $MODES"
        echo "  Specifying the optional LOCK PID argument will"
        echo "  prevent other components from making mode changes"
        echo "  until LOCK PID expires or clear_modelock is called."
        exit 1
}

#echo $0 $1 a$1 $2

if [ "a$1" = "a" ]; then
        usage
fi

DEBUG=0
if [ "a$1" = "a-d" ]; then
        DEBUG=1
        shift
        echo "In debug:" $DEBUG
fi

MODE=$1

for x in $MODES; do
#        echo a$x
#       echo a$MODE
        if [ "a$MODE" = "a$x" ]; then
                FOUND=1
		echo "Found :" $FOUND "mode" a$MODE
        fi
done


CURRENT_MODE=""
if [ -f $MODEFILE ]; then
        CURRENT_MODE=`cat $MODEFILE`
        echo "current mode is:" $CURRENT_MODE
fi

if [ "X$CURRENT_MODE" != "X" ]; then
        if [ "X$MODE" = "X$CURRENT_MODE" ]; then
                echo "We're already in mode $MODE"
                exit 0
        fi
fi


echo "$MODE" > $MODEFILE
echo "[INFO] Setting mode to: $MODE"

FAILED=0

#echo "the mode is" x$MODE

case "x$MODE" in
        xnormal)
                echo "entering normal"
                if [ "a$CURRENT_MODE" != "a" ]; then
                        echo "current mode is:" a$CURRENT_MODE
                fi

                PROCS=""
                for x in $MAINTENANCE; do
                        echo "maintenance" $x 
                done
                for x in $NORMAL; do
                       echo "normal" $x 
                done
                START_FILES=$PROCS 
                for x in $START_FILES; do
                        echo "starting:" $x 
                done
                ;;

        xupgrade)
           
                echo "entering upgrade"
                PROCS="$NORMAL"
                STOP_PROCS=""
                for x in $PROCS; do
                        echo "Stopping proc" $STOP_PROCS $x
                done
                STOP_FILES=$STOP_PROCS 
                for x in $STOP_FILES; do
                        echo "Stopping files" $STOP_FILES $x 
                done

                START_PROCS=""
                for x in $UPGRADE; do
                        echo "Starting proc" $START_PROCS $x
                done
                START_FILES=$START_PROCS 
                for x in $START_FILES; do
                        echo "Starting files" $START_FILES $x 
                done
                ;;
esac

