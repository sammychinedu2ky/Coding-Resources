#! /usr/bin/env bash

function main () {
  function compile () {
    local sourceContent="$1"
    echo "${sourceContent}" | sed -E 's/.*\[(.*?)\]\((.*?)\)/{ "type": "pdf", "title": "\1", "link": "\2" }/'
  }

  local old_IFS="$IFS"
  IFS='
'
  local RESOURCES_FOLDER="resources"
  local resourceFolders=($(ls "${RESOURCES_FOLDER}"))

  for resourceFolder in "${resourceFolders[@]}"
  do
    local currentFolder="${RESOURCES_FOLDER}/${resourceFolder}"
    local resourceFiles=($(ls "${currentFolder}" | grep -E ".md$"))

    compiledOutput="["

    for i in $(seq 0 $((${#resourceFiles[@]} - 1)))
    do
      local resourceFile="${resourceFiles[i]}"

      local fileContent="$(cat "${RESOURCES_FOLDER}/${resourceFolder}/${resourceFile}" | grep -E '\[.*\]\(.*\)|\(.*\)\[.*\]')"

      local compiled="$(compile "$fileContent" | sed -E 's/(\{.*?\})/\1,/g')"
      if (( ${#compiled} > 0 ))
      then
        compiled="${compiled::-1}"
      fi

      if [ -n "${compiled}" ]
      then
        if [[ "${#resourceFiles[@]}" == "1" ]]
        then
          compiledOutput+="${compiled}"
        else
          if [[ $i == $((${#resourceFiles[@]} - 1)) ]]
          then
            compiledOutput+="${compiled}"
          else
            compiledOutput+="${compiled},"
          fi
        fi
      fi
    done

    compiledOutput+="]"

    echo $currentFolder
    echo $compiledOutput | jq
    echo $compiledOutput
    echo

  done

  IFS=$old_IFS
}

main
