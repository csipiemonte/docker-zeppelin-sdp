#!/bin/bash

if [ -z "$1" ] ; then
	echo "Usage: manage-notebook.sh [ import | backup [dest-dir] | restore [source-dir] ]"
	exit 1
fi

case "$1" in

	"import" )
		sourceNotebookDir="/var/lib/zeppelin/notebook-backup"	# Kubernetes volume mount (only .json notebook files)
		destNotebookDir="/var/lib/zeppelin/notebook"

		if [ -z "$(jq --version)" ] ; then
			wget -q https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 -O jq && \
			chmod +x jq && \
			mv jq /usr/local/bin
		fi
		
		FILES=$sourceNotebookDir/*.json
		for file in $FILES
		do
			echo "file: $file"
			if [ -n "$file" ] ; then
					id=$(jq '.id' $file | tr -d \")
					echo "id: $id"
					mkdir $destNotebookDir/$id
					cp $file $destNotebookDir/$id/note.json
			fi
		done
	;;
	
	"backup" )
		echo "Backup Zeppelin notebooks"

		if [ -n "$2" ] ; then
			destRootDir="$2"
		else
			destRootDir="/var/lib/zeppelin/notebook-backup/notebook"
		fi

		sourceRootDir="/var/lib/zeppelin/notebook"

		if [ ! -d $destRootDir ] ; then
			mkdir -p $destRootDir
		else
			rm -rf $destRootDir/*
		fi

		DIRS=$sourceRootDir/*
		for dir in $DIRS
		do
			if [ -n "$dir" ] ; then
				echo "dir: $dir / $(basename $dir)"
				mkdir $destRootDir/$(basename $dir)
				echo "1: $dir/*.json"				
				cp $dir/*.json $destRootDir/$(basename $dir)/$(basename $dir).json
			fi
		done
		
		#cp -r -d $sourceRootDir/* $destRootDir
	;;
	
	"restore" )
		echo "Restore previous Zeppelin notebooks"

		if [ -n "$2" ] ; then
			sourceRootDir="$2"
		else
			sourceRootDir="/var/lib/zeppelin/notebook-backup/notebook"
		fi

		destRootDir="/var/lib/zeppelin/notebook"

		if [ ! -d $sourceRootDir ] ; then
			echo "$sourceRootDir does not exist"
			echo "Notebooks not restored"
		else		
			cp -r $sourceRootDir/* $destRootDir
		fi

	;;
esac
