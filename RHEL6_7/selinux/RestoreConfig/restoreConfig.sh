#! /usr/bin/env bash

. /usr/share/preupgrade/common.sh
check_applies_to "policycoreutils-python"

#END GENERATED SECTION

# This check can be used if you need root privilegues
check_root

SEMANAGE_EXPORT_FILE=semanage_export

RESULT=$RESULT_PASS

semanage -o "$SEMANAGE_EXPORT_FILE"

TARGET_DIR="${POSTUPGRADE_DIR}/selinux"
TARGET_SCRIPT_NAME="01-restoreConfig.sh"

if test -s "$SEMANAGE_EXPORT_FILE"; then
	mkdir -p ${TARGET_DIR}
	mv "$SEMANAGE_EXPORT_FILE" ${TARGET_DIR}
	cp postupgrade.d/restoreConfig.sh ${TARGET_DIR}/${TARGET_SCRIPT_NAME}
	chmod a+x ${TARGET_DIR}/${TARGET_SCRIPT_NAME}
	RESULT="$RESULT_FIXED"
	log_none_risk "Custom selinux configuration has been saved and it will be restored by a postupgrade script after the system upgrade."
fi

exit $RESULT
