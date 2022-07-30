#!/usr/bin/env bash



# If you enable this, data will be written to the file you specify. The
# amount of data written is controlled by the "loglevel" parameter.
#
# If enabled, rsnapshot will write a lockfile to prevent two instances
# from running simultaneously (and messing up the snapshot_root).
# If you enable this, make sure the lockfile directory is not world
# writable. Otherwise anyone can prevent the program from running.
#
mkdir -p /home/randomstore/backup/$target
chmod 777  /home/randomstore/backup/$target
chmod 777 -R /home/randomstore/backup/log/
mkdir -p /home/randomstore/backup/log


echo $src
echo $target 
echo cp /usr/rsnapshot/rsnapshot.conf /tmp/rs.conf
cp /usr/rsnapshot/rsnapshot.conf /tmp/rs.conf
echo "lockfile	/home/randomstore/backup/rsnapshot-$(echo $target | sed -e s,/,-,g).pid" >>  /tmp/rs.conf
echo "logfile	/home/randomstore/backup/log/rsnapshot-$(echo $target | sed -e s,/,-,g)" >>  /tmp/rs.conf
echo "snapshot_root	/home/randomstore/backup/$target" >>  /tmp/rs.conf
echo "backup	$src	$target"	 
echo "backup	$src	$target"	>>  /tmp/rs.conf
echo ----------
echo  START RSNAPSHOT $UNIT - $src $target
echo ----------
rsnapshot -c /tmp/rs.conf $UNIT
