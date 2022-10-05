#! /usr/bin/env bash

function main () {
  local RESOURCES_FOLDER="resources"
  local resourceFolders=($(ls $RESOURCES_FOLDER))

  for resourceName in "${resourceFolders[@]}"
  do
    for resourceFile in "${resourceFiles[@]}"
    do
      local fileContent=$(cat "$resourceFile")
      echo $fileContent
    done
  done
}

main
