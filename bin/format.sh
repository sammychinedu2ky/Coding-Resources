#! /usr/bin/env bash

function main () {
  function compile () {
    local sourceContent="$1"
    local old_IFS="$IFS"
    echo "${sourceContent}" | sed -E 's/.*\[(.*?)\]\((.*?)\)/{ "type": "pdf", "title": "\1", "link": "\2" }/'
  }

  local old_IFS="$IFS"
  IFS='
'
  local RESOURCES_FOLDER="resources"
  local resourceFolders=($(ls "${RESOURCES_FOLDER}"))

  for resourceFolder in "${resourceFolders[@]}"
  do
    local resourceFolder="Git"
    local currentFolder="${RESOURCES_FOLDER}/${resourceFolder}"
    local resourceFiles=($(ls "${currentFolder}" | grep -E ".md$"))

    compiledOutput="["

    for i in $(seq 0 $((${#resourceFiles[@]} - 1)))
    do
      local resourceFile="${resourceFiles[i]}"

      # IFS=$_old_IFS
      local fileContent="$(cat "${RESOURCES_FOLDER}/${resourceFolder}/${resourceFile}" | grep -E '\[.*\]\(.*\)|\(.*\)\[.*\]')"

      local compiled="$(compile "$fileContent" | sed -E 's/(\{.*?\})\s(\{.*?\})//')"
      echo $compiled

      exit

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

      IFS='
'
    done

    compiledOutput+="]"

    #echo $compiledOutput | jq
    #echo
    echo $compiledOutput
    #echo
    exit

  done

  IFS=$old_IFS
}

main
