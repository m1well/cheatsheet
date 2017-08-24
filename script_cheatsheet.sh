#!/bin/bash
###
#title           :script_cheatsheet.sh
#description     :This script is a cheatsheet for e.g. git or docker commands.
#author          :Michael Wellner (@m1well) m1well.de
#date            :20170824
#version         :1.1.0
#usage           :sh script_cheatsheet.sh -f .cheatsheet [-l|-a|-r|-v]
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
usage1="//--- Usage: sh script_cheatsheet.sh [-f] [-l|-a|-r|-v]"
usage2="//---    -f filename    set the path to the cheatsheet file (this is mandatory!!)"
usage3="//---    -l list        list your commands including this string (set param 'all' to list all commands)"
usage4="//---    -a add         add a new command"
usage5="//---    -r remove      remove a command (set param 'all' to remove all commands)"
usage6="//---    -h help        show help"
usage7="//---    -v version     show version"
usage8="//--- the script only observes the first two options (-f [param] is mandatory)"
usage9="//--- Hint:"
usage10="//--- it would be most suitable to create an alias like \"alias cheat=\"sh [path-to-script] -f [path-to-cheatsheet]\"\""
usage11="//--- so you can e.g. add a command with \"$ cheat -a 'git commit --amend'\""
file_error_not_set="error - no path to cheatsheet file set"
file_error_no_file="error - no cheatsheet file available -> you have to add a first command to create the file"
mode_error="error - no mode set"
list_all_success="list of all commands:"
list_grep_success="list of greped commands:"
add_success="successfully added following command to the cheatsheet"
add_error="error - following command is already in the cheatsheet"
remove_one_success="successfully removed following command from the cheatsheet"
remove_all_success="successfully removed all commands of the cheatsheet"
remove_error="error - following command is not available in the cheatsheet"
version1="version:    1.1.0"
version2="author:     Michael Wellner (@m1well)"
### functions ###
print_parameters_for_dev() {
   printf "${FONT_YELLOW}"
   printf "print parameters:${BR}"
   printf "file: ${file_param}${BR}"
   printf "list: ${list_param}${BR}"
   printf "add: ${add_param}${BR}"
   printf "remove: ${remove_param}${BR}"
   printf "${FONT_NONE}"
}
print_start_of_cheatsheet() {
   printf "${FONT_CYAN}"
   printf "${line}${BR}"
   printf "${cheatsheet}${BR}"
   printf "${FONT_NONE}"
}
print_usage() {
   printf "${FONT_CYAN}"
   printf "${usage}${BR}"
   printf "${usage1}${BR}"
   printf "${usage2}${BR}"
   printf "${usage3}${BR}"
   printf "${usage4}${BR}"
   printf "${usage5}${BR}"
   printf "${usage6}${BR}"
   printf "${usage7}${BR}"
   printf "${usage8}${BR}"
   printf "${usage}${BR}"
   printf "${usage9}${BR}"
   printf "${usage10}${BR}"
   printf "${usage11}${BR}"
   printf "${usage}${BR}"
   printf "${FONT_NONE}"
}
print_version() {
   printf "${FONT_CYAN}"
   printf "${version1}${BR}"
   printf "${version2}${BR}"
   printf "${FONT_NONE}"
}
print_success() {
   case $1 in
      "list_all")
         printf "${FONT_GREEN}${list_all_success}${FONT_NONE}${BR}"
         ;;
      "list_grep")
         printf "${FONT_GREEN}${list_grep_success}${BR}${FONT_NONE}"
         ;;
      "add")
         printf "${FONT_GREEN}${add_success}${BR}${FONT_NONE}${add_param}${BR}"
         ;;
      "remove_all")
         printf "${FONT_GREEN}${remove_all_success}${BR}${FONT_NONE}"
         ;;
      "remove_one")
         printf "${FONT_GREEN}${remove_one_success}${BR}${FONT_NONE}${remove_param}${BR}"
         ;;
   esac
}
print_error() {
   case $1 in
      "file_not_set")
         printf "${BACKGROUND_RED}${file_error_not_set}${BACKGROUND_DEFAULT}${BR}"
         ;;
      "file_no_file")
         printf "${BACKGROUND_RED}${file_error_no_file}${BACKGROUND_DEFAULT}${BR}"
         ;;
      "mode")
         printf "${BACKGROUND_RED}${mode_error}${BACKGROUND_DEFAULT}${BR}"
         ;;
      "add")
         printf "${BACKGROUND_RED}${add_error}${BACKGROUND_DEFAULT}${BR}${add_param}${BR}"
         ;;
      "remove")
         printf "${BACKGROUND_RED}${remove_error}${BACKGROUND_DEFAULT}${BR}${remove_param}${BR}"
         ;;
   esac
}
exit_script() {
   printf "${FONT_CYAN}${line}${FONT_NONE}${BR}"
   exit 0
}

### check input opts ###
while getopts ":a:f:l:r:hv" arg; do
   case $arg in
      a)
         add_param=${OPTARG}
         ;;
      f)
         file_param=${OPTARG}
         ;;
      l)
         list_param=${OPTARG}
         ;;
      r)
         remove_param=${OPTARG}
         ;;
      v)
         version_param="version"
         ;;
      h | *)
         print_usage
         exit_script
   esac
done

### print parameters for dev ###
# print_parameters_for_dev

### start of script ###
print_start_of_cheatsheet

if [ -n "${file_param}" ]; then
   if [ -n "${list_param}" ]; then
      # list mode
      if [ "${list_param}" == "all" ]; then
         if [ -f "${file_param}" ]; then
            print_success "list_all"
            cat "${file_param}"
         else
           print_error "file_no_file"
           print_usage
           exit_script
         fi
      else
         print_success "list_grep"
         grep --color=always "${list_param}" "${file_param}"
      fi
      exit_script
   elif [ -n "${add_param}" ]; then
      # add mode
      if grep -q "${add_param}" "${file_param}"; then
         print_error "add"
         exit_script
      else
         echo "${add_param}" >> "${file_param}"
         # sort file instantly
         cat "${file_param}" | sort > "${file_param}".tmp
         mv "${file_param}".tmp "${file_param}"
         print_success "add"
         exit_script
      fi
   elif [ -n "${remove_param}" ]; then
      # remove mode
      if [ -f "${file_param}" ]; then
         if [ "${remove_param}" == "all" ]; then
            print_success "remove_all"
               rm "${file_param}"
         else
            if grep -q "${remove_param}" "${file_param}"; then
               removed="$(grep "${remove_param}" "${file_param}")"
               if [ "${removed}" == "${remove_param}" ]; then
                  print_success "remove_one"
                  grep -F -v "${remove_param}" "${file_param}" > "${file_param}".tmp && mv "${file_param}".tmp "${file_param}"
                  exit_script
               else
                  print_error "remove"
                  exit_script
               fi
            else
               print_error "remove"
               exit_script
            fi
         fi
      else
        print_error "file_no_file"
        print_usage
        exit_script
      fi
   elif [ -n "${version_param}" ]; then
      # version mode
      print_version
       exit_script
   else
      print_error "mode"
      print_usage
      exit_script
   fi
else
   print_error "file_not_set"
   print_usage
   exit_script
fi

### end of script ###
