#!/bin/bash

_error() {
  echo -e "$1"

  if [ "${LOOSE_ERROR}" == "true" ]; then
    exit 0
  else
    exit 1
  fi
}

_version() {
  if [ ! -f ./VERSION ]; then
    printf "v0.0.x" > ./VERSION
  fi

  echo "GITHUB_REF: ${GITHUB_REF}"

  # release version
  MAJOR=$(cat ./VERSION | xargs | cut -d'.' -f1)
  MINOR=$(cat ./VERSION | xargs | cut -d'.' -f2)
  PATCH=$(cat ./VERSION | xargs | cut -d'.' -f3)

  if [ "${PATCH}" != "x" ]; then
    VERSION="${MAJOR}.${MINOR}.${PATCH}"
    printf "${VERSION}" > ./VERSION
  else
    # latest versions
    URL="https://api.github.com/repos/${GITHUB_REPOSITORY}/releases"
    VERSION=$(curl -s ${URL} | jq -r '.[] | .tag_name' | grep "${MAJOR}.${MINOR}." | cut -d'-' -f1 | sort -Vr | head -1)

    if [ -z ${VERSION} ]; then
      VERSION="${MAJOR}.${MINOR}.0"
    fi

    echo "VERSION: ${VERSION}"

    # new version
    if [ "${GITHUB_REF}" == "refs/heads/master" ]; then
      VERSION=$(echo ${VERSION} | awk -F. '{$NF = $NF + 1;} 1' | sed 's/ /./g')
    else
      if [ "${GITHUB_REF}" != "" ]; then
        # refs/pull/1/merge
        PR_CMD=$(echo "${GITHUB_REF}" | cut -d'/' -f2)
        PR_NUM=$(echo "${GITHUB_REF}" | cut -d'/' -f3)
      fi

      if [ "${PR_CMD}" == "pull" ] && [ "${PR_NUM}" != "" ]; then
        VERSION="${VERSION}-${PR_NUM}"
      else
        VERSION=""
      fi
    fi

    if [ "${VERSION}" != "" ]; then
      printf "${VERSION}" > ./VERSION
    fi
  fi

  echo "VERSION: ${VERSION}"
}

_version
