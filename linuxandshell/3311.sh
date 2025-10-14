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
                res=`sed -n '/3\.3\.11/,/\*\*\*\*\*/p' $f | grep -v '3.3.11 Remove, or lock any login ids created during install which are not required. For accounts which are locked, change the default passwords and use strong passwords.' | grep -v "*"`
                echo " "
                echo Procesing file $f
                if [ "$res" != "" ]; then
                        echo FAIL on $instance_name, found logins, value is $res
                        fail="y"
                else
                        echo PASS on $instance_name, found no logins, value is $res
                        pass="y"
                fi
        fi
done
if [ "$pass" = "y" ] && [ "$fail" != "y" ] ; then
        echo TEST PASSED
fi
