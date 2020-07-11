#!/bin/sh
if [ -z "${root_password}" ]; then
	root_password=$(apg -n 1 -m 23 -x 63 -M LNC -a 1);
	printf "\n\n---------------------------------------------\n";
	printf "root password is: ${root_password}\n";
	printf "---------------------------------------------\n\n";
fi;
printf "${sshd_motd}" > /etc/motd;
printf "${sshd_banner}" > /etc/banner;
printf "root:${root_password}\n" | chpasswd && \
sed -iE 's|^.*PermitRootLogin.*$||g; s|^.*Banner.*$||g;' /etc/ssh/sshd_config && \
printf "PermitRootLogin yes\nBanner /etc/banner\n" | tee -a /etc/ssh/sshd_config && \
ssh-keygen -A && \
/usr/sbin/sshd -De ${@};
exit ${?};
