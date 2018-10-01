#!/bin/bash

if [ -z "$1" ] ; then
	echo "Usage: manage-notebook.sh [import|backup [dest-dir]|restore [source-dir]]"
	exit 1
fi

case "$1" in

	"import" )
	rootNotebookDir=/var/lib/zeppelin/notebook

	FILES=$rootNotebookDir/*.json
	for file in $FILES
	do
			echo "file: $file"
			if [ -n "$file" ] ; then
					id=$(jq '.id' $file | tr -d \")
					echo "id: $id"
					mkdir $rootNotebookDir/$id
					cp $file $rootNotebookDir/$id/note.json
			fi
	done
	;;
	
	"backup" )
	echo "Backup Zeppelin notebooks"

	if [ -n "$2" ] ; then
		destRootDir="$2"
	else
		destRootDir="/var/lib/zeppelin/notebook/backups"
	fi

	sourceRootDir=/var/lib/zeppelin/notebook

	if [ ! -d $destRootDir ] ; then
		mkdir -p $destRootDir
	else
		rm -rf $destRootDir/*
	fi

	cp -r -d $sourceRootDir $destRootDir
	;;
	
	"restore" )
		echo "Restore previous Zeppelin notebooks"

	if [ -n "$2" ] ; then
		sourceRootDir="$2"
	else
		sourceRootDir="/var/lib/zeppelin/notebook/backups"
	fi

	destRootDir="/var/lib/zeppelin/notebook"

	if [ ! -d $sourceRootDir ] ; then
		echo "$sourceRootDir does not exist"
		echo "Notebooks not restored"
	fi

	cp -r $sourceRootDir/* $destRootDir
	rm -rf $sourceRootDir
	;;
esac
