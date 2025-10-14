insert into nc_appliance_log values (nextval('nc_appliance_log_seq'),0,'data integrity',0,'Database',0,now(),'Found traces of data inconsistency or misalignment','f',-1);
insert into nc_trouble values (nextval('nc_trouble_seq') ,3,NULL,2,1,now(),NULL,'Found traces of data inconsistency or misalignment ',now(),'Data Integrity');
