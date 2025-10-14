#!/usr/bin/sh 

tar_ball_readable()     {
        #----------------------------------------------------------------------
        #       Is ${TAR_BALL} readable ?
        #----------------------------------------------------------------------
TAR_BALL='/data/jordonez/python/databases.tar'

        if [ -r ${TAR_BALL} ]
        then
                RC=0
        else
                echo "Unable to read '${TAR_BALL}'."
                RC=1
        fi

        echo $RC
}

tar_ball_readable

