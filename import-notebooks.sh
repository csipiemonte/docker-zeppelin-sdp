#!/bin/bash

rootNotebookDir=/var/lib/zeppelin/notebook

FILES=$rootNotebookDir/*.json
for file in $FILES
do
        echo "file : $file"
        if [ -n "$file" ] ; then
                id=$(jq '.id' $file | tr -d \")
                echo "id: $id"
                mkdir $rootNotebookDir/$id
                cp $file $rootNotebookDir/$id/note.json
        fi
done