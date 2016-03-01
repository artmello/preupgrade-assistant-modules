#!/bin/bash



. /usr/share/preupgrade/common.sh
check_applies_to "squid"
check_rpm_to "" ""
COMPONENT="squid"
#END GENERATED SECTION

if [ ! -f /etc/squid/squid.conf ] ; then
    exit $RESULT_NOT_APPLICABLE;
fi

# This check can be used if you need root privilegues
check_root

# Copy your config file from RHEL6 (in case of scenario RHEL6_7) 
# to Temporary Directory
CONFIG_FILE="/etc/squid/squid.conf"

mkdir -p $VALUE_TMP_PREUPGRADE/cleanconf/$(dirname $CONFIG_FILE)
cp $CONFIG_FILE $VALUE_TMP_PREUPGRADE/cleanconf/$CONFIG_FILE


# Now check your configuration file for options
# and for other stuff related with configuration

# If configuration can be used on target system (like RHEL7 in case of RHEL6_7)
# the exit should be RESULT_PASS

# If configuration can not be used on target system (like RHEL 7 in case of RHEL6_7)
# scenario then result should be RESULT_FAILED. Correction of 
# configuration file is provided either by solution script
# or by postupgrade script located in $VALUE_TMP_PREUPGRADE/postupgrade.d/

# if configuration file can be fixed then fix them in temporary directory
# $VALUE_TMP_PREUPGRADE/$CONFIG_FILE and result should be RESULT_FIXED
# More information about this issues should be described in solution.txt file
# as reference to KnowledgeBase article.

# postupgrade.d directory from your content is automatically copied by
# preupgrade assistant into $VALUE_TMP_PREUPGRADE/postupgrade.d/ directory

#workaround to openscap buggy missing PATH
export PATH=$PATH:/usr/bin
ret=$RESULT_INFORMATIONAL

grep -q "^[[:space:]]*dns_v4_fallback" $CONFIG_FILE
if [ $? -ne 0 ]; then
    echo "\
* squid now uses DNS parallel lookups as a replacement for dns_v4_fallback option. 
  This option will be therefore removed from your squid.conf.
" >> $SOLUTION_FILE

    log_slight_risk "dns_v4_fallback option will be erased"
    sed -i -e '/^\([[:space:]]*\)dns_v4_fallback/d' $VALUE_TMP_PREUPGRADE/cleanconf/$CONFIG_FILE
    
fi


grep -i "^[[:space:]]*emulate_httpd_log" $CONFIG_FILE
if [ $? -eq 0 ]; then
    echo "\
* emulate_httpd_log option is replaced by common format option on an access_log directive.
  Modify your access_log directive manually if you want to preserve behavior of emulate_httpd_log option.
  This option will be removed from your squid.conf.
" >> $SOLUTION_FILE
    
    log_slight_risk "emulate_httpd_log option will be erased"
    sed -i '/^[[:space:]]*emulate_httpd_log/d' $VALUE_TMP_PREUPGRADE/cleanconf/$CONFIG_FILE 
    ret=$RESULT_FAIL
fi


grep -q "^[[:space:]]*forward_log" $CONFIG_FILE
if [ $? -ne 0 ]; then
    echo "\
* forward_log option is now obsolete and will be removed from your squid.conf.
" >> $SOLUTION_FILE

    log_slight_risk "forward_log option will be erased"
    sed -i -e '/^\([[:space:]]*\)forward_log/d' $VALUE_TMP_PREUPGRADE/cleanconf/$CONFIG_FILE
fi

K
grep -q "^[[:space:]]*ftp_list_width" $CONFIG_FILE
if [ $? -ne 0 ]; then
    echo "\
* ftp_list_width option is now obsolete and will be removed from your squid.conf.
" >> $SOLUTION_FILE

    log_slight_risk "ftp_list_width option will be erased"
    sed -i -e '/^\([[:space:]]*\)ftp_list_width/d' $VALUE_TMP_PREUPGRADE/cleanconf/$CONFIG_FILE
fi


grep -i "^[[:space:]]*log_fqdn" $CONFIG_FILE
if [ $? -eq 0 ]; then
    echo "\
* log_fqdn option is replaced by automatic detection of the %>A logformat tag.
Modify your logformat directive manually if you want to preserve behavior of log_fqdn option.
This option will be removed from your squid.conf.
" >> $SOLUTION_FILE

    log_slight_risk "log_fqdn option will be erased"
    sed -i '/^[[:space:]]log_fqdn/d' $VALUE_TMP_PREUPGRADE/cleanconf/$CONFIG_FILE
    ret=$RESULT_FAIL
