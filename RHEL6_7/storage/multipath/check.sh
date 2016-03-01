#!/bin/bash

. /usr/share/preupgrade/common.sh

#END GENERATED SECTION

OLD_MULTIPATH_RULES=/lib/udev/rules.d/40-multipath.rules
MULTIPATH_CONF=/etc/multipath.conf
ERR=0
FIX=0

mkdir -p $VALUE_TMP_PREUPGRADE/postupgrade.d/multipath
cp -R postupgrade.d/* $VALUE_TMP_PREUPGRADE/postupgrade.d/multipath

if [ -e "$OLD_MULTIPATH_RULES" ]; then
	log_warning "Multipath's udev rules file has moved in RHEL7. The old file, $OLD_MULTIPATH_RULES must be removed"
	FIX=1
fi	
 
if [ -f "$MULTIPATH_CONF" ]; then
	if grep -q "getuid_callout" $MULTIPATH_CONF ; then
		log_medium_risk "Multipath no longer uses the getuid_callout config option"
		ERR=1
	fi
	if grep -q "devices[[:space:]]*{" $MULTIPATH_CONF; then
		log_high_risk "Multipath matches user device configs with builtin deivces configs differently on RHEL7."
		FIX=1
	fi
fi
log_medium_risk "a number of default configuation settings have changed in RHEL7. Users should verify that their devices are still optimally configured"

test "$ERR" -ne 0 && exit $RESULT_FAIL
test "$FIX" -ne 0 && exit $RESULT_FIXED
exit $RESULT_PASS
