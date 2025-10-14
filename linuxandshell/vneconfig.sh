#!/bin/sh
# ehoffmann, bhall
#
# Grab "configuration" table info as well as relevant system files and stuff
# them into a tarball that can be restored from on a fresh system.

LOG=0
LOGFILE=vneconfigdump.log

INSTALL=0
CREATE=0

CONFIGDIR=vneconfig

TS=`date +'%Y%m%d_%H%M%S'`
TARFNAME=vneconfigdump-$TS.tgz
TARFNAME_SPECIFIED=0

usage()
{
	echo -e "This script will run pg_dump on select tables which constitute \"configuration\" tables"
	echo -e ""
	echo -e "usage: $0 [-l] [-f filename] <-c | -i>"
	echo -e "	-c	Create the configuration dump tarball"
	echo -e "	-f	Specify the name of the tarball to restore"
	echo -e "	-i	Restore (install) from an already created tarball"
	echo -e "	-l	Log output to $LOGFILE"
	echo -e ""
	echo -e "After running this script with -c, scp $TARFNAME to the VnE, extract it, and run $0 -i"
	echo -e "This assumes there is a \"fresh\" dbice install."
}

get_ip360_version() {
	IP360VER=`echo "select ip360_version from nc_version;" | /hive/vendor/pgsql/bin/psql -d ice -U postgres -P format='unaligned' -P tuples_only`
}

log()
{
	TS=`date +'%Y%m%d_%H%M%S'`
	if [ $LOG -eq 1 ]; then
		echo "[$TS] $@" >> $LOGFILE
	fi
	echo "$@"
}

if [ "X$1" = "X" ]; then
	usage
	exit 1
fi

while getopts "cf:hil" opt
do
	case X$opt in
		Xc)
			CREATE=1
			INSTALL=0
			;;
		Xh)
			usage
			exit 0
			;;
		Xf)
			TARFNAME="$OPTARG"
			TARFNAME_SPECIFIED=1
			;;
		Xi)
			INSTALL=1
			CREATE=0
			;;
		Xl)
			LOG=1
			;;
		*)
			usage
			exit 1
			;;
	esac
done


if [ $INSTALL -eq 1 ]; then
	CONFIGDIR=`dirname $0`
fi
FNAME=$CONFIGDIR/vneconfigdump.sql

if [ $CREATE -eq 1 ]; then
	log "Creating $TARFNAME"
	# delete any existing .sql files unless we're installing

	if [ -f "$FNAME" ]; then
		rm -f $FNAME
	fi
	if [ -f "$TARFNAME" ]; then
		rm -f $TARFNAME
	fi
fi

# TODO: include these tables?
# nc_user_permission_all

############################
# Mapping of tablename:sequence (provided the sequence exists)
tables="
nc_appliance:nc_appliance_seq
nc_appliance_config:nc_appliance_config_seq
nc_appliance_customer_spl:
nc_appliance_dns:nc_appliance_dns_seq
nc_appliance_iface:nc_iface_id_seq
nc_appliance_iface_del:
nc_appliance_last_portscan:
nc_appliance_override_spl:
nc_appliance_status:
nc_archive_config:nc_archive_config_seq
nc_archive_cutoff:
nc_auth_server:nc_auth_server_seq
nc_authentication_key:
nc_auto_export:
nc_backup_config:nc_backup_config_seq
nc_certificate:nc_certificate_id_seq
nc_console:nc_console_arp_seq
nc_console_arp:nc_console_arp_seq
nc_console_config:nc_console_config_seq
nc_console_route:nc_console_route_seq
nc_contact_info:
nc_core_object_type:
nc_cred:nc_cred_seq
nc_cred_network:nc_cred_network_seq
nc_cred_network_virtual_host:nc_cred_network_virtual_host_seq
nc_cred_prop_value:nc_cred_prop_value_seq
nc_customer:nc_customer_customer_id_seq
nc_customer_appliance:
nc_customer_correlation_set:
nc_customer_ext_ids:
nc_customer_menu:
nc_customer_object_type:
nc_customer_os:nc_customer_os_seq
nc_customer_product_module:
nc_module:nc_module_seq
nc_customer_rule:nc_customer_rule_seq
nc_customer_score:nc_customer_score_seq
nc_customer_vuln:nc_customer_vuln_seq
nc_custom_vuln_application:
nc_database_config:nc_database_config_seq
nc_dns:nc_dns_seq
nc_efm:nc_efm_seq
nc_efm_ext_ids:
nc_efm_risk_customer_threshold:
nc_efm_risk_user_threshold:
nc_external_dbms:
nc_external_user:nc_external_user_seq
nc_focus_config:
nc_focus_index_location:
nc_focus_index_set:
nc_global_ip_exclude:nc_global_ip_exclude_seq
nc_insecurity_zone:nc_insecurity_zone_id_seq
nc_insecurity_zone_appliance_iface:
nc_insecurity_zone_appliance_iface_del:
nc_insecurity_zone_del:
nc_insecurity_zone_group:nc_insecurity_zone_group_id_seq
nc_insecurity_zone_group_del:
nc_insecurity_zone_source_subnet:
nc_insecurity_zone_source_subnet_del:
nc_ip_space:nc_ip_space_seq
nc_ldaprep_config:nc_ldaprep_config_seq
nc_logfiles_config:nc_logfiles_config_seq
nc_login:nc_login_login_id_seq
nc_login_password:nc_login_password_seq
nc_message:nc_message_seq
nc_message_text:
nc_motd:
nc_network:nc_network_seq
nc_network_correlation_set:
nc_network_correlation_set_log:
nc_network_range:nc_network_range_seq
nc_ntp:nc_ntp_seq
nc_object_type:
nc_os_group:nc_os_group_seq
nc_os_group_default:
nc_os_group_os:
nc_os_group_os_default:
nc_password:
nc_password_char_class:
nc_permission:
nc_permission_lu:
nc_poet_config:nc_poet_config_seq
nc_pre_auth_message:
nc_report_custom_elements:nc_report_custom_elements_seq
nc_report_custom_elements_viewer:
nc_report_filter:nc_report_filter_seq
nc_report_filter_filter_type:
nc_report_filter_type:
nc_report_filter_viewer:
nc_report_group_network:
nc_report_group_users:
nc_report_groups:nc_report_groups_seq
nc_report_name:nc_report_name_seq
nc_report_owner:
nc_report_viewer:
nc_role:nc_login_login_id_seq
nc_role_login:
nc_scan_alert:nc_scan_alert_seq
nc_scan_config:nc_scan_config_seq
nc_scan_profile:nc_scan_profile_seq
nc_scan_profile_default:
nc_scan_profile_history:
nc_score_alert:nc_score_alert_seq
nc_snmp_nms:nc_snmp_nms_seq
nc_snmp_trap:
nc_software_repository:nc_software_repository_seq
nc_ssh_key:nc_ssh_key_seq
nc_standby_config:nc_standby_config_seq
nc_topo_config:nc_topo_config_seq
nc_topo_config_host:
nc_topo_config_host_del:
nc_upgrade_client:nc_upgrade_client_seq
nc_user_group:nc_login_login_id_seq
nc_user_group_login:
nc_user_group_poc:
nc_user_login_alert:nc_user_login_alert_seq
nc_user_login_vuln_alert:nc_user_login_vuln_alert_seq
nc_user_menu:
nc_user_permission_all:
nc_virtual_host:nc_virtual_host_id_seq
nc_vuln_alert:nc_vuln_alert_seq
nc_zone:nc_zone_seq
nc_zone_descendant_temp:nc_zone_descendant_temp_seq
nc_zone_network:"

# Create a directory to store the dump files
DUMPDIR=$CONFIGDIR/pgdump_files
if [ $CREATE -eq 1 ]; then
	if [ -d $CONFIGDIR ]; then
		rm -rf $CONFIGDIR
	fi
	mkdir $CONFIGDIR
	if [ -d $DUMPDIR ]; then
		rm -rf $DUMPDIR
	fi
	mkdir $DUMPDIR
