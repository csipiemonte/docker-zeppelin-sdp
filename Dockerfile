# Clone from the CentOS 7
FROM centos:centos7

MAINTAINER Luca Gioppo

ARG zeppelin_user=zeppelin_dock1
ENV env_zeppelin_user=$zeppelin_user

RUN yum swap -y -- remove fakesystemd -- install systemd systemd-libs && yum clean all

# Install FreeIPA client
RUN yum install -y ipa-client dbus-python perl 'perl(Data::Dumper)' 'perl(Time::HiRes)' && yum clean all

ADD dbus.service /etc/systemd/system/dbus.service
RUN ln -sf dbus.service /etc/systemd/system/messagebus.service

ADD systemctl /usr/bin/systemctl

RUN useradd -ms /bin/bash $env_zeppelin_user

#Install Oracle JVM
RUN java_version=8u172; \
    java_bnumber=11; \
    java_semver=1.8.0_172; \
    java_hash=429c3184b10d7af2bb5db3faf20b467566eb5bd95778f8339352c180c8ba48a1; \
    yum -y install wget \
    && wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" \
    http://download.oracle.com/otn-pub/java/jdk/$java_version-b$java_bnumber/a58eab1ec242421181065cdc37240b08/jdk-$java_version-linux-x64.tar.gz \
    && tar -zxvf jdk-$java_version-linux-x64.tar.gz -C /opt \
    && rm jdk-$java_version-linux-x64.tar.gz \
    && ln -sf /opt/jdk$java_semver/ /opt/jre-home \
    && alternatives --install /usr/bin/java java /opt/jdk$java_semver/jre/bin/java 20000 \
    && alternatives --install /usr/bin/jar jar /opt/jdk$java_semver/bin/jar 20000 \
    && alternatives --install /usr/bin/javac javac /opt/jdk$java_semver/bin/javac 20000 \
    && alternatives --install /usr/bin/javaws javaws /opt/jdk$java_semver/jre/bin/javaws 20000 \
    && alternatives --set java /opt/jdk$java_semver/jre/bin/java \
    && alternatives --set javaws /opt/jdk$java_semver/jre/bin/javaws \
    && alternatives --set javac /opt/jdk$java_semver/bin/javac \
    && alternatives --set jar /opt/jdk$java_semver/bin/jar \
    && java -version



RUN yum -y install unzip \
    && wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" \
    http://download.oracle.com/otn-pub/java/jce/8/jce_policy-8.zip \
    && echo "f3020a3922efd6626c2fff45695d527f34a8020e938a49292561f18ad1320b59  jce_policy-8.zip" | sha256sum -c - \
    && unzip -oj jce_policy-8.zip UnlimitedJCEPolicyJDK8/local_policy.jar -d /opt/jre-home/jre/lib/security/ \
    && unzip -oj jce_policy-8.zip UnlimitedJCEPolicyJDK8/US_export_policy.jar -d /opt/jre-home/jre/lib/security/ \
    && rm jce_policy-8.zip \
    && chmod -R 640 /opt/jre-home/jre/lib/security/ \
    && chown -R root:root /opt/jre-home/jre/lib/security/

RUN wget -nv -O /etc/yum.repos.d/hdp.repo http://public-repo-1.hortonworks.com/HDP/centos7/2.x/updates/2.6.0.3/hdp.repo \
    && yum install -y ambari-agent-2.5.0.3-7.x86_64 zeppelin_2_6_0_3_8-0.7.0.2.6.0.3-8.noarch \
    && chown -R $env_zeppelin_user:$env_zeppelin_user /etc/zeppelin/ \
    && chown -R $env_zeppelin_user:$env_zeppelin_user /var/lib/zeppelin/ \
    && chown -R $env_zeppelin_user:$env_zeppelin_user /var/run/zeppelin/ \
    && chown -R $env_zeppelin_user:$env_zeppelin_user /var/log/zeppelin/ \
#    && chown -R $env_zeppelin_user:$env_zeppelin_user /usr/hdp/2.6.0.3-8/zeppelin/webapps \
#    && chown -R $env_zeppelin_user:$env_zeppelin_user /usr/hdp/2.6.0.3-8/zeppelin/conf/interpreter.json \
    && chown -R $env_zeppelin_user:$env_zeppelin_user /usr/hdp/2.6.0.3-8/zeppelin/local-repo \
    && ls -lat /usr/hdp/2.6.0.3-8/zeppelin/interpreter/sh

ADD ipa-client-configure-first /usr/sbin/ipa-client-configure-first

RUN chmod -v +x /usr/bin/systemctl /usr/sbin/ipa-client-configure-first


ENTRYPOINT ["/usr/sbin/ipa-client-configure-first"]
