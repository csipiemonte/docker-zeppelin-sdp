#!/bin/bash

if [ -z "$1" ] ; then
	echo "Usage: manage-notebook.sh [ import | backup [dest-dir] | restore [source-dir] ]"
	exit 1
fi

case "$1" in

	"import" )
	
		sourceNotebookDir="/var/lib/zeppelin/notebook-backup"	# Kubernetes volume mount (only .json notebook files)
		destNotebookDir="/var/lib/zeppelin/notebook"
		
		if [ ! -d $destNotebookDir ] ; then
			mkdir -p $destNotebookDir
		fi
		
		# Create directory structure for Zeppelin notebook import
		ITEMS=$sourceNotebookDir/*
		for item in $ITEMS
		do
			echo "item: $item"
			if [ -n "$item" -a -d $item ] ; then
				echo "find directory $item to import to $destNotebookDir"
			fi

			if [ -n "$item" -a -f $item ] ; then
				id=$(jq '.id' $item | tr -d \")
				echo "find file json $item to import to $destNotebookDir"
				mkdir $sourceNotebookDir/$id
				mv $item $sourceNotebookDir/$id/note.json
			fi
		done

		cp -rf -d $sourceNotebookDir/* $destNotebookDir
		echo "Import completed"
	;;
	
	"backup" )
		echo "Backup Zeppelin notebooks"

		if [ -n "$2" ] ; then
			destRootDir="$2"
		else
			destRootDir="/var/lib/zeppelin/notebook-backup"
		fi

		sourceRootDir="/var/lib/zeppelin/notebook"

		if [ ! -d $destRootDir ] ; then
			mkdir -p $destRootDir
		fi
		
		cp -r -d $sourceRootDir/* $destRootDir
		echo "Backup completed"
	;;
	
	"restore" )
		echo "Restore previous Zeppelin notebooks"

		if [ -n "$2" ] ; then
			sourceRootDir="$2"
		else
			sourceRootDir="/var/lib/zeppelin/notebook-backup"
		fi

		destRootDir="/var/lib/zeppelin/notebook"

		if [ ! -d $sourceRootDir ] ; then
			echo "$sourceRootDir does not exist"
			echo "Notebooks not restored"
		else
			cp -r $sourceRootDir/* $destRootDir
		fi
		echo "Restore completed"

	;;
esac
