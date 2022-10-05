#! /usr/bin/env bash

function main () {
  function compile () {
    local sourceContent="$1"
    echo "${sourceContent}" | sed -E 's/.*\[(.*?)\]\((.*?)\)/{ "type": "pdf", "title": "\1", "link": "\2" },/'
  }

  IFS='
'
  local RESOURCES_FOLDER="resources"
  local resourceFolders=($(ls "${RESOURCES_FOLDER}"))

  for resourceFolder in "${resourceFolders[@]}"
  do
    IFS=" "
    resourceFolder="DataStructure and Algorithms"
    local currentFolder="${RESOURCES_FOLDER}/${resourceFolder}"
    local resourceFiles=($(ls "$currentFolder"))

    compiledOutput="["

    local fileContent="$(find "${currentFolder}" -type f | grep -E ".md" | xargs -I {} cat "{}")"
    local compiled="$(compile "$fileContent")"

    if (( ${#compiled} > 0 ))
    then
      echo "________sss________${compiled}________eee________"
      compiled="${compiled::-1}"
      exit

      if [ -n "${compiled}" ]
      then
        compiledOutput+="${compiled}"
      fi
    fi

    exit
    compiledOutput+="]"

    # echo "${currentFolder}"
    # echo "${compiledOutput}" | jq > "${currentFolder}/resources.json"
    echo "${compiledOutput}"
    exit

  done

  IFS=$old_IFS
}

main
