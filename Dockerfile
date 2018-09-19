FROM pietrocannalire/centos-base:latest

MAINTAINER PC & OTHERS

#ENV http_proxy http://proxy-srv.csi.it:3128
#ENV https_proxy  http://proxy-srv.csi.it:3128

#ARG container_hostname=zeppelin_docker_hostname 
#ENV env_container_hostname=$container_hostname
RUN /bin/hostname pietrozep6.pochdp.csi.it

# Add ipa-client-configure-first and add permissions
ADD ipa-client-configure-first /usr/sbin/ipa-client-configure-first
RUN chmod -v +x /usr/sbin/ipa-client-configure-first

# Add freeipa-install.service and enable it via systemctl
ADD freeipa-install.service /etc/systemd/system/freeipa-install.service
RUN systemctl enable freeipa-install.service

VOLUME ["/sys/fs/cgroup"]

VOLUME ["/etc/security/keytabs"] 

CMD ["/usr/sbin/init"]