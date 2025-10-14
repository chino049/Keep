insert into nc_appliance_log values (nextval('nc_appliance_log_seq'),0,'reindex',0,'Database',0,now(),'Reindex did not complete with the allowed time ','f',-1);
insert into nc_trouble values (nextval('nc_trouble_seq') ,3,NULL,2,1,now(),NULL,'Reindex did not complete with the allowed time',now(),'Reindex');

