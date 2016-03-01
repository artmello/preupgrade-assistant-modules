#!/bin/bash


. /usr/share/preupgrade/common.sh

#END GENERATED SECTION

FOUND=0
SITE_LIB_DIR="/usr/lib/ruby/site_ruby/*/*"
GEM_DIR="/usr/lib/ruby/gems/*/gems/*"
RUBY_DIRS="$SITE_LIB_DIR $GEM_DIR"

for rb_dir_or_file in `find -P $RUBY_DIRS -maxdepth 0 -type d && find -P $SITE_LIB_DIR -maxdepth 0 -type f`
do
  RPM=`rpm -qf $rb_dir_or_file`
  if [ $? -ne 0 ]; then
    log_slight_risk "$rb_dir_or_file is not owned by any RPM package."
    FOUND=1
    continue
  fi
  RPM_NAME=`rpm -q --qf "%{NAME}" $RPM`
  is_dist_native "$RPM_NAME"
  if [ $? -ne 0 ]; then
    log_slight_risk "$rb_dir_or_file is owned by an RPM package that was not signed by Red Hat."
    FOUND=1
  fi
done
if [ $FOUND -eq 1 ]; then
  exit_fail
fi

exit_pass
