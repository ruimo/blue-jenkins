#!/bin/sh

export JENKINS_HOME=/var/_jenkins
export COPY_REFERENCE_FILE_LOG=$JENKINS_HOME/copy_reference_file.log
JENKINS_VOLUME=/var/jenkins_home

adduser jenkins root
chmod 775 $JENKINS_VOLUME
su -c "mkdir -p $JENKINS_VOLUME/backup" jenkins
ln -sf $JENKINS_VOLUME/backup /var/jenkins_backup
deluser jenkins root
chmod 755 $JENKINS_VOLUME

su -c "rsync -av $JENKINS_VOLUME/backup/_jenkins /var" jenkins

su -c jenkins.sh jenkins
