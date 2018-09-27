FROM pietrocannalire/centos-base:latest

MAINTAINER PC & OTHERS

# Add ipa-client-configure-first and ipa-client-stop then add permissions
ADD ipa-client-start /usr/sbin/ipa-client-start
ADD ipa-client-stop /usr/sbin/ipa-client-stop
ADD backup-freeipa-files.sh /usr/sbin/backup-freeipa-files.sh
ADD restore-freeipa-files.sh /usr/sbin/restore-freeipa-files.sh
RUN chmod -v +x /usr/sbin/ipa-client-start /usr/sbin/ipa-client-stop /usr/sbin/backup-freeipa-files.sh /usr/sbin/restore-freeipa-files.sh

# Add freeipa-install.service and enable it via systemctl
ADD freeipa-install.service /etc/systemd/system/freeipa-install.service
RUN systemctl enable freeipa-install.service

VOLUME ["/etc/security/keytabs"] 

CMD ["/usr/sbin/init"]