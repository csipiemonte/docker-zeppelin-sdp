#!/bin/bash

rootDir=/tmp

if [ -d "$rootDir/etc" ]; then

	/bin/mv -f $rootDir/etc/sssd/sssd.conf 		/etc/sssd/sssd.conf
	/bin/mv -f $rootDir/etc/sysconfig/ntpd		/etc/sysconfig/
	/bin/mv -f $rootDir/etc/ntp/step-tickers	/etc/ntp/step-tickers
	/bin/mv -f $rootDir/etc/krb5.conf			/etc/krb5.conf
	/bin/mv -f $rootDir/etc/ipa/ca.crt 			/etc/ipa/ca.crt
	/bin/mv -f $rootDir/etc/ipa/default.conf 	/etc/ipa/default.conf
	/bin/mv -f $rootDir/etc/openldap/ldap.conf 	/etc/openldap/ldap.conf
	/bin/mv -f $rootDir/etc/pki/nssdb/* 		/etc/pki/nssdb
	/bin/mv -f $rootDir/etc/krb5.keytab 		/etc/krb5.keytab

	cat $rootDir/etc/hosts > /etc/hosts
	cat $rootDir/etc/hostname > /etc/hostname
	cat $rootDir/etc/hostname > /etc/hostname.ipa-client
	rm -f $rootDir/etc/hostname
	rm -f $rootDir/etc/hosts
fi