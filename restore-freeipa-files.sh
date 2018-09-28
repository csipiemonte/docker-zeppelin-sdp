#!/bin/bash

if [ -n "$1" ] ; then
	if [ -d "$1" ] ; then
		sourceRootDir="$1"
	else
		echo "Directory $1 does not exists"
		exit 1
	fi
else
	sourceRootDir="/etc/security/keytabs/freeipa-backup"
fi


if [ -d "$sourceRootDir/etc" ]; then

	/bin/mv -f $sourceRootDir/etc/sssd/sssd.conf 		/etc/sssd/sssd.conf
	/bin/mv -f $sourceRootDir/etc/sysconfig/ntpd		/etc/sysconfig/
	/bin/mv -f $sourceRootDir/etc/ntp/step-tickers	/etc/ntp/step-tickers
	/bin/mv -f $sourceRootDir/etc/krb5.conf			/etc/krb5.conf
	/bin/mv -f $sourceRootDir/etc/ipa/ca.crt 			/etc/ipa/ca.crt
	/bin/mv -f $sourceRootDir/etc/ipa/default.conf 	/etc/ipa/default.conf
	/bin/mv -f $sourceRootDir/etc/openldap/ldap.conf 	/etc/openldap/ldap.conf
	/bin/mv -f $sourceRootDir/etc/pki/nssdb/* 		/etc/pki/nssdb
	/bin/mv -f $sourceRootDir/etc/krb5.keytab 		/etc/krb5.keytab

	cat $sourceRootDir/etc/hosts > /etc/hosts
	cat $sourceRootDir/etc/hostname > /etc/hostname
	cat $sourceRootDir/etc/hostname > /etc/hostname.ipa-client
	rm -f $sourceRootDir/etc/hostname
	rm -f $sourceRootDir/etc/hosts
fi