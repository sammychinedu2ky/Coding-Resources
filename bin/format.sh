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
  IFS=" "

  for resourceFolder in "${resourceFolders[@]}"
  do
    local currentFolder="${RESOURCES_FOLDER}/${resourceFolder}"
    local resourceFiles=($(ls "$currentFolder"))

    compiledOutput="["

    local fileContent="$(find "${currentFolder}" -type f | grep -E ".md" | xargs -I {} cat "{}")"
    local compiled="$(compile "$fileContent")191919"
    compiled="$(echo $compiled | sed -E 's/\}, 191919?/}/')"
    compiledOutput+="${compiled}"

    compiledOutput+="]"

    echo "${compiledOutput}" | jq > "${currentFolder}/resources.json"

  done

  IFS=$old_IFS
}

main
