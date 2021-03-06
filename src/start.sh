#!/bin/sh
if [ -z "${sshd_config_readonly}" ]; then
	sshd_config_readonly="false";
fi;

if [ -z "${root_password}" ]; then # random root password if not defined
	root_password="$(apg -n 1 -m 23 -x 63 -M LNC -a 1)";
	printf "\n\n---------------------------------------------\n";
	printf "root password is: ${root_password}\n";
	printf "---------------------------------------------\n\n";
fi;

if [ -z "${sshd_banner}" ]; then # default sshd_banner if not defined
	sshd_banner="Your root password has been randomly generated. Please check stdout.\n";
fi;

printf "${sshd_motd}" > /etc/motd; # fill motd
printf "${sshd_banner}" > /etc/banner; # fill banner

if [ "${sshd_config_readonly}" == "false" ]; then
	sed -iE 's|^.*PermitRootLogin.*$||g; s|^.*Banner.*$||g;' /etc/ssh/sshd_config;
	printf "PermitRootLogin yes\nBanner /etc/banner\n" | tee -a /etc/ssh/sshd_config;
	ssh-keygen -A;
fi;

printf "root:${root_password}\n" | chpasswd;

mkdir -p ~root/.ssh;
chown -R root:root ~root/.ssh;
find ~root/.ssh -type d -exec chmod 700 {} +;
find ~root/.ssh -type f -exec chmod 600 {} +;

/usr/sbin/sshd -De ${@};
exit ${?}; # exit however sshd exited
