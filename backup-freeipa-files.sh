#!/bin/bash

#default: /etc/security/keytabs/freeipa-backup

if [ -n "$1" ] ; then
	destRootDir="$1"
else
	destRootDir="/etc/security/keytabs/freeipa-backup"
fi

if [ ! -d $destRootDir ] ; then
	mkdir -p $destRootDir
fi

mkdir -p $destRootDir/etc/sssd
mkdir -p $destRootDir/etc/ipa
mkdir -p $destRootDir/etc/openldap
mkdir -p $destRootDir/etc/pki/nssdb
mkdir -p $destRootDir/etc/sysconfig
mkdir -p $destRootDir/etc/sysconfig/network
mkdir -p $destRootDir/etc/ntp

cp -f /etc/sssd/sssd.conf		$destRootDir/etc/sssd/sssd.conf
#cp -f /etc/ntp.conf            $destRootDir/etc/ntp.conf
cp -f /etc/sysconfig/ntpd       $destRootDir/etc/sysconfig/
cp -f /etc/ntp/step-tickers     $destRootDir/etc/ntp/step-tickers
cp -f /etc/krb5.conf            $destRootDir/etc/krb5.conf
cp -f /etc/ipa/ca.crt           $destRootDir/etc/ipa/ca.crt
cp -f /etc/ipa/default.conf     $destRootDir/etc/ipa/default.conf
cp -f /etc/openldap/ldap.conf   $destRootDir/etc/openldap/ldap.conf
cp -f /etc/pki/nssdb/*          $destRootDir/etc/pki/nssdb
cp -f /etc/krb5.keytab          $destRootDir/etc/krb5.keytab

cp -f /etc/hosts                $destRootDir/etc/hosts
cp -f /etc/hostname             $destRootDir/etc/hostname
cp -f /etc/hostname             $destRootDir/etc/hostname.ipa-client