fi

get_ip360_version

#
#  Install from tarball
#
if [ $INSTALL -eq 1 ]; then

	# Make sure the tarfile exists
	if [ $TARFNAME_SPECIFIED -eq 1 ]; then
		echo "Using tar file: $TARFNAME"
		if [ ! -f $TARFNAME ]; then
			echo "Unable to find: $TARFNAME"
			exit 1
		fi
		tar -zxvf $TARFNAME
		cd vneconfig
	fi

	if [ ! -f $CONFIGDIR/version ]; then
		echo "Unable to find \"version\" file.  Cannot continue."
		exit 1
	fi

	CONFIGVER=`cat $CONFIGDIR/version`
	if [ "X$CONFIGVER" != "X$IP360VER" ]; then
		log "ERROR: IP360 verisons do not match (current: $IP360VER, config: $CONFIGVER)"
		exit 1
	fi

	if [ ! -f $FNAME ]; then
		log "ERROR: No SQL data file ($FNAME) found."
		exit 1
	fi

	if [ -s $FNAME ]; then
		cat $FNAME | su postgres -c psql >> $LOGFILE
	fi
	for f in $DUMPDIR/*.sql; do
		log "Restoring $f"
		/hive/vendor/pgsql/bin/pg_restore --disable-triggers -a -d ice -U postgres -c $f 2>&1 >> $LOGFILE
	done

	# Restore files
	if [ -f $CONFIGDIR/files.tgz ]; then
		tar -zxv -P -C / -f $CONFIGDIR/files.tgz
	fi

	log "Restore completed.  Please review $LOGFILE."

	exit 0
fi

#
# Dump the relevant tables and create the package
#
if [ $CREATE -eq 1 ]; then

	# Create a version file
	echo $IP360VER > $CONFIGDIR/version

	# Gather all of the table data
	for elem in $tables
	do
		table=`echo $elem | cut -d: -f1`
		table_seq=`echo $elem | cut -d: -f2`

		log "Dumping table: $table"
		if [ "X$table_seq" != "X" ]; then
			log "- (with sequence: $table_seq)"
		fi
 
		# When we restore we need to truncate each table
		echo "TRUNCATE TABLE $table CASCADE;" >> $FNAME

		TRV=0
		SRV=0

		EXTRA=""
		if [ "$table" = "nc_customer" ]; then
			EXTRA="--disable-triggers"
		fi
		/hive/vendor/pgsql/bin/pg_dump -U postgres -d ice $EXTRA -a -D -t $table -F c -f $DUMPDIR/${table}.sql
		TRV=$?
		if [ "x$table_seq" != "x" ]; then
			/hive/vendor/pgsql/bin/pg_dump -U postgres -d ice $EXTRA -a -D -t $table_seq -F c -f $DUMPDIR/${table_seq}.sql
			SRV=$?
		fi
		if [ $TRV -ne 0 -o $SRV -ne 0 ]; then
			log "Failed to dump table: $table (sequence: $table_seq)"
			exit 1
		fi

	done

	# Make sure we include the install script too
	cp $0 $CONFIGDIR/`basename $0`

	# Gather other relevant files
	log "Gathering custom files"
	TARFLIST=""
	FLIST="/hive/ui/IP360/public/skins/default/images /root/.ssh /home/support/.ssh /sql/console /sql/downloads"
	# only add stuff which exists.
	for f in $FLIST; do
		if [ -f $f -o -d $f ]; then
			TARFLIST="$TARFLIST $f"
		fi
	done
	tar -zvcf $CONFIGDIR/files.tgz $TARFLIST

	# Create the actual tar
	tar -zcf $TARFNAME $CONFIGDIR
	result=`echo $?`

	if [ "$result" -eq 0 ]; then
		log "Successfully created $TARFNAME"
		log "All done."
		exit 0
	else
		log "Did not create $TARFNAME -- Returned: $result"
		exit 1
	fi
fi

log "All done"
exit 0
