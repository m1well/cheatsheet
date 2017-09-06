#!/bin/bash
###
#title                  :script_cheatsheet.sh
#description            :This script is a cheatsheet for e.g. git or docker commands or whatever.
#author                 :Michael Wellner (@m1well) twitter.m1well.de
#date of creation       :20170824
#date of last change    :20170906
#version                :2.0.1
#usage                  :script_cheatsheet.sh [-a|-l|-e|-r|-b|-i|-h|-v]
#notes                  :it would be most suitable to create an alias
###

### colors and linebreak ###
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
usageLine="//--- "
usageDescription="//--- Store your commands to a cheatsheet and find & execute them easily"
usageReadme="//--- Please checkout the README.md file!"
usage1="//--- Usage: script_cheatsheet.sh [-a|-l|-e|-r|-b|-i|-h|-v]"
usage2="//---    -a add [param]          add a new command"
usage3="//---    -l list [param]         list your commands including this string - set param 'all' to list all commands"
usage4="//---    -e execute [param]      execute a command by linenumber - it's possible to add another parameter with apostrophes after a comma"
usage5="//---    -r remove [param]       remove a command by linenumber - set param 'all' to remove all commands"
usage6="//---    -b backup [param]       backup your cheatsheet to a given directory"
usage7="//---    -i import [param]       import from a cheatsheet backup from a given directory"
usage8="//---    -h help                 show help"
usage9="//---    -v version              show version"
hint1="//--- Hint:"
hint2="//--- Actually backslashes in commands are not allowed!! (due to bad display of them)"
hint3="//--- Don't use a '-' at first character to search a command! (becaus grep think it is a new option) and to add a command"
hint4="//--- For a better usage it would be most suitable to create an alias like \"alias cheat=\"[path-to-script]/script_cheatsheet.sh\"\""
hint5="//--- so that you can run the tool like this: \"$ cheat -l all\""
successListAll="list of all commands (with line number)"
successListGrep="list of greped commands (with line number)"
successAdd="successfully added following command to the cheatsheet"
successRemoveOne="successfully removed following command from the cheatsheet"
successRemoveAll="successfully removed all commands of the cheatsheet"
successBackup="successfully created backup of the cheatsheet"
successImport="successfully imported following amount of commands from the cheatsheet backup"
successExecute="successfully executed the command"
errorNoFile="error - no cheatsheet file available -> you have to add a first command to create the file"
errorNoMode="error - no mode set"
errorAdd="error - this command exists already in the cheatsheet"
errorRemove="error - this line is not available - cheatsheet has only "
version1="version:                 2.0.1"
version2="date of last change:     20170906"
version3="author:                  Michael Wellner (@m1well)"

### file ###
cheatsheetFile=~/.cheatsheet

printStartLinesOfCheatsheet() {
   printf "${FONT_CYAN}"
   printf "${line}${BR}"
   printf "${cheatsheet}${BR}"
   printf "${FONT_NONE}"
}
printUsage() {
   printf "${FONT_CYAN}"
   printf "${usageLine}${BR}"
   printf "${usageDescription}${BR}"
   printf "${usageReadme}${BR}"
   printf "${usageLine}${BR}"
   printf "${usage1}${BR}${usage2}${BR}${usage3}${BR}${usage4}${BR}"
   printf "${usage5}${BR}${usage6}${BR}${usage7}${BR}"
   printf "${usageLine}${BR}"
   printf "${hint1}${BR}${hint2}${BR}${hint3}${BR}${hint4}${BR}${hint5}${BR}"
   printf "${usageLine}${BR}"
   printf "${FONT_NONE}"
}
printVersionInfo() {
   printf "${FONT_CYAN}"
   printf "${version1}${BR}"
   printf "${version2}${BR}"
   printf "${version3}${BR}"
   printf "${FONT_NONE}"
}
printSuccess() {
   case $1 in
      "add")
         printf "${FONT_GREEN}${successAdd}${BR}${FONT_NONE}"
         echo "${paramAdd}"
         ;;
      "list_all")
         printf "${FONT_GREEN}${successListAll}${BR}${FONT_NONE}"
         ;;
      "list_grep")
         printf "${FONT_GREEN}${successListGrep}${BR}${FONT_NONE}"
         ;;
      "execute1")
         printf "${FONT_GREEN}${successExecute}${BR}${FONT_NONE}"
         echo "$ ${2}"
         ;;
      "execute2")
         printSuccessOfExection "${2}" "${3}"
         ;;
      "remove_all")
         printf "${FONT_GREEN}${successRemoveAll}${BR}${FONT_NONE}"
         ;;
      "remove_one")
         printf "${FONT_GREEN}${successRemoveOne}${BR}${FONT_NONE}"
         echo "${2}"
         ;;
      "backup")
         printf "${FONT_GREEN}${successBackup}${BR}${FONT_NONE}"
         ;;
      "import")
         printf "${FONT_GREEN}${successImport}${BR}${FONT_NONE}"
         echo "${2}"
         ;;
   esac
}
printSuccessOfExection() {
   printf "${FONT_GREEN}${successExecute}${BR}${FONT_NONE}"
   local escaped=$(echo "${2}" | sed 's/\//\\\//g')
   echo "$ ${1}" | sed -e "s/{1}/${escaped}/g"
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
         printf "${BACKGROUND_RED}${errorAdd}${BACKGROUND_DEFAULT}${BR}"
         ;;
      "remove")
         printf "${BACKGROUND_RED}${errorRemove}${2} lines${BACKGROUND_DEFAULT}${BR}"
         ;;
   esac
}
exitScript() {
   printf "${FONT_CYAN}${line}${FONT_NONE}${BR}"
   exit 0
}

