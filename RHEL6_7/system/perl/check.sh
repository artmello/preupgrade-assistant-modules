#!/bin/bash


. /usr/share/preupgrade/common.sh

#END GENERATED SECTION

FOREIGN_FOUND=0
function log_file() {
        printf '%s\n' "$@" >> "$SOLUTION_FILE" || exit_error
        FOREIGN_FOUND=1
}

cat > "$SOLUTION_FILE" <<'EOM'
Perl was updated from version 5.10 to version 5.16. Please read Perl
section in the Red Hat Enterprise Linux 7 Developer Guide for more details.

Following Perl module files located in system Perl paths are either not
handled by any package or not signed by Red Hat:

EOM

PERL_DIRS=$(perl -MConfig -e '$,=q{ }; print @Config{installarchlib,installprivlib,installvendorarch,installvendorlib}') \
    || exit_error
for file in $(find -P $PERL_DIRS -type f -name '*.pm'); do
    RPM=$(rpm -qf "$file")
    if [ $? -ne 0 ]; then
        log_slight_risk "The perl module $file is not handled by any package."
        log_file "$file"
        continue
    fi
    RPM_NAME=$(rpm -q --qf '%{NAME}' "$RPM")
    is_dist_native "$RPM_NAME"
    if [ $? -ne 0 ]; then
        log_slight_risk "The perl module $file was not installed by any Red Hat-signed package."
        log_file "$file"
    fi
done

test "$FOREIGN_FOUND" = 0 && exit_informational || exit_fail
