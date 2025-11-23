for file in *.csv  
	do 
		echo $file
		/usr/bin/python3 /home/jordonez/bitbucket/pandas/ingest_V6.py /home/jordonez/bitbucket/misc/PASAY/ingest/$file	
	done	