### check input opts ###
# [-a|-l|-e|-r|-b|-i|-h|-v]
while getopts "a:l:e:r:b:i:hv" arg ; do
   case $arg in
      a)
         paramAdd="${OPTARG}"
         ;;
      l)
         paramList="${OPTARG}"
         ;;
      e)
         # check if there is another command after the linenumber
         if echo "${OPTARG}" | grep -q "," ; then
            paramExecute1=$(echo ${OPTARG} | cut -d ',' -f 1)
            paramExecute2="${OPTARG:${#paramExecute1}+1:${#OPTARG}-1}"
         else
            paramExecute1="${OPTARG}"
            paramExecute2="null"
         fi
         ;;
      r)
         paramRemove="${OPTARG}"
         ;;
      b)
         paramBackup="${OPTARG}"
         ;;
      i)
         paramImport="${OPTARG}/.cheatsheet"
         ;;
      v)
         printStartLinesOfCheatsheet
         printVersionInfo
         exitScript
         ;;
      h | *)
         printStartLinesOfCheatsheet
         printUsage
         exitScript
         ;;
   esac
done
shift $((OPTIND -1))

### logical functions ###
isAddMode() {
   if [ -n "${paramAdd}" ] ; then return 0 ; fi
   return 1
}
isListMode() {
   if [ -n "${paramList}" ] ; then return 0 ; fi
   return 1
}
isExecuteMode() {
   if [ -n "${paramExecute1}" ] ; then return 0 ; fi
   return 1
}
isRemoveMode() {
   if [ -n "${paramRemove}" ] ; then return 0 ; fi
   return 1
}
isBackupMode() {
   if [ -n "${paramBackup}" ] ; then return 0 ; fi
   return 1
}
isImportMode() {
   if [ -n "${paramImport}" ] ; then return 0 ; fi
   return 1
}
isFileExisting() {
   if [ -e "${cheatsheetFile}" ] ; then return 0 ; fi
   return 1
}
isStringEqual() {
   if [ "${1}" == "${2}" ] ; then return 0 ; fi
   return 1
}
isStringInFile() {
   if grep -Fx -q "${1}" "${2}" ; then return 0 ; fi
   return 1
}
addOneCommand() {
   # add it to the file
   echo "${1}" >> "${2}"
   # sort file instantly
   cat "${2}" | sort > "${2}".tmp
   mv "${2}".tmp "${2}"
}
removeOneCommand() {
   # move all other commands to a tmp file
   sed "${1}d" "${2}" > ${2}.tmp
   # remove cheatsheet file
   rm ${2}
   if [[ -s "${2}".tmp ]] ; then
      # change tempfile to new cheatsheet file
      mv "${2}".tmp "${2}"
   else
      # remove tempfile if it is epty
      rm "${2}".tmp
   fi
}
printGreppedList() {
   local number=""
   local command=""
   # grep complete list and itereate over this list
   grep -n "${1}" "${2}" | while read -r greppedList ; do
      for ln in "${greppedList}" ; do
         # split the line to number and command
         number=$(echo ${ln} | cut -d ':' -f 1)
         if (( ${number} < 10 )) ; then
            command="${ln:2:${#ln}-1}"
         else
            command="${ln:3:${#ln}-1}"
         fi
         printf '%02d: %s\n' $number "${command}"
      done
   done
}
printCompleteList() {
   local counter=0
   while read -r completeList ; do
      for completeLine in "${completeList}" ; do
         ((counter++))
         printf '%02d: %s\n' $counter "${completeLine}"
      done
   done < "${1}"
}
executeOneCommand() {
   printf "${FONT_CYAN}${line}${BR}${FONT_NONE}"
   eval "${1}"
   exit 0
}
executeTwoCommands() {
   printf "${FONT_CYAN}${line}${BR}${FONT_NONE}"
   local escaped=$(echo "${2}" | sed 's/\//\\\//g')
   local cmd=$(echo "${1}" | sed -e "s/{1}/${escaped}/g")
   eval "${cmd}"
   exit 0
}

