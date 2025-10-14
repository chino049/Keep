create or replace function	nc_drop_all_fkeys()
returns	integer
as
'
	----------------------------------------------------------------------
	--	Drop all Foreign Keys.
	----------------------------------------------------------------------
	declare
		l_count		integer := 0;
		l_record	record;
		l_sql_text	text;
	begin
		--------------------------------------------------------------
		--	Drop the Foreign Keys one by one.
		--------------------------------------------------------------
		for l_record in
			select		t.relname,
					c.conname
			from		pg_class	t,
					pg_constraint	c,
					pg_namespace	n
			where		c.conrelid	= t.oid
			and		t.relnamespace	= n.oid
			and		c.contype	= ''f''
			and		n.nspname	= ''public''

			order by	t.relname,
					c.conname
		loop

			l_sql_text := ''alter table ''
					|| l_record.relname
					|| '' drop constraint ''
					|| l_record.conname;

			execute l_sql_text;

			l_count := l_count + 1;
			
		end loop;

		--------------------------------------------------------------
		--	Return.
		--------------------------------------------------------------
		return l_count;
	end;
'
language 'plpgsql';


select nc_drop_all_fkeys();

drop    function        nc_drop_all_fkeys();


alter table	nc_acl
add constraint	foreign_key_01
foreign key	(iface_id)
references	nc_router_iface (iface_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_app_result_banner
add constraint	foreign_key_01
foreign key	(app_result_id)
references	nc_app_result_head (app_result_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_app_result_head
add constraint	fkey_nc_host
foreign key	(host_id)
references	nc_host (host_id)
on delete	cascade
on update	cascade;
alter table	nc_appliance_command
add constraint	fkey_nc_appliance
foreign key	(appliance_id)
references	nc_appliance (appliance_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_appliance_customer_spl
add constraint	foreign_key_01
foreign key	(appliance_id)
references	nc_appliance (appliance_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_appliance_iface
add constraint	foreign_key_01
foreign key	(appliance_id)
references	nc_appliance (appliance_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_appliance_ignore_profiler
add constraint	foreign_key_01
foreign key	(appliance_id)
references	nc_appliance (appliance_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_appliance_last_portscan
add constraint	foreign_key_01
foreign key	(appliance_id)
references	nc_appliance (appliance_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_appliance_last_portscan
add constraint	foreign_key_02
foreign key	(network_id)
references	nc_network (network_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_appliance_log
add constraint	foreign_key_01
foreign key	(customer_id)
references	nc_customer (customer_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_appliance_override_spl
add constraint	foreign_key_01
foreign key	(appliance_id)
references	nc_appliance (appliance_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_appliance_status
add constraint	foreign_key_01
foreign key	(appliance_id)
references	nc_appliance (appliance_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_appliance
add constraint	foreign_key_01
foreign key	(hardware_type_id)
references	nc_appliance_hardware_type (hardware_type_id)
on delete	restrict
on update	restrict
not deferrable
initially	immediate;
alter table	nc_appliance
add constraint	foreign_key_02
foreign key	(appliance_type_id)
references	nc_appliance_type (appliance_type_id)
on delete	restrict
on update	restrict
not deferrable
initially	immediate;
alter table	nc_application_group_apps
add constraint	foreign_key_01
foreign key	(application_group_id)
references	nc_application_group (application_group_id)
on delete	restrict
on update	restrict
not deferrable
initially	immediate;
alter table	nc_attack_ext_log
add constraint	foreign_key_01
foreign key	(efm_id)
references	nc_efm (efm_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_attack_ext_log
add constraint	foreign_key_05
foreign key	(ext_attack_class_id)
references	nc_ext_attack_class (ext_attack_class_id)
on delete	restrict
on update	restrict
not deferrable
initially	immediate;
alter table	nc_attack_ext_log
add constraint	foreign_key_02
foreign key	(ext_ids_id)
references	nc_ext_ids (ext_ids_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_attack_ext_log
add constraint	foreign_key_06
foreign key	(original_severity_id)
references	nc_ext_ids_severity (ext_ids_severity_id)
on delete	restrict
on update	restrict
not deferrable
initially	immediate;
alter table	nc_attack_ext_log
add constraint	foreign_key_07
foreign key	(modified_severity_id)
references	nc_ext_ids_severity (ext_ids_severity_id)
on delete	restrict
on update	restrict
not deferrable
initially	immediate;
alter table	nc_attack_ext_log
add constraint	foreign_key_04
foreign key	(target_host_id)
references	nc_host (host_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_attack_i18n
add constraint	fkey_nc_language
foreign key	(language_id)
references	nc_language (language_id)
on delete	cascade
on update	cascade;
ALTER TABLE	"nc_attack_log_detail"
ADD CONSTRAINT	"fkey_nc_attack_log_head"
FOREIGN KEY	("attack_log_id")
REFERENCES	"nc_attack_log_head" ("attack_log_id")
ON DELETE	cascade
ON UPDATE	cascade
NOT DEFERRABLE
INITIALLY	IMMEDIATE;
alter table	nc_audit_log
add constraint	fkey_nc_audit_component
foreign key	(audit_component_id)
references	nc_audit_component (audit_component_id)
on delete	restrict
on update	restrict
not deferrable
initially	immediate;

alter table	nc_audit_log
add constraint	fkey_nc_change_type
foreign key	(change_type_id)
references	nc_change_type (change_type_id)
on delete	restrict
on update	restrict
not deferrable
initially	immediate;

alter table	nc_audit_log
add constraint	fkey_nc_login
foreign key	(login_id)
references	nc_login (login_id)
on delete	restrict
on update	restrict
not deferrable
initially	immediate;
alter table	nc_audit_log_detail
add constraint	foreign_key_01
foreign key	(audit_log_id)
references	nc_audit_log (audit_log_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_audit_state
add constraint	foreign_key_01
foreign key	(audit_id)
references	nc_audit (audit_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_audit_stats
add constraint	foreign_key_01
foreign key	(audit_id)
references	nc_audit (audit_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_audit
add constraint	foreign_key_02
foreign key	(status_id)
references	nc_audit_status (status_id)
on delete	restrict
on update	restrict
not deferrable
initially	immediate;
alter table	nc_audit
add constraint	foreign_key_04
foreign key	(scan_profile_type_id)
references	nc_scan_profile_type (scan_profile_type_id)
on delete	restrict
on update	restrict
not deferrable
initially	immediate;
alter table	nc_audit
add constraint	foreign_key_03
foreign key	(scan_type_id)
references	nc_scan_type (scan_type_id)
on delete	restrict
on update	restrict
not deferrable
initially	immediate;
alter table	nc_auth_server
add constraint	foreign_key_01
foreign key	(server_type_id)
references	nc_auth_server_type (server_type_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_auth_server
add constraint	foreign_key_02
foreign key	(auth_type_id)
references	nc_auth_type (auth_type_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_component_appliance_type
add constraint	foreign_key_01
foreign key	(appliance_type_id)
references	nc_appliance_type (appliance_type_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_component_appliance_type
add constraint	foreign_key_02
foreign key	(component_id)
references	nc_component (component_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_core_menu
add constraint	foreign_key_01
foreign key	(menu_id)
references	nc_menu (menu_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_core_object_type
add constraint	foreign_key_01
foreign key	(object_type_id)
references	nc_object_type (object_type_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_correlation_set_item
add constraint	foreign_key_01
foreign key	(correlation_attribute_id)
references	nc_correlation_attribute (correlation_attribute_id)
on delete	restrict
on update	restrict
not deferrable
initially	immediate;
alter table	nc_correlation_set_item
add constraint	foreign_key_02
foreign key	(correlation_set_id)
references	nc_correlation_set (correlation_set_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_cred_network
add constraint	foreign_key_01
foreign key	(cred_id)
references	nc_cred (cred_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_cred_network
add constraint	foreign_key_02
foreign key	(network_id)
references	nc_network (network_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_cred_network_virtual_host
add constraint	foreign_key_01
foreign key	(cred_network_id)
references	nc_cred_network (cred_network_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_cred_network_virtual_host
add constraint	foreign_key_02
foreign key	(virtual_host_id)
references	nc_virtual_host (virtual_host_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_cred_prop_value
add constraint	foreign_key_01
foreign key	(cred_id)
references	nc_cred (cred_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_cred_prop_value
add constraint	foreign_key_02
foreign key	(cred_type_prop_name_id)
references	nc_cred_type_prop_name (cred_type_prop_name_id)
on delete	restrict
on update	restrict
not deferrable
initially	immediate;
alter table	nc_cred
add constraint	foreign_key_01
foreign key	(cred_type_id)
references	nc_cred_type (cred_type_id)
on delete	restrict
on update	restrict
not deferrable
initially	immediate;
alter table	nc_cred
add constraint	foreign_key_02
foreign key	(customer_id)
references	nc_customer (customer_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_cred_type_prop_name
add constraint	foreign_key_01
foreign key	(cred_type_id)
references	nc_cred_type (cred_type_id)
on delete	restrict
on update	restrict
not deferrable
initially	immediate;
alter table	nc_custom_vuln_application
add constraint	foreign_key_01
foreign key	(custom_vuln_id)
references	nc_customer_vuln (customer_vuln_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_customer
add constraint	fkey_nc_automated_export_type
foreign key	(automated_export_type_id)
references	nc_automated_export_type (automated_export_type_id)
on delete	restrict
on update	restrict
not deferrable
initially	immediate;
alter table	nc_customer_appliance
add constraint	foreign_key_01
foreign key	(appliance_id)
references	nc_appliance (appliance_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_customer_appliance
add constraint	foreign_key_02
foreign key	(customer_id)
references	nc_customer (customer_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_customer_correlation_set
add constraint	foreign_key_01
foreign key	(correlation_set_id)
references	nc_correlation_set (correlation_set_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_customer_correlation_set
add constraint	foreign_key_02
foreign key	(customer_id)
references	nc_customer (customer_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_customer_ext_ids
add constraint	foreign_key_01
foreign key	(customer_id)
references	nc_customer (customer_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_customer_ext_ids
add constraint	foreign_key_02
foreign key	(ext_ids_id)
references	nc_ext_ids (ext_ids_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_customer_menu
add constraint	foreign_key_01
foreign key	(customer_id)
references	nc_customer (customer_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_customer_menu
add constraint	foreign_key_02
foreign key	(menu_id)
references	nc_menu (menu_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_customer_object_type
add constraint	foreign_key_01
foreign key	(customer_id)
references	nc_customer (customer_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_customer_object_type
add constraint	foreign_key_02
foreign key	(object_type_id)
references	nc_object_type (object_type_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_customer_product_module
add constraint	foreign_key_01
foreign key	(customer_id)
references	nc_customer (customer_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_customer_product_module
add constraint	foreign_key_02
foreign key	(product_module_id)
references	nc_product_module (product_module_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_efm_ext_ids
add constraint	foreign_key_01
foreign key	(efm_id)
references	nc_efm (efm_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_efm_ext_ids
add constraint	foreign_key_02
foreign key	(ext_ids_id)
references	nc_ext_ids (ext_ids_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_efm_risk_customer_threshold
add constraint	foreign_key_01
foreign key	(customer_id)
references	nc_customer (customer_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_efm_risk_user_threshold
add constraint	foreign_key_01
foreign key	(login_id)
references	nc_login (login_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_efm
add constraint	foreign_key_01
foreign key	(efm_id)
references	nc_appliance (appliance_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
ALTER TABLE	nc_export_audit_attempted
ADD CONSTRAINT	foreign_key_01
FOREIGN KEY	(audit_id)
REFERENCES	nc_audit(audit_id)
ON UPDATE	CASCADE
ON DELETE	CASCADE;
ALTER TABLE	nc_export_audit_failed
ADD CONSTRAINT	foreign_key_01
FOREIGN KEY	(audit_id)
REFERENCES	nc_audit(audit_id)
ON UPDATE	CASCADE
ON DELETE	CASCADE;
ALTER TABLE	nc_export_audit_failed
ADD CONSTRAINT	foreign_key_02
FOREIGN KEY	(automated_export_type_id)
REFERENCES	nc_automated_export_type(automated_export_type_id)
ON UPDATE	RESTRICT
ON DELETE	RESTRICT;
ALTER TABLE	nc_export_audit_failed
ADD CONSTRAINT	foreign_key_03
FOREIGN KEY	(customer_id)
REFERENCES	nc_customer(customer_id)
ON UPDATE	CASCADE
ON DELETE	CASCADE;
ALTER TABLE	nc_export_stat
ADD CONSTRAINT	foreign_key_01
FOREIGN KEY	(export_task_id)
REFERENCES	nc_export_task(export_task_id)
ON UPDATE	RESTRICT
ON DELETE	RESTRICT;
alter table	nc_ext_ids_allowable_ip
add constraint	foreign_key_01
foreign key	(ext_ids_id)
references	nc_ext_ids (ext_ids_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_ext_ids_cisco
add constraint	foreign_key_01
foreign key	(ext_ids_id)
references	nc_ext_ids (ext_ids_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_ext_ids_cisco
add constraint	foreign_key_02
foreign key	(ext_ids_protocol_id)
references	nc_ext_ids_protocol (ext_ids_protocol_id)
on delete	restrict
on update	restrict
not deferrable
initially	immediate;
alter table	nc_ext_ids_severity
add constraint	foreign_key_01
foreign key	(attack_publisher_id)
references	nc_attack_publisher (attack_publisher_id)
on delete	restrict
on update	restrict
not deferrable
initially	immediate;
alter table	nc_ext_ids_stats
add constraint	foreign_key_02
foreign key	(ext_attack_class_id)
references	nc_ext_attack_class (ext_attack_class_id)
on delete	restrict
on update	restrict
not deferrable
initially	immediate;
alter table	nc_ext_ids_stats
add constraint	foreign_key_01
foreign key	(ext_ids_id)
references	nc_ext_ids (ext_ids_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_ext_ids_stats
add constraint	foreign_key_03
foreign key	(ext_ids_severity_id)
references	nc_ext_ids_severity (ext_ids_severity_id)
on delete	restrict
on update	restrict
not deferrable
initially	immediate;
alter table	nc_ext_ids_status
add constraint	foreign_key_01
foreign key	(ext_ids_id)
references	nc_ext_ids (ext_ids_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_ext_ids
add constraint	foreign_key_02
foreign key	(ext_ids_protocol_id)
references	nc_ext_ids_protocol (ext_ids_protocol_id)
on delete	restrict
on update	restrict
not deferrable
initially	immediate;
alter table	nc_ext_ids
add constraint	foreign_key_01
foreign key	(ext_ids_type_id)
references	nc_ext_ids_type (ext_ids_type_id)
on delete	restrict
on update	restrict
not deferrable
initially	immediate;
alter table	nc_found_rtr_iface
add constraint	foreign_key_04
foreign key	(customer_id)
references	nc_customer (customer_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_found_rtr_iface
add constraint	foreign_key_03
foreign key	(persistent_host_id)
references	nc_persistent_host (persistent_host_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_global_ip_exclude
add constraint	foreign_key_01
foreign key	(customer_id)
references	nc_customer (customer_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_help_mapping
add constraint	foreign_key_01
foreign key	(help_id)
references	nc_help (help_id)
on delete	restrict
on update	restrict
not deferrable
initially	immediate;
alter table	nc_hoporder
add constraint	foreign_key_02
foreign key	(hop_id)
references	nc_hop (hop_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_hoporder
add constraint	foreign_key_01
foreign key	(hoplist_id)
references	nc_hoplist (hoplist_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_host_alert
add constraint	foreign_key_01
foreign key	(network_id)
references	nc_network (network_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_host_alert
add constraint	foreign_key_02
foreign key	(transport_type_id)
references	nc_transport_type (transport_type_id)
on delete	restrict
on update	restrict
not deferrable
initially	immediate;
alter table	nc_host_datum
add constraint	foreign_key_01
foreign key	(host_id)
references	nc_host (host_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_host_persistent_host
add constraint	foreign_key_01
foreign key	(host_id)
references	nc_host (host_id)
on delete	cascade
on update	cascade
deferrable
initially	deferred;
alter table	nc_host_persistent_host
add constraint	foreign_key_02
foreign key	(persistent_host_id)
references	nc_persistent_host (persistent_host_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_host_ports
add constraint	fkey_nc_network
foreign key	(network_id)
references	nc_network (network_id)
on delete	cascade
on update	cascade;
alter table	nc_host_smb_share
add constraint	foreign_key_01
foreign key	(host_id)
references	nc_host (host_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_host
add constraint	foreign_key_01
foreign key	(audit_id)
references	nc_audit (audit_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_ids_attack_alerts
add constraint	foreign_key_01
foreign key	(network_id)
references	nc_network (network_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_ids_attack_alerts
add constraint	fkey_nc_transport_type
foreign key	(transport_type_id)
references	nc_transport_type (transport_type_id)
on delete	restrict
on update	restrict
not deferrable
initially	immediate;
alter table	nc_insecurity_zone_appliance_iface
add constraint	foreign_key_02
foreign key	(iface_id)
references	nc_appliance_iface (iface_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_insecurity_zone_appliance_iface
add constraint	foreign_key_01
foreign key	(insecurity_zone_id)
references	nc_insecurity_zone (insecurity_zone_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_insecurity_zone_group
add constraint	foreign_key_01
foreign key	(customer_id)
references	nc_customer (customer_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_insecurity_zone_group
add constraint	foreign_key_02
foreign key	(label_id)
references	nc_insecurity_coeff_label (label_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_insecurity_zone
add constraint	foreign_key_01
foreign key	(insecurity_zone_group_id)
references	nc_insecurity_zone_group (insecurity_zone_group_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_insecurity_zone_source_subnet
add constraint	foreign_key_01
foreign key	(insecurity_zone_id)
references	nc_insecurity_zone (insecurity_zone_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_insecurity_zone_source_subnet
add constraint	foreign_key_02
foreign key	(source_subnet_id)
references	nc_source_subnet (source_subnet_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table nc_ip_space 
add constraint foreign_key_01 foreign key (customer_id) 
references nc_customer (customer_id) 
on delete cascade on update cascade not deferrable initially immediate;
alter table nc_ip_space 
add constraint foreign_key_02 foreign key (login_id) 
references nc_login (login_id) 
on delete cascade on update cascade not deferrable initially immediate;

alter table	nc_jump_link_param
add constraint	foreign_key_01
foreign key	(jump_link_id)
references	nc_jump_link (jump_link_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_login_password
add constraint	fkey_nc_login
foreign key	(login_id)
references	nc_login (login_id)
on delete	cascade
on update	cascade;
alter table	nc_login
add constraint	foreign_key_01
foreign key	(skin_id)
references	nc_skin (skin_id)
on delete	restrict
on update	restrict
not deferrable
initially	immediate;
alter table	nc_los_mx
add constraint	foreign_key_01
foreign key	(analysis_id)
references	nc_topo_analysis (analysis_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_los_mx
add constraint	foreign_key_03
foreign key	(app_result_id)
references	nc_app_result_head (app_result_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_los_mx
add constraint	foreign_key_02
foreign key	(insecurity_zone_id)
references	nc_insecurity_zone (insecurity_zone_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_message_text
add constraint	foreign_key_01
foreign key	(language_id)
references	nc_language (language_id)
on delete	restrict
on update	restrict
not deferrable
initially	immediate;
alter table	nc_message_text
add constraint	foreign_key_02
foreign key	(message_id)
references	nc_message (message_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_motd
add constraint	fkey_nc_customer
foreign key	(customer_id)
references	nc_customer (customer_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_network_correlation_set
add constraint	foreign_key_01
foreign key	(correlation_set_id)
references	nc_correlation_set (correlation_set_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_network_correlation_set
add constraint	foreign_key_02
foreign key	(network_id)
references	nc_network (network_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_network_range
add constraint	foreign_key_01
foreign key	(network_id)
references	nc_network (network_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_network
add constraint	foreign_key_01
foreign key	(customer_id)
references	nc_customer (customer_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_object_type_menu
add constraint	foreign_key_01
foreign key	(menu_id)
references	nc_menu (menu_id)
on delete	restrict
on update	restrict
not deferrable
initially	immediate;
alter table	nc_object_type_menu
add constraint	foreign_key_02
foreign key	(object_type_id)
references	nc_object_type (object_type_id)
on delete	restrict
on update	restrict
not deferrable
initially	immediate;
alter table	nc_os_detect_request
add constraint	foreign_key_02
foreign key	(login_id)
references	nc_login (login_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_os_detect_request
add constraint	foreign_key_01
foreign key	(dp_id)
references	nc_appliance (appliance_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_os_detect_request
add constraint	foreign_key_03
foreign key	(network_id)
references	nc_network (network_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_os_group_os
add constraint	foreign_key_01
foreign key	(os_group_id)
references	nc_os_group (os_group_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_os_group
add constraint	foreign_key_01
foreign key	(customer_id)
references	nc_customer (customer_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_password
add constraint	fkey_nc_customer
foreign key	(customer_id)
references	nc_customer (customer_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_password_char_class
add constraint	fkey_nc_customer
foreign key	(customer_id)
references	nc_customer (customer_id)
on delete	cascade
on update	cascade;
alter table	nc_password_char_class
add constraint	fkey_nc_char_class
foreign key	(char_class_id)
references	nc_char_class (char_class_id)
on delete	cascade
on update	cascade;
alter table	nc_permission
add constraint	foreign_key_03
foreign key	(object_type_id)
references	nc_object_type (object_type_id)
on delete	restrict
on update	restrict
not deferrable
initially	immediate;
alter table	nc_permission
add constraint	foreign_key_02
foreign key	(permission_id)
references	nc_permission_lu (permission_id)
on delete	restrict
on update	restrict
not deferrable
initially	immediate;
alter table	nc_persistent_host_application
add constraint	foreign_key_01
foreign key	(persistent_host_id)
references	nc_persistent_host (persistent_host_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_persistent_host_vuln
add constraint	foreign_key_01
foreign key	(persistent_host_id)
references	nc_persistent_host (persistent_host_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_product_cve
add constraint	foreign_key_02
foreign key	(product_id)
references	nc_product (product_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table nc_queued_ext_ticket
add constraint fkey_nc_queued_ext_ticket2
foreign key ("host_id")
references "nc_host" ("host_id")
on delete cascade
on update cascade
not deferrable
initially immediate;
 alter table nc_queued_ext_ticket
add constraint fkey_nc_queued_ext_ticket3
foreign key ("condition_id")
references "nc_ext_ticket_condition_type" ("condition_id")
on delete cascade
on update cascade
not deferrable
initially immediate;
 alter table	nc_report_dp_do
add constraint	foreign_key_02 
foreign key	(report_display_obj_id)
references	nc_report_display_obj (report_display_obj_id)
on delete	restrict
on update	restrict
not deferrable
initially	immediate;

alter table	nc_report_dp_do
add constraint	foreign_key_01 
foreign key	(report_display_page_id)
references	nc_report_display_page (report_display_page_id)
on delete	restrict
on update	restrict
not deferrable
initially	immediate;
alter table	nc_report_filter_filter_type
add constraint	foreign_key_01
foreign key	(report_filter_id)
references	nc_report_filter (report_filter_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_report_filter_filter_type
add constraint	foreign_key_02
foreign key	(report_filter_type_id)
references	nc_report_filter_type (report_filter_type_id)
on delete	restrict
on update	restrict
not deferrable
initially	immediate;
alter table	nc_report_filter_viewer
add constraint	foreign_key_01 
foreign key	(report_filter_id)
references	nc_report_filter (report_filter_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_report_group_network
add constraint	foreign_key_02
foreign key	(network_id)
references	nc_network (network_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_report_group_network
add constraint	foreign_key_01
foreign key	(report_group_id)
references	nc_report_groups (report_group_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_report_name
add constraint	foreign_key_01
foreign key	(login_id)
references	nc_login (login_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_report_owner
add constraint	foreign_key_01
foreign key	(report_id)
references	nc_report (report_id)
on delete	restrict
on update	restrict
not deferrable
initially	immediate;
alter table	nc_report_report_dp
add constraint	foreign_key_01 
foreign key	(report_id)
references	nc_report (report_id)
on delete	restrict
on update	restrict
not deferrable
initially	immediate;
alter table	nc_report_report_dp
add constraint	foreign_key_02 
foreign key	(report_display_page_id)
references	nc_report_display_page (report_display_page_id)
on delete	restrict
on update	restrict
not deferrable
initially	immediate;
alter table	nc_report
add constraint	foreign_key_01
foreign key	(report_type_id)
references	nc_report_type (report_type_id)
on delete	restrict
on update	restrict
not deferrable
initially	immediate;
alter table	nc_report_viewer
add constraint	foreign_key_01 
foreign key	(report_id)
references	nc_report (report_id)
on delete	restrict
on update	restrict
not deferrable
initially	immediate;
alter table	nc_risk_class_risk
add constraint	foreign_key_01
foreign key	(risk_class_id)
references	nc_risk_class (risk_class_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_role_login
add constraint	foreign_key_01
foreign key	(login_id)
references	nc_login (login_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_role_login
add constraint	foreign_key_02
foreign key	(role_id)
references	nc_role (role_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_role
add constraint	foreign_key_01
foreign key	(customer_id)
references	nc_customer (customer_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_route
add constraint	foreign_key_01
foreign key	(router_id)
references	nc_router (router_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_router_iface
add constraint	foreign_key_01
foreign key	(router_id)
references	nc_router (router_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_scan_alert
add constraint	foreign_key_01
foreign key	(network_id)
references	nc_network (network_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_scan_alert
add constraint	foreign_key_02
foreign key	(scan_profile_id)
references	nc_scan_profile (scan_profile_id)
on delete	restrict
on update	restrict
not deferrable
initially	immediate;
alter table	nc_scan_alert
add constraint	foreign_key_03
foreign key	(transport_type_id)
references	nc_transport_type (transport_type_id)
on delete	restrict
on update	restrict
not deferrable
initially	immediate;
alter table	nc_scan_config_ext_ids
add constraint	foreign_key_01
foreign key	(ext_ids_id)
references	nc_ext_ids (ext_ids_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_scan_config_ext_ids
add constraint	foreign_key_03
foreign key	(scan_config_id)
references	nc_scan_config (scan_config_id)
on delete	restrict
on update	restrict
not deferrable
initially	immediate;
alter table	nc_scan_config_ext_ids_vms_drop
add constraint	foreign_key_03
foreign key	(ext_attack_class_id)
references	nc_ext_attack_class (ext_attack_class_id)
on delete	restrict
on update	restrict
not deferrable
initially	immediate;
alter table	nc_scan_config_ext_ids_vms_drop
add constraint	foreign_key_01
foreign key	(ext_ids_id)
references	nc_ext_ids (ext_ids_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_scan_config_ext_ids_vms_drop
add constraint	foreign_key_02
foreign key	(scan_config_id)
references	nc_scan_config (scan_config_id)
on delete	restrict
on update	restrict
not deferrable
initially	immediate;
alter table	nc_scan_config_ext_ids_vne_drop
add constraint	foreign_key_03
foreign key	(ext_attack_class_id)
references	nc_ext_attack_class (ext_attack_class_id)
on delete	restrict
on update	restrict
not deferrable
initially	immediate;
alter table	nc_scan_config_ext_ids_vne_drop
add constraint	foreign_key_01
foreign key	(ext_ids_id)
references	nc_ext_ids (ext_ids_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_scan_config_ext_ids_vne_drop
add constraint	foreign_key_02
foreign key	(scan_config_id)
references	nc_scan_config (scan_config_id)
on delete	restrict
on update	restrict
not deferrable
initially	immediate;
alter table	nc_scan_config_tm
add constraint	foreign_key_01
foreign key	(tm_id)
references	nc_appliance (appliance_id)
on delete	restrict
on update	restrict
not deferrable
initially	immediate;
alter table	nc_scan_config_tm
add constraint	foreign_key_02
foreign key	(scan_config_id)
references	nc_scan_config (scan_config_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_scan_config
add constraint	foreign_key_03
foreign key	(dp_id)
references	nc_appliance (appliance_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_scan_config
add constraint	foreign_key_02
foreign key	(network_id)
references	nc_network (network_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_scan_config
add constraint	foreign_key_01
foreign key	(scan_profile_id)
references	nc_scan_profile (scan_profile_id)
on delete	restrict
on update	restrict
not deferrable
initially	immediate;
alter table	nc_scan_profile_default
add constraint	foreign_key_01
foreign key	(scan_profile_type_id)
references	nc_scan_profile_type (scan_profile_type_id)
on delete	restrict
on update	restrict
not deferrable
initially	immediate;
alter table	nc_scan_profile_history
add constraint	foreign_key_01
foreign key	(scan_profile_id)
references	nc_scan_profile (scan_profile_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_scan_profile_history
add constraint	foreign_key_02
foreign key	(scan_profile_type_id)
references	nc_scan_profile_type (scan_profile_type_id)
on delete	restrict
on update	restrict
not deferrable
initially	immediate;
alter table	nc_scan_profile
add constraint	foreign_key_01
foreign key	(customer_id)
references	nc_customer (customer_id)
on delete	restrict
on update	restrict
not deferrable
initially	immediate;
alter table	nc_scan_profile
add constraint	foreign_key_02
foreign key	(scan_profile_type_id)
references	nc_scan_profile_type (scan_profile_type_id)
on delete	restrict
on update	restrict
not deferrable
initially	immediate;
alter table	nc_score_alert
add constraint	fkey_nc_transport_type
foreign key	(transport_type_id)
references	nc_transport_type (transport_type_id)
on delete	restrict
on update	restrict
not deferrable
initially	immediate;
alter table	nc_source_subnet
add constraint	foreign_key_01
foreign key	(router_id)
references	nc_router (router_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
ALTER TABLE	nc_sql_ds_column
ADD CONSTRAINT	foreign_key_01
FOREIGN KEY	(dataset_id)
REFERENCES	nc_sql_ds_dataset (id)
ON DELETE	cascade
ON UPDATE	cascade;
ALTER TABLE	nc_sql_ds_dataset_name
ADD CONSTRAINT	foreign_key_01
FOREIGN KEY	(dataset_id)
REFERENCES	nc_sql_ds_dataset (id)
ON DELETE	cascade
ON UPDATE	cascade;
--
-- The dataset names ALSO come out of the nc_sql_name table
--
ALTER TABLE	nc_sql_ds_dataset_name
ADD CONSTRAINT	foreign_key_02
FOREIGN KEY	(name_id)
REFERENCES	nc_sql_name (id)
ON DELETE	cascade
ON UPDATE	cascade;
alter table	nc_sql_macro_name
add constraint	fkey_nc_sql_macro_name_2
foreign key	(sql_name_id)
references	nc_sql_name (id)
on delete	cascade
on update	cascade;
--
-- Macros draw their names from the nc_sql_name table
--
ALTER TABLE	nc_sql_macro
ADD CONSTRAINT	foreign_key_01
FOREIGN KEY	(name_id)
REFERENCES	nc_sql_name (id)
ON DELETE	cascade
ON UPDATE	cascade;
alter table	nc_sql_name_repository
add constraint	fkey_nc_sql_name_1
foreign key	(sql_name_id)
references	nc_sql_name (id)
on delete	cascade
on update	cascade;
alter table	nc_sql_name_repository
add constraint	fkey_nc_sql_repository_1
foreign key	(sql_repository_id)
references	nc_sql_repository (id)
on delete	cascade
on update	cascade;
alter table	nc_sql_name_text
add constraint	fkey_nc_sql_name_2
foreign key	(sql_name_id)
references	nc_sql_name (id)
on delete	cascade
on update	cascade;
alter table	nc_sql_name_text
add constraint	fkey_nc_sql_text_1
foreign key	(sql_text_id)
references	nc_sql_text (id)
on delete	cascade
on update	cascade;
alter table	nc_sql_repository_dbms
add constraint	fkey_nc_sql_dbms_1
foreign key	(sql_dbms_id)
references	nc_sql_dbms (id)
on delete	cascade
on update	cascade;
alter table	nc_sql_repository_dbms
add constraint	fkey_nc_sql_repository_2
foreign key	(sql_repository_id)
references	nc_sql_repository (id)
on delete	cascade
on update	cascade;
alter table	nc_sql_text_dbms
add constraint	fkey_nc_sql_dbms_2
foreign key	(sql_dbms_id)
references	nc_sql_dbms (id)
on delete	cascade
on update	cascade;
alter table	nc_sql_text_dbms
add constraint	fkey_nc_sql_text_2
foreign key	(sql_text_id)
references	nc_sql_text (id)
on delete	cascade
on update	cascade;
alter table	nc_ssh_key
add constraint	foreign_key_01
foreign key	(customer_id)
references	nc_customer (customer_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table 	nc_system_license_client
add constraint 	foreign_key_01
foreign key 	(license_id)
references 	nc_system_license (license_id)
on delete 	cascade
on update 	cascade;
alter table 	nc_system_license_usage
add constraint 	foreign_key_01
foreign key 	(license_id)
references 	nc_system_license (license_id)
on delete 	cascade
on update 	cascade;
alter table	nc_tcp_pathlist
add constraint	foreign_key_02
foreign key	(app_result_id)
references	nc_app_result_head (app_result_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_tcp_pathlist
add constraint	foreign_key_01
foreign key	(iface_id)
references	nc_appliance_iface (iface_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_tcp_pathlist
add constraint	foreign_key_04
foreign key	(audit_id)
references	nc_audit (audit_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_ticket_attack
add constraint	foreign_key_01
foreign key	(ticket_id)
references	nc_ticket (ticket_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_ticket_audit
add constraint	foreign_key_01
foreign key	(login_id)
references	nc_login (login_id)
on delete	restrict
on update	restrict
not deferrable
initially	immediate;
alter table	nc_ticket_audit
add constraint	foreign_key_02
foreign key	(ticket_id)
references	nc_ticket (ticket_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_ticket_audit
add constraint	foreign_key_03
foreign key	(ticket_status_id)
references	nc_ticket_status (ticket_status_id)
on delete	restrict
on update	restrict
not deferrable
initially	immediate;
alter table	nc_ticket_auto_create
add constraint	foreign_key_01
foreign key	(customer_id)
references	nc_customer (customer_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_ticket_auto_verify_alert
add constraint	foreign_key_01
foreign key	(customer_id)
references	nc_customer (customer_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_ticket_customer_priority
add constraint	foreign_key_01
foreign key	(customer_id)
references	nc_customer (customer_id)
on delete	restrict
on update	restrict
not deferrable
initially	immediate;
alter table	nc_ticket_customer_priority
add constraint	foreign_key_02
foreign key	(ticket_priority_id)
references	nc_ticket_priority (ticket_priority_id)
on delete	restrict
on update	restrict
not deferrable
initially	immediate;
alter table	nc_ticket_customer_prop_lu
add constraint	foreign_key_01
foreign key	(customer_id)
references	nc_customer (customer_id)
on delete	restrict
on update	restrict
not deferrable
initially	immediate;
alter table	nc_ticket_customer_prop_lu
add constraint	foreign_key_02
foreign key	(prop_name_id)
references	nc_ticket_prop_name (prop_name_id)
on delete	restrict
on update	restrict
not deferrable
initially	immediate;
alter table	nc_ticket_customer_prop_lu
add constraint	foreign_key_03
foreign key	(prop_value_id)
references	nc_ticket_prop_value (prop_value_id)
on delete	restrict
on update	restrict
not deferrable
initially	immediate;
alter table	nc_ticket_customer_prop
add constraint	foreign_key_01
foreign key	(ticket_id)
references	nc_ticket (ticket_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_ticket_customer_prop
add constraint	foreign_key_02
foreign key	(customer_prop_id)
references	nc_ticket_customer_prop_lu (customer_prop_id)
on delete	restrict
on update	restrict
not deferrable
initially	immediate;
alter table	nc_ticket_default_assignee
add constraint	foreign_key_02
foreign key	(login_id)
references	nc_login (login_id)
on delete	restrict
on update	restrict
not deferrable
initially	immediate;
alter table	nc_ticket_default_assignee
add constraint	foreign_key_01
foreign key	(customer_id)
references	nc_ticket_auto_create (customer_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_ticket_default_priority
add constraint	foreign_key_01
foreign key	(customer_id)
references	nc_ticket_auto_create (customer_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_ticket_default_priority
add constraint	foreign_key_02
foreign key	(ticket_priority_id)
references	nc_ticket_priority (ticket_priority_id)
on delete	restrict
on update	restrict
not deferrable
initially	immediate;
alter table	nc_ticket_description
add constraint	foreign_key_01
foreign key	(ticket_id)
references	nc_ticket (ticket_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_ticket_host
add constraint	foreign_key_01
foreign key	(ticket_id)
references	nc_ticket (ticket_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_ticket_note
add constraint	foreign_key_01
foreign key	(login_id)
references	nc_login (login_id)
on delete	restrict
on update	restrict
not deferrable
initially	immediate;
alter table	nc_ticket_note
add constraint	foreign_key_02
foreign key	(ticket_id)
references	nc_ticket (ticket_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_ticket_open
add constraint	foreign_key_01
foreign key	(ticket_id)
references	nc_ticket (ticket_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_ticket_report
add constraint	foreign_key_01
foreign key	(login_id)
references	nc_login (login_id)
on delete	restrict
on update	restrict
not deferrable
initially	immediate;
alter table	nc_ticket_resolution_log
add constraint	foreign_key_01
foreign key	(ticket_id)
references	nc_ticket_resolution (ticket_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_ticket_resolution
add constraint	foreign_key_01
foreign key	(ticket_id)
references	nc_ticket (ticket_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_ticket_summary
add constraint	foreign_key_01
foreign key	(ticket_id)
references	nc_ticket (ticket_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_ticket
add constraint	foreign_key_01
foreign key	(customer_id)
references	nc_customer (customer_id)
on delete	restrict
on update	restrict
not deferrable
initially	immediate;
alter table	nc_ticket
add constraint	foreign_key_03
foreign key	(reporter_login_id)
references	nc_login (login_id)
on delete	restrict
on update	restrict
not deferrable
initially	immediate;
alter table	nc_ticket
add constraint	foreign_key_06
foreign key	(ticket_priority_id)
references	nc_ticket_priority (ticket_priority_id)
on delete	restrict
on update	restrict
not deferrable
initially	immediate;
alter table	nc_ticket
add constraint	foreign_key_07
foreign key	(ticket_status_id)
references	nc_ticket_status (ticket_status_id)
on delete	restrict
on update	restrict
not deferrable
initially	immediate;
alter table	nc_ticket
add constraint	foreign_key_08
foreign key	(ticket_type_id)
references	nc_ticket_type (ticket_type_id)
on delete	restrict
on update	restrict
not deferrable
initially	immediate;
alter table	nc_ticket_vuln_result
add constraint	foreign_key_01
foreign key	(ticket_id)
references	nc_ticket (ticket_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_topo_analysis
add constraint	foreign_key_01
foreign key	(network_id)
references	nc_network (network_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_topo_analysis
add constraint	foreign_key_02
foreign key	(status_id)
references	nc_audit_status (status_id)
on delete	restrict
on update	restrict
not deferrable
initially	immediate;
alter table	nc_topo_analysis
add constraint	foreign_key_03
foreign key	(topo_analysis_type_id)
references	nc_topo_analysis_type (topo_analysis_type_id)
on delete	restrict
on update	restrict
not deferrable
initially	immediate;
alter table	nc_topo_audit_analysis
add constraint	foreign_key_01
foreign key	(audit_id)
references	nc_audit (audit_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_topo_audit_analysis
add constraint	foreign_key_02
foreign key	(analysis_id)
references	nc_topo_analysis (analysis_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_topo_audit
add constraint	foreign_key_01
foreign key	(topo_audit_id)
references	nc_audit (audit_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_topo_audit
add constraint	foreign_key_02
foreign key	(vuln_audit_id)
references	nc_audit (audit_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_trouble_ignore
add constraint	foreign_key_01
foreign key	(component_id)
references	nc_component (component_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_trouble_ignore
add constraint	foreign_key_02
foreign key	(customer_id)
references	nc_customer (customer_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_trouble_ignore
add constraint	foreign_key_03
foreign key	(trouble_type_id)
references	nc_trouble_type (trouble_type_id)
on delete	restrict
on update	restrict
not deferrable
initially	immediate;
alter table	nc_trouble
add constraint	foreign_key_01
foreign key	(appliance_id)
references	nc_appliance (appliance_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_trouble
add constraint	foreign_key_02
foreign key	(component_id)
references	nc_component (component_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_trouble
add constraint	foreign_key_03
foreign key	(customer_id)
references	nc_customer (customer_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_trouble
add constraint	foreign_key_04
foreign key	(trouble_type_id)
references	nc_trouble_type (trouble_type_id)
on delete	restrict
on update	restrict
not deferrable
initially	immediate;
alter table	nc_ui_plugin_api_mapping
add constraint	foreign_key_02
foreign key	(product_module_id)
references	nc_product_module (product_module_id)
on delete	restrict
on update	restrict
not deferrable
initially	immediate;
alter table	nc_ui_plugin_api_mapping
add constraint	foreign_key_03
foreign key	(mapping_id)
references	nc_ui_api_mapping (mapping_id)
on delete	restrict
on update	restrict
not deferrable
initially	immediate;
alter table	nc_upgrade_package_dependency
add constraint	foreign_key_01
foreign key	(package_id)
references	nc_upgrade_package (package_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_upgrade_package
add constraint	foreign_key_01
foreign key	(software_class_id)
references	nc_software_class_lookup (software_class_id)
on delete	restrict
on update	restrict
not deferrable
initially	immediate;
alter table	nc_user_group_login
add constraint	foreign_key_01
foreign key	(login_id)
references	nc_login (login_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_user_group_login
add constraint	foreign_key_02
foreign key	(user_group_id)
references	nc_user_group (user_group_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_user_group_poc
add constraint	foreign_key_02
foreign key	(login_id)
references	nc_login (login_id)
on delete	restrict
on update	restrict
not deferrable
initially	immediate;
alter table	nc_user_group_poc
add constraint	foreign_key_01
foreign key	(user_group_id)
references	nc_user_group (user_group_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_user_group
add constraint	foreign_key_01
foreign key	(customer_id)
references	nc_customer (customer_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_user_ids_attack_alerts
add constraint	fkey_nc_login
foreign key	(login_id)
references	nc_login (login_id)
on delete	cascade
on update	cascade;
alter table	nc_user_ids_attack_alerts
add constraint	fkey_nc_network
foreign key	(network_id)
references	nc_network (network_id)
on delete	cascade
on update	cascade;
alter table	nc_user_ids_attack_alerts
add constraint	fkey_nc_transport_type
foreign key	(transport_type_id)
references	nc_transport_type (transport_type_id)
on delete	restrict
on update	restrict;
alter table	nc_user_login_alert
add constraint	fkey_nc_login
foreign key	(login_id)
references	nc_login (login_id)
on delete	cascade
on update	cascade;
alter table	nc_user_login_alert
add constraint	fkey_nc_network
foreign key	(network_id)
references	nc_network (network_id)
on delete	cascade
on update	cascade;
alter table	nc_user_login_alert
add constraint	fkey_nc_transport_type
foreign key	(transport_type_id)
references	nc_transport_type (transport_type_id)
on delete	restrict
on update	restrict;
alter table	nc_user_login_vuln_alert
add constraint	fkey_nc_login
foreign key	(login_id)
references	nc_login (login_id)
on delete	cascade
on update	cascade;
alter table	nc_user_login_vuln_alert
add constraint	fkey_nc_network
foreign key	(network_id)
references	nc_network (network_id)
on delete	cascade
on update	cascade;
alter table	nc_user_login_vuln_alert
add constraint	fkey_nc_transport_type
foreign key	(transport_type_id)
references	nc_transport_type (transport_type_id)
on delete	restrict
on update	restrict;
alter table	nc_user_menu
add constraint	foreign_key_01
foreign key	(login_id)
references	nc_login (login_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_user_menu
add constraint	foreign_key_02
foreign key	(menu_id)
references	nc_menu (menu_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_user_report_param
add constraint	foreign_key_01
foreign key	(user_report_id)
references	nc_user_report (user_report_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_user_report
add constraint	foreign_key_01
foreign key	(login_id)
references	nc_login (login_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_user_report_viewer
add constraint	foreign_key_01
foreign key	(user_report_id)
references	nc_user_report (user_report_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table nc_verification_result
add constraint fkey_nc_verification_result
foreign key ("condition_id")
references "nc_ext_ticket_condition_type" ("condition_id")
on delete cascade
on update cascade
not deferrable
initially immediate;
 alter table nc_verification_result
add constraint fkey_nc_verification_result2
foreign key ("result")
references "nc_verification_result_type" ("result_id")
on delete cascade
on update cascade
not deferrable
initially immediate;
 alter table nc_verification_result
add constraint fkey_nc_verification_result3
foreign key ("host_id")
references "nc_host" ("host_id")
on delete cascade
on update cascade
not deferrable
initially immediate;
 alter table	nc_version
add constraint	foreign_key_01
foreign key	(software_class_id)
references	nc_software_class_lookup (software_class_id)
on delete	restrict
on update	restrict
not deferrable
initially	immediate;
alter table	nc_virtual_host
add constraint	foreign_key_01
foreign key	(network_id)
references	nc_network(network_id)
on delete	cascade
on update	cascade
initially	immediate;
alter table	nc_vuln_alert
add constraint	foreign_key_01
foreign key	(network_id)
references	nc_network (network_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_vuln_alert
add constraint	fkey_nc_transport_type
foreign key	(transport_type_id)
references	nc_transport_type (transport_type_id)
on delete	restrict
on update	restrict
not deferrable
initially	immediate;
alter table	nc_vuln_audit_analysis
add constraint	foreign_key_01
foreign key	(audit_id)
references	nc_audit (audit_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_vuln_audit_analysis
add constraint	foreign_key_02
foreign key	(analysis_id)
references	nc_topo_analysis (analysis_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_vuln_i18n
add constraint	fkey_nc_language
foreign key	(language_id)
references	nc_language (language_id)
on delete	cascade
on update	cascade;
ALTER TABLE	"nc_vuln_result_packet"
ADD CONSTRAINT	"fkey_nc_vuln_result_packet"
FOREIGN KEY	("vuln_result_id")
REFERENCES	"nc_vuln_result_head" ("vuln_result_id")
ON DELETE	cascade
ON UPDATE	cascade
NOT DEFERRABLE
INITIALLY	IMMEDIATE;
alter table	nc_vuln_result_head
add constraint	foreign_key_01
foreign key	(audit_id)
references	nc_audit (audit_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_zone_network
add constraint	foreign_key_02
foreign key	(network_id)
references	nc_network (network_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_zone_network
add constraint	foreign_key_01
foreign key	(zone_id)
references	nc_zone (zone_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
alter table	nc_zone
add constraint	foreign_key_01
foreign key	(customer_id)
references	nc_customer (customer_id)
on delete	cascade
on update	cascade
not deferrable
initially	immediate;
