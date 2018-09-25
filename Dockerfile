FROM pietrocannalire/centos-base:latest

MAINTAINER PC & OTHERS

# Add ipa-client-configure-first and add permissions
ADD ipa-client-start /usr/sbin/ipa-client-start
RUN chmod -v +x /usr/sbin/ipa-client-start

# Add ipa-client-stop and add permissions
ADD ipa-client-stop /usr/sbin/ipa-client-stop
RUN chmod -v +x /usr/sbin/ipa-client-stop

# Add freeipa-install.service and enable it via systemctl
ADD freeipa-install.service /etc/systemd/system/freeipa-install.service
RUN systemctl enable freeipa-install.service

VOLUME ["/sys/fs/cgroup"]

VOLUME ["/etc/security/keytabs"] 

CMD ["/usr/sbin/init"]