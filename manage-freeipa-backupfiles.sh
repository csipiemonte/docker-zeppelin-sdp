#!/bin/bash

if [ -z "$1" ] ; then
	echo "Usage: manage-freeipa-backupfiles.sh [ backup [dest-dir] | restore [source-dir] | delete [dir] ]"
	exit 1
fi

case "$1" in

	"backup" )
	
		echo "Backup current FreeIPA client config"
		
		if [ -n "$1" ] ; then
			destRootDir="$1"
		else
			destRootDir="/etc/security/freeipa-backups"
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

	;;
	
	"restore" )
	
		echo "Restoring previous FreeIPA client config"

		if [ -n "$1" ] ; then
			if [ -d "$1" ] ; then
				sourceRootDir="$1"
			else
				echo "Directory $1 does not exists"
				exit 1
			fi
		else
			sourceRootDir="/etc/security/freeipa-backups"
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
		
	;;
	
	"delete" )
		echo "Deleting previous FreeIPA client config: related host does not exist anymore on current ipaserver"
		
		if [ -n "$1" ] ; then
			targetDir="$1"
		else
			targetDir="/etc/security/freeipa-backups"
		fi

		if [ -d $targetDir/etc ] ; then
			rm -rf $targetDir/etc
		fi
		
	;;
	
esac