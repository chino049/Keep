for r in . ; do du $r; done
for FILE in $(find / -nogroup -print); do ls -l  $FILE; done
for FILE in $(find / -name "ic\*" -print); do ls -l  $FILE; done
for r in {1..10}; do echo $r  ; done
fn=`ls `; for f in $fn ;  do cd $f; git status ; git diff ; cd ..; done

fn=`ls `; for f in $fn; do echo $f; cd $f; git status ; cd ..; done