fi 


grep -i "^[[:space:]]*log_ip_on_direct" $CONFIG_FILE
if [ $? -eq 0 ]; then
    echo "\
* log_ip_on_direct option is replaced by automatic detection of the %<A logformat tag.
Modify your logformat directive manually if you want to preserve behavior of log_ip_on_direct option.
This option will be removed from your squid.conf.
" >> $SOLUTION_FILE

    log_slight_risk "log_ip_on_direct option will be erased"
    sed -i '/^[[:space:]]log_ip_on_direct/d' $VALUE_TMP_PREUPGRADE/cleanconf/$CONFIG_FILE
    ret=$RESULT_FAIL
fi 


grep -i "^[[:space:]]*maximum_single_addr_tries" $CONFIG_FILE
if [ $? -eq 0 ]; then
    echo "\
* maximum_single_addr_tries option is replaced by connect_retries option which operates a little differently.
Modify your squid.conf manually if you want to preserve old behavior.
This option will be removed from your squid.conf.
" >> $SOLUTION_FILE

    log_slight_risk "maximum_single_addr_tries option will be erased"
    sed -i '/^[[:space:]]maximum_single_addr_tries/d' $VALUE_TMP_PREUPGRADE/cleanconf/$CONFIG_FILE
    ret=$RESULT_FAIL
fi 


grep -i "^[[:space:]]*pconn_timeout" $CONFIG_FILE
if [ $? -eq 0 ]; then
    echo "\
* pconn_timeout option is replaced by the server_idle_pconn_timeout.
This option will be therefore modified into newly introduced server_idle_pconn_timeout.
" >> $SOLUTION_FILE
    
    log_slight_risk "pconn_timeout will be modified"
    sed -i 's/^\([[:space:]]*\)pconn_timeout/\1server_idle_pconn_timeout/' $VALUE_TMP_PREUPGRADE/cleanconf/$CONFIG_FILE
fi 

grep -i "^[[:space:]]*persistent_request_timeout" $CONFIG_FILE
if [ $? -eq 0 ]; then
    echo "\
* persistent_request_timeout option is replaced by the client_idle_pconn_timeout. 
This option will be therefore modified into newly introduced client_idle_pconn_timeout.
" >> $SOLUTION_FILE
    
    log_slight_risk "persistent_request_timeout"
    sed -i 's/^\([[:space:]]*\)persistent_request_timeout/\1client_idle_pconn_timeout/' $VALUE_TMP_PREUPGRADE/cleanconf/$CONFIG_FILE 
fi 

grep -i "^[[:space:]]*referr\?er_log" $CONFIG_FILE
if [ $? -eq 0 ]; then
    echo "\
* referer_log option is replaced by referrer format option on an access_log directive.
  Modify your access_log directive manually if you want to preserve behavior of referer option.
  This option will be removed from your squid.conf.
" >> $SOLUTION_FILE

    log_slight_risk "referer_log option will be erased"
    sed -i '/^[[:space:]]*referr\?er_log/d' $VALUE_TMP_PREUPGRADE/cleanconf/$CONFIG_FILE
    ret=$RESULT_FAIL
fi 

grep -i "^[[:space:]]*url_rewrite_concurrency" $CONFIG_FILE
if [ $? -eq 0 ]; then
    echo "\
* url_rewrite_concurrency option is now replaced by url_rewrite_children concurrency.
  This option will be modified into newly introduced url_rewrite_children concurrency.
" >> $SOLUTION_FILE
    
    log_slight_risk "url_rewrite_concurrency option will be modified"
    sed -i 's/^\([[:space:]]*\)url_rewrite_concurrency/\1url_rewrite_children concurrency/' $VALUE_TMP_PREUPGRADE/cleanconf/$CONFIG_FILE

fi 

grep -i "^[[:space:]]*useragent_log" $CONFIG_FILE
if [ $? -eq 0 ]; then
    echo "\
* useragent_log option is replaced by useragent format option on an access_log directive.
  Modify your access_log directive manually if you want to preserve behavior of useragent_log option.
  This option will be removed from your squid.conf.
" >> $SOLUTION_FILE

    log_slight_risk "useragent_log option will be erased"
    sed -i '/^[[:space:]]*useragent_log/d' $VALUE_TMP_PREUPGRADE/cleanconf/$CONFIG_FILE
    ret=$RESULT_FAIL
fi 


exit $ret
