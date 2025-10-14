insert into nc_appliance_log values (nextval('nc_appliance_log_seq'),0,'vacuum',0,'Database',0,now(),'Vacuum did not complete with the allowed time ','f',-1);
insert into nc_trouble values (nextval('nc_trouble_seq') ,3,NULL,2,1,now(),NULL,'Vaccum did not complete with the allowed time',now(),'vacuum');

