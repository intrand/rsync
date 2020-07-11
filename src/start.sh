#!/bin/sh -e

if [ -z "${root_password}" ]; then # random root password if not defined
	root_password=$(apg -n 1 -m 23 -x 63 -M LNC -a 1);
	printf "\n\n---------------------------------------------\n";
	printf "root password is: ${root_password}\n";
	printf "---------------------------------------------\n\n";
fi;

if [ -z "${sshd_banner}" ]; then # default sshd_banner if not defined
	sshd_banner="Your root password has been randomly generated. Please check stdout.\n";
fi;

printf "${sshd_motd}" > /etc/motd; # fill motd
printf "${sshd_banner}" > /etc/banner; # fill banner

sed -iE 's|^.*PermitRootLogin.*$||g; s|^.*Banner.*$||g;' /etc/ssh/sshd_config;
printf "PermitRootLogin yes\nBanner /etc/banner\n" | tee -a /etc/ssh/sshd_config;

printf "root:${root_password}\n" | chpasswd;

ssh-keygen -A;
/usr/sbin/sshd -De ${@};
exit ${?}; # exit however sshd exited
