FROM pietrocannalire/centos-base:latest

MAINTAINER PC & OTHERS

# Add ipa-client-configure-first and ipa-client-stop then add permissions
ADD ipa-client-start /usr/sbin/ipa-client-start
ADD ipa-client-stop /usr/sbin/ipa-client-stop
ADD backup-freeipa-files.sh /usr/sbin/backup-freeipa-files.sh
ADD restore-freeipa-files.sh /usr/sbin/restore-freeipa-files.sh
ADD import-notebooks.sh  /var/lib/zeppelin/notebook
RUN chmod -v +x /usr/sbin/ipa-client-start /usr/sbin/ipa-client-stop /usr/sbin/backup-freeipa-files.sh /usr/sbin/restore-freeipa-files.sh /var/lib/zeppelin/notebook

# Add freeipa-install.service and enable it via systemctl
ADD freeipa-install.service /etc/systemd/system/freeipa-install.service
RUN systemctl enable freeipa-install.service

# The signal to send to systemd: graceful stop of daemons and running services
STOPSIGNAL SIGRTMIN+3

VOLUME ["/etc/security/keytabs"] 

CMD ["/usr/sbin/init"]