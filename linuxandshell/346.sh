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
                res=`sed -n '/3\.4\.6/,/\*\*\*\*\*/p' $f | grep 'minimum password length' | grep  -v '3.4.6 sp_configure minimum password length' | awk '{print $7}'`
                echo " "
                echo Processing file $f
                if [ "$res" -le 7 ]; then
                        echo FAIL on $instance_name, minimum password length, value is $res
                        fail="y"
                else
                        echo PASS on $instance_name, minimum password length, value is $res
                        pass="y"
                fi
        fi
done
if [ "$pass" = "y" ] && [ "$fail" != "y" ] ; then
        echo TEST PASSED
fi
