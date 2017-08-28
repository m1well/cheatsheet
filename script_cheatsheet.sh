#!/bin/bash
###
#title           :script_cheatsheet.sh
#description     :This script is a cheatsheet for e.g. git or docker commands.
#author          :Michael Wellner (@m1well) m1well.de
#date            :20170824
#version         :1.4.0
#usage           :sh script_cheatsheet.sh [-l|-a|-r|-h|-v]
#notes           :it would be most suitable to create an alias
###

### colors ###
BR="\n"
FONT_CYAN="\033[0;96m"
FONT_GREEN="\033[0;92m"
FONT_YELLOW="\033[0;93m"
FONT_NONE="\033[0m"
BACKGROUND_RED="\033[41m"
BACKGROUND_DEFAULT="\033[49m"

### output lines ###
line="//-----------------------------//"
cheatsheet="//-------- cheatsheet  --------//"
usage="//--- "
usage1="//--- Usage: sh script_cheatsheet.sh [-l|-a|-r|-h|-v]"
usage2="//---    -l list        list your commands including this string (set param 'all' to list all commands)"
usage3="//---    -a add         add a new command"
usage4="//---    -r remove      remove a command (set param 'all' to remove all commands)"
usage5="//---    -h help        show help"
usage6="//---    -v version     show version"
usage7="//--- Hint:"
usage8="//--- it would be most suitable to create an alias like \"alias cheat=\"sh [path-to-script] \"\""
usage9="//--- so you can e.g. add a command with \"$ cheat -a 'git commit --amend'\""
errorNoFile="error - no cheatsheet file available -> you have to add a first command to create the file"
errorNoMode="error - no mode set"
successListAll="list of all commands:"
successListGrep="list of greped commands:"
successAdd="successfully added following command to the cheatsheet"
errorAdd="error - following command is already in the cheatsheet"
successRemoveOne="successfully removed following command from the cheatsheet"
successRemoveAll="successfully removed all commands of the cheatsheet"
errorRemove="error - following command is not available in the cheatsheet"
version1="version:    1.4.0"
version2="author:     Michael Wellner (@m1well)"

### file ###
cheatsheetFile=~/.cheatsheet

### print functions ###
printParametersForDev() {
   printf "${FONT_YELLOW}"
   printf "print parameters:${BR}"
   printf "file: ${cheatsheetFile}${BR}"
   printf "list: ${paramList}${BR}"
   printf "add: ${paramAdd}${BR}"
   printf "remove: ${paramRemove}${BR}"
   printf "${FONT_NONE}"
}
printStartLinesOfCheatsheet() {
   printf "${FONT_CYAN}"
   printf "${line}${BR}"
   printf "${cheatsheet}${BR}"
   printf "${FONT_NONE}"
}
printUsage() {
   printf "${FONT_CYAN}"
   printf "${usage}${BR}${usage1}${BR}${usage2}${BR}${usage3}${BR}"
   printf "${usage4}${BR}${usage5}${BR}${usage6}${BR}${usage}${BR}"
   printf "${usage7}${BR}${usage8}${BR}${usage9}${BR}${usage}${BR}"
   printf "${FONT_NONE}"
}
printVersionInfo() {
   printf "${FONT_CYAN}"
   printf "${version1}${BR}"
   printf "${version2}${BR}"
   printf "${FONT_NONE}"
}
printSuccess() {
   case $1 in
      "list_all")
         printf "${FONT_GREEN}${successListAll}${FONT_NONE}${BR}"
         ;;
      "list_grep")
         printf "${FONT_GREEN}${successListGrep}${BR}${FONT_NONE}"
         ;;
      "add")
         printf "${FONT_GREEN}${successAdd}${BR}${FONT_NONE}${paramAdd}${BR}"
         ;;
      "remove_all")
         printf "${FONT_GREEN}${successRemoveAll}${BR}${FONT_NONE}"
         ;;
      "remove_one")
         printf "${FONT_GREEN}${successRemoveOne}${BR}${FONT_NONE}${paramRemove}${BR}"
         ;;
   esac
}
printError() {
   case $1 in
      "file_no_file")
         printf "${BACKGROUND_RED}${errorNoFile}${BACKGROUND_DEFAULT}${BR}"
         ;;
      "mode")
         printf "${BACKGROUND_RED}${errorNoMode}${BACKGROUND_DEFAULT}${BR}"
         ;;
      "add")
         printf "${BACKGROUND_RED}${errorAdd}${BACKGROUND_DEFAULT}${BR}${paramAdd}${BR}"
         ;;
      "remove")
         printf "${BACKGROUND_RED}${errorRemove}${BACKGROUND_DEFAULT}${BR}${paramRemove}${BR}"
         ;;
   esac
}
exitScript() {
   printf "${FONT_CYAN}${line}${FONT_NONE}${BR}"
   exit 0
}

