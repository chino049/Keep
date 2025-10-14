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
                resOper=`sed -n '/3\.6\.4/,/\*\*\*\*\*/p' $f | grep 'oper_role' | grep  -v '3.6.4 sp_audit' | awk '{print $2}'`
                resSa=`sed -n '/3\.6\.4/,/\*\*\*\*\*/p' $f | grep 'sa_role' | grep  -v '3.6.4 sp_audit' | awk '{print $2}'`
                resSso=`sed -n '/3\.6\.4/,/\*\*\*\*\*/p' $f | grep 'sso_role' | grep  -v '3.6.4 sp_audit' | awk '{print $2}'`
                echo " "
                echo Processing file $f
                if [ "$resOper" != "on" ]; then
                        echo FAIL on $instance_name, audit is not on for oper_role, value is $resOper
                        fail="y"
                else
                        echo PASS on $instance_name, audit is on for oper_role, value is $resOper
                        pass="y"
                fi

                if [ "$resSa" != "on" ]; then
                        echo FAIL on $instance_name, audit is not on for sa_role, value is $resSa
                        fail="y"
                else
                        echo PASS on $instance_name, audit is on for sa_role, value is $resSa
                        pass="y"
                fi

                if [ "$resSso" != "on" ]; then
                        echo FAIL on $instance_name, audit is not on for sso_role, value is $resSso
                        fail="y"
                else
                        echo PASS on $instance_name, audit is on for sso_role, value is $resSso
                        pass="y"
                fi
        fi
done
if [ "$pass" = "y" ] && [ "$fail" != "y" ] ; then
        echo TEST PASSED
fi
