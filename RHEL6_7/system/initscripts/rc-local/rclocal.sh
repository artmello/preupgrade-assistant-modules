#!/bin/bash

. /usr/share/preupgrade/common.sh
check_applies_to "initscripts"

#END GENERATED SECTION

RC_LOCAL="/etc/rc.d/rc.local"

COMPONENT="initscripts"

if [ ! -f $VALUE_CONFIGCHANGED ]; then
    log_error "Missing generic part $VALUE_CONFIGCHANGED"
fi

grep $RC_LOCAL $VALUE_CONFIGCHANGED > /dev/null 2>&1
if [ $? -eq 0 ]; then
    log_high_risk "File $RC_LOCAL was changed"
    exit_fail
fi
exit_pass
