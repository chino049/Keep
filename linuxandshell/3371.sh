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
                res=`sed -n '/3\.3\.7-1/,/\*\*\*\*\*/p' $f | grep sybsecurity | grep  -v '3.3.7-1 Install auditing database sybsecurity :' | xargs`
                echo " "
                echo Processing file $f
                if [ "$res" != "sybsecurity" ]; then
                        echo FAIL on $instance_name, sybsecurity is not installed, value is $res
                        fail="y"
                else
                        echo PASS on $instance_name, sybsecurity is installed, value is $res
                        pass="y"
                fi
        fi
done
if [ "$pass" = "y" ] && [ "$fail" != "y" ] ; then
        echo TEST PASSED
fi
