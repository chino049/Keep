#!/usr/bin/sh 

LP=`nmap localhost `
awk -F":" '{ print "username: " $1 "\t\tuid:" $3 }' /etc/passwd
nmap localhost | awk '/ssh/ {print $0}' 
nmap localhost | awk '{ if ($0 in 'ssh') print $0}' 
#nmap localhost | awk '{if ($0 > 22) print "Found 22" }' 
nmap localhost | awk '/^22/ {print $1}' 
cat /etc/resolv.conf   | awk '{c=split($0, s); for(n=1; n<=c; ++n) print s[n] }' $1
uname -a | awk '{if (NR != 0)  print "the nr is " $NR}'
df | awk '{print; if (NF != 0) print ""}' -



#awk '{print $3}' FOREIGN.sql | /hive/vendor/bin/perl -p -e ' s/$/.sql >> sss /; s/^/cat /;'


set time = 12:34:56
set hr = `echo $time | awk '{split($0,a,":"); print a[1]}'` # = 12
set sec = `echo $time | awk '{split($0,a,":"); print a[3]}'` # = 56

echo "base-2-364,nonpci-2-364,spider-2-341,web-2-341" | awk '{split($0,aa,","); print  aa[1] ; print aa[3] }'

awk '{ print "File " $0  }' /etc/passwd  

awk '/jordonez/ { print $0}' /etc/passwd

awk '$0 ~ /jordonez/ { print $0}' /etc/passwd
 
awk '$0 ~ /^dae/ { print $0}' /etc/passwd
awk '$0 ~ /^dae/ ' /etc/passwd
awk '$0 ~ /^dae/ { print $1}' /etc/passwd
echo "creaker"
awk '$0 ~ /[^emon/ ' /etc/passwd

awk -F: '$4 == 0 {print $1}'  /etc/passwd
#to get GID of 0 and print the first field only

to print the fourth field from
auditing        0           0            0            0         switch               dynamic
awk -F " " '{print $4}'


