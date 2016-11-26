#!/bin/bash
# -*- Mode: sh; coding: utf-8; indent-tabs-mode: nil; tab-width: 4 -*-
#
# Authors:
#   Sam Hewitt <sam@snwh.org>
#
# Description:
#   A post-installation bash script for Raspbian
#
# Legal Preamble:
#
# This script is free software; you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation; version 3.
#
# This script is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
# details.
#
# You should have received a copy of the GNU General Public License along with
# this program; if not, see <https://www.gnu.org/licenses/gpl-3.0.txt>

# tab width
tabs 4
clear

#----- Import Functions -----#

dir="$(dirname "$0")"

. $dir/functions/check
. $dir/functions/cleanup
. $dir/functions/configure
. $dir/functions/favs
. $dir/functions/purge
. $dir/functions/thirdparty
. $dir/functions/update
. $dir/functions/upgrade
. $dir/functions/utilities

#----- Fancy Messages -----#
show_error(){
echo -e "\033[1;31m$@\033[m" 1>&2
}
show_info(){
echo -e "\033[1;32m$@\033[0m"
}
show_warning(){
echo -e "\033[1;33m$@\033[0m"
}
show_question(){
echo -e "\033[1;34m$@\033[0m"
}
show_success(){
echo -e "\033[1;35m$@\033[0m"
}
show_header(){
echo -e "\033[1;36m$@\033[0m"
}
show_listitem(){
echo -e "\033[0;37m$@\033[0m"
}

# Main
function main {
	eval `resize`
	MAIN=$(whiptail \
		--notags \
		--title "Raspbian Post-Install Script" \
		--menu "\nWhat would you like to do?" \
		--cancel-button "Quit" \
		$LINES $COLUMNS $(( $LINES - 12 )) \
		update		'Perform system update' \
		upgrade		'Upgrade Raspberry Pi firmware' \
		favs		'Install preferred applications' \
		utilities	'Install preferred system utilities' \
		thirdparty	'Install third-party applications' \
		configure	'Configure system' \
		cleanup		'Cleanup the system' \
		purge		'Remove unused pre-installed packages' \
		3>&1 1>&2 2>&3)
	 
	exitstatus=$?
	if [ $exitstatus = 0 ]; then
		$MAIN
	else
		quit
	fi
}

# Quit
function quit {
	if (whiptail --title "Quit" --yesno "Are you sure you want quit?" 10 60) then
		echo "Exiting..."
		show_info 'Thanks for using!'
		exit 99
	else
		main
	fi
}

#RUN
check_dependencies
while :
do
  main
done

#END OF SCRIPT