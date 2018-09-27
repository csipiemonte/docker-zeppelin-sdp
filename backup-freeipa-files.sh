#!/bin/bash

rootDir=/tmp

mkdir -p /tmp/etc/sssd
mkdir -p /tmp/etc/ipa
mkdir -p /tmp/etc/openldap
mkdir -p /tmp/etc/pki/nssdb
mkdir -p /tmp/etc/sysconfig
mkdir -p /tmp/etc/sysconfig/network
mkdir -p /tmp/etc/ntp

cp -f /etc/sssd/sssd.conf		$rootDir/etc/sssd/sssd.conf
#cp -f /etc/ntp.conf            $rootDir/etc/ntp.conf
cp -f /etc/sysconfig/ntpd       $rootDir/etc/sysconfig/
cp -f /etc/ntp/step-tickers     $rootDir/etc/ntp/step-tickers
cp -f /etc/krb5.conf            $rootDir/etc/krb5.conf
cp -f /etc/ipa/ca.crt           $rootDir/etc/ipa/ca.crt
cp -f /etc/ipa/default.conf     $rootDir/etc/ipa/default.conf
cp -f /etc/openldap/ldap.conf   $rootDir/etc/openldap/ldap.conf
cp -f /etc/pki/nssdb/*          $rootDir/etc/pki/nssdb
cp -f /etc/krb5.keytab          $rootDir/etc/krb5.keytab

cp -f /etc/hosts                $rootDir/etc/hosts
cp -f /etc/hostname             $rootDir/etc/hostname
cp -f /etc/hostname             $rootDir/etc/hostname.ipa-client




