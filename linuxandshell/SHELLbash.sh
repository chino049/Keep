4.0# for FILE in $(find / -nogroup -print) ; do chgrp wheel $FILE; done
4.0# for FILE in $(find / -nouser -print ) ; do chown root $FILE ; done
4.0# for FILE in $(find / -nogroup -print); do chgrp wheel $FILE; done