### start of script ###
printStartLinesOfCheatsheet

### add mode
if isAddMode ; then
   if isFileExisting ; then
      if isStringInFile "${paramAdd}" "${cheatsheetFile}" ; then
         printError "add"
      else
         addOneCommand "${paramAdd}" "${cheatsheetFile}"
         printSuccess "add"
      fi
   else
      # no file available
      addOneCommand "${paramAdd}" "${cheatsheetFile}"
      printSuccess "add"
   fi
   exitScript

### list mode
elif isListMode ; then
   if isFileExisting ; then
      if isStringEqual "${paramList}" "all" ; then
         printSuccess "list_all"
         printCompleteList "${cheatsheetFile}"
      else
         printSuccess "list_grep"
         printGreppedList "${paramList}" "${cheatsheetFile}"
      fi
   else
      # no file available
      printError "file_no_file"
      printUsage
   fi
   exitScript

### execute mode
elif isExecuteMode ; then
   if isFileExisting ; then
      exec1=$(sed -n "${paramExecute1}"p "${cheatsheetFile}")
      if !(isStringEqual "${paramExecute2}" "null") ; then
         exec2=${paramExecute2}
         printSuccess "execute2" "${exec1}" "${exec2}"
         executeTwoCommands "${exec1}" "${exec2}"
      else
         printSuccess "execute1" "${exec1}"
         executeOneCommand "${exec1}"
      fi
   else
      # no file available
      printError "file_no_file"
      printUsage
      exitScript
   fi

### remove mode
elif isRemoveMode ; then
   if isFileExisting ; then
      if isStringEqual "${paramRemove}" "all" ; then
         rm "${cheatsheetFile}"
         printSuccess "remove_all"
      else
         countedLines=$(sed -n '$=' "${cheatsheetFile}")
         if (( ${paramRemove} <= ${countedLines} )) ; then
            printSuccess "remove_one" "$(sed -n "${paramRemove}"p "${cheatsheetFile}")"
            removeOneCommand "${paramRemove}" "${cheatsheetFile}"
         else
            printError "remove" "${countedLines}"
         fi
      fi
   else
      # no file available
      printError "file_no_file"
      printUsage
   fi
   exitScript

### backup mode
elif isBackupMode ; then
   cp "${cheatsheetFile}" "${paramBackup}"
   printSuccess "backup"
   exitScript

### import mode
elif isImportMode ; then
   i=0
   while read importFileLine ; do
      if isFileExisting ; then
         if !(isStringInFile "${importFileLine}" "${cheatsheetFile}") ; then
            # if command is not in the file then import it
            addOneCommand "${importFileLine}" "${cheatsheetFile}"
            i=$((i+1))
         fi
      else
         # if file is not existing then import the command
         addOneCommand "${importFileLine}" "${cheatsheetFile}"
         i=$((i+1))
      fi
   done < "${paramImport}"
   printSuccess "import" "${i}"
   exitScript

### no mode
else
   printError "mode"
   printUsage
   exitScript
fi

### end of script ###
#####################
