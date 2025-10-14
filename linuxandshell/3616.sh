files=`ls /var/bns/db/CCM`
cd /var/bns/db/CCM
pass="i"
fail="i"
for f in $files; do
        instance_name=`echo $f | sed 's/.*+\(.*\)+\(.*\)+\(.*\)+\(.*\)$/\2/'`
        file_check=`echo $f | sed 's/+/\ /g' | wc -w`
        if [ ! -r $f ] && [ $file_check -eq 5 ]; then
                fail="y"
                file_check=0
                echo FAIL on $instance_name, result file $f could not be read
        fi
        if [ $file_check -eq 5 ]; then
                res=`sed -n '/3\.6\.16/,/\*\*\*\*\*/p' $f | grep -e 'fail' -e 'on' | grep  -v '3.6.16 sp_audit (fail only)' | awk '{print $2}'`
                echo " "
                echo Processing file $f
                if [ "$res" != "fail" ] && [ "$res" != "on" ] ; then
                        echo FAIL on $instance_name, sp_audit login, value is $res
                        fail="y"
                else
                        echo PASS on $instance_name, sp_audit login, value is $res
                        pass="y"
                fi
        fi
done
if [ "$pass" = "y" ] && [ "$fail" != "y" ] ; then
        echo TEST PASSED
fi