### check input opts ###
while getopts ":a:l:r:hv" arg; do
   case $arg in
      a)
         paramAdd=${OPTARG}
         ;;
      l)
         paramList=${OPTARG}
         ;;
      r)
         paramRemove=${OPTARG}
         ;;
      v)
         paramVersion="version"
         ;;
      h | *)
         printUsage
         exitScript
   esac
done

### logical functions ###
isListMode() {
   if [ -n "${paramList}" ]; then
      return 0
	 else
      return 1
   fi
}
isAddMode() {
   if [ -n "${paramAdd}" ]; then
      return 0
	 else
      return 1
   fi
}
isRemoveMode() {
   if [ -n "${paramRemove}" ]; then
      return 0
	 else
      return 1
   fi
}
isVersionMode() {
   if [ -n "${paramVersion}" ]; then
      return 0
	 else
      return 1
   fi
}
isFileExisting() {
   if [ -e "${cheatsheetFile}" ]; then
      return 0
	 else
      return 1
   fi
}
isParamAll() {
   if [ "${1}" == "all" ]; then
      return 0
	 else
      return 1
   fi
}
isStringEqual() {
   if [ "${1}" == "${2}" ]; then
			return 0
   else
      return 1
   fi
}
isGrepedStringInFile() {
   if grep -q "${1}" "${2}"; then
      return 0
   else
      return 1
   fi
}
removeOneCommand() {
   # move all non greped to a tmp file
   grep -F -v "${1}" ${2} > ${2}.tmp
	 # remove cheatsheet file
	 rm ${2}
	 if [[ $(wc -l < ${2}.tmp) > 0 ]]; then
		  # change tempfile to new cheatsheet file
		  mv "${2}".tmp "${2}"
   else
      # remove tempfile if it is epty
      rm "${2}".tmp
   fi
}

### print parameters for dev ###
# printParametersForDev

### start of script ###
printStartLinesOfCheatsheet

### list mode
if isListMode; then
   if isFileExisting; then
      if isParamAll "${paramList}"; then
         printSuccess "list_all"
         cat "${cheatsheetFile}"
      else
         printSuccess "list_grep"
         grep --color=always "${paramList}" "${cheatsheetFile}"
      fi
   else
		  # no file available
      printError "file_no_file"
      printUsage
   fi
   exitScript

### add mode
elif isAddMode; then
	 if isFileExisting; then
      if isGrepedStringInFile "${paramAdd}" "${cheatsheetFile}"; then
         printError "add"
      else
         echo "${paramAdd}" >> "${cheatsheetFile}"
         # sort file instantly
         cat "${cheatsheetFile}" | sort > "${cheatsheetFile}".tmp
         mv "${cheatsheetFile}".tmp "${cheatsheetFile}"
         printSuccess "add"
      fi
   else
      # no file available
			echo "${paramAdd}" >> "${cheatsheetFile}"
			printSuccess "add"
   fi
   exitScript

### remove mode
elif isRemoveMode; then
   if isFileExisting; then
      if isParamAll "${paramRemove}"; then
         rm "${cheatsheetFile}"
				 printSuccess "remove_all"
      else
         if isGrepedStringInFile "${paramRemove}" "${cheatsheetFile}"; then
            removed="$(grep "${paramRemove}" "${cheatsheetFile}")"
            if isStringEqual "${removed}" "${paramRemove}"; then
               printSuccess "remove_one"
               removeOneCommand "${paramRemove}" "${cheatsheetFile}"
            else
               printError "remove"
            fi
         else
            printError "remove"
         fi
      fi
   else
		  # no file available
      printError "file_no_file"
      printUsage
   fi
	 exitScript

### version mode
elif isVersionMode; then
   printVersionInfo
   exitScript

### no mode
else
   printError "mode"
   printUsage
   exitScript
fi

### end of script ###
