#!/usr/bin/env bash

#########################
# Repo specific content #
#########################

export ALIAS_NAME=""
export OWNER=mas2020-golang
export REPO=app-package
export BINLOCATION="/usr/local/bin"
export SUCCESS_CMD="$BINLOCATION/$REPO"

# -- COLORS
# color for a main activity
export ACTIVITY="\e[1;33m"
# color for a sub activity
export SUB_ACT="\e[1;34m>\e[0m"
export DONE="\e[1;32m│ Done\e[0m"
export INFO="\e[1;32m•\e[0m"
export OK="\e[1;32mOK\e[0m"
export ERROR="\e[1;31m│ Error:\e[0m"
export WARNING="\e[0;33m│ Warning:\e[0m"
export GREEN="\e[1;32m"
export RED="\e[1;31m"
export YELLOW="\e[1;33m"
export RESET="\e[0m"
export STOP_COLOR="\e[0m"

###############################
# Content common across repos #
###############################
#set -x
printf "${ACTIVITY}%s ${STOP_COLOR}\n" "Installing the '$REPO' application..."
version=$(curl -sI https://github.com/$OWNER/$REPO/releases/latest | grep -i "location:" | awk -F"/" '{ printf "%s", $NF }' | tr -d '\r')

#version=${version:1}
printf "${INFO} selected version for %s is '%q'\n" $REPO $version
if [ ! $version ]; then
  echo "Failed while attempting to install $REPO. Please manually install:"
  echo ""
  echo "1. Open your web browser and go to https://github.com/$OWNER/$REPO/releases"
  echo "2. Download the latest release for your platform. Extract it and call it '$REPO'."
  echo "3. chmod +x ./$REPO"
  echo "4. mv ./$REPO $BINLOCATION"
  if [ -n "$ALIAS_NAME" ]; then
    echo "5. ln -sf $BINLOCATION/$REPO /usr/local/bin/$ALIAS_NAME"
  fi
  exit 1
fi

hasCli() {
  if [[ ! $(which curl) ]]; then
    printf "${ERROR} You need curl to use this script\n"
    exit 1
  fi
}

getPackage() {
  uname=$(uname)
  userid=$(id -u)

  suffix=""
  case $uname in
  "Darwin")
    arch=$(uname -m)
    case $arch in
    "x86_64")
      suffix="Darwin-x86_64"
      ;;
    esac
    case $arch in
    "arm64")
      suffix="Darwin-arm64"
      ;;
    esac
    ;;

  "MINGW"*)
    suffix=".exe"
    BINLOCATION="$HOME/bin"
    mkdir -p $BINLOCATION

    ;;
  "Linux")
    arch=$(uname -m)
    case $arch in
    "aarch64")
      suffix="Linux-arm64"
      ;;
    esac
    case $arch in
    "x86_64")
      suffix="Linux-x86_64"
      ;;
    esac
    ;;
  esac
  targetFile="/tmp/$REPO_$version_$suffix.tar.gz"
  downloadFile="${REPO}_${version}_${suffix}.tar.gz"
  printf "${INFO} the file to download is '%q'\n" "${downloadFile}"

  if [ "$userid" != "0" ]; then
    targetFile="$(pwd)/$REPO_$version_$suffix.tar.gz"
  fi

  if [ -e "$targetFile" ]; then
    rm "$targetFile"
  fi

  url="https://github.com/$OWNER/$REPO/releases/download/$version/${downloadFile}"
  printf "\n${SUB_ACT} %s\n%s ${STOP_COLOR}\n" "downloading package:" "$url --> $targetFile..."

  http_code=$(curl -sSL $url -w '%{http_code}\n' --output "$targetFile")

  # check the file not found
  if [[ ${http_code} -eq 404 ]]; then
    printf "${ERROR} no file as a target download has been found\n"
    exit 1
  fi
  
  if [ "$?" = "0" ]; then
    chmod +x "$targetFile"
    printf "${DONE} download complete\n"

    # untar the file
    printf "\n${SUB_ACT} untar the package ${STOP_COLOR}\n"
    cd $(dirname $targetFile)
    tar xzf $targetFile > /dev/null
    oldTargetFile=$targetFile
    targetFile=$(dirname $targetFile)"/$REPO"
    rm $oldTargetFile
    if [ "$?" = "0" ]; then
      printf "${DONE}\n"
    else
      printf "${ERROR} occurred during the tar of the file\n"
      exit 1
    fi
    
    if [ ! -w "$BINLOCATION" ]; then
      echo
      echo "======================================================"
      echo "The script was run as a user who is unable to write"
      echo "to $BINLOCATION. To complete the installation the"
      echo "following commands may need to be run manually."
      echo "======================================================"
      echo
      echo "To install type:"
      echo "sudo cp ${targetFile} $BINLOCATION/$REPO"

      # if ALIAS_NAME is set
      if [ -n "$ALIAS_NAME" ]; then
        if [ ! $(which $ALIAS_NAME) ]; then
          echo "sudo ln -sf $BINLOCATION/$REPO $BINLOCATION/$ALIAS_NAME"
        fi
      fi
    else
      printf "\n${SUB_ACT} %s ${STOP_COLOR}\n" "moving $REPO to $BINLOCATION..."

      if [ ! -w "$BINLOCATION/$REPO" ] && [ -f "$BINLOCATION/$REPO" ]; then
        echo
        echo "================================================================"
        echo "  $BINLOCATION/$REPO already exists and is not writeable"
        echo "  by the current user.  Please adjust the binary ownership"
        echo "  or run sh/bash with sudo."
        echo "================================================================"
        echo
        exit 1
      fi
      mv "$targetFile" $BINLOCATION/$REPO

      if [ "$?" = "0" ]; then
        printf "${DONE} new version of $REPO installed to $BINLOCATION\n"
        printf "${INFO} the README file has been saved in %s\n" $(dirname $targetFile)
      fi

      if [ -e "$targetFile" ]; then
        rm "$targetFile"
      fi

      if [ -n "$ALIAS_NAME" ]; then
        if [ $(which $ALIAS_NAME) ]; then
          printf "${WARNING} there is already a command '$ALIAS_NAME' in the path, NOT creating alias\n"
        else
          if [ ! -L $BINLOCATION/$ALIAS_NAME ]; then
            ln -s $BINLOCATION/$REPO $BINLOCATION/$ALIAS_NAME
            printf "${DONE} created alias '$ALIAS_NAME' for '$REPO'\n"
          fi
        fi
      fi
      printf "\n${SUB_ACT} checking application...\n"
      ${SUCCESS_CMD}
    fi
  fi
}

hasCli
getPackage
