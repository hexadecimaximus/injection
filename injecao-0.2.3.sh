#!/usr/bin/env bash

# generate a hash md5sum or sha256sum or sha512sum like "injection" to files
# Note: The "injection" to files is a file, with the hash of all files contained in the directory
#
#  Creator: Rodrigo (Seth) de Freitas
#  email: rodcesar.freitas@gmail.com
#  License: GPLv2
#  Version: 0.2.3

#choose your hash: md5sum, sha256sum or sha512sum
#default: sha256sum
HASH="sha256sum"

WORD="SUCESSO" #some distros use the word "SUCCESS", instead of ok. If your distro uses the word "SUCESS", just replace

# configure according to your Linux distro
# NOTE: some distro Linux do not have /bin and /sbin directories. In their place, there a link to /usr/bin and a link
# to /usr/sbin. If this your case, comment out the lines referring to the /bin and /sbin directories, so that a blank
# file is not generated, "dirtying" your system

#  +-----------------------------------------------------------------------------------------------------------------------------+
#  | This program is free software; you may redistribute it and/or modify it under the terms of the GNU General Public License   |
#  | as published by the Free Software Foundation; version 3 of the License, or (at your option) any later version.              |
#  |                                                                                                                             |
#  | This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty |
#  | of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.                |
#  |                                                                                                                             |
#  | See more in https://www.gnu.org/licenses/.                                                                                  |
#  +-----------------------------------------------------------------------------------------------------------------------------+

declare -r BIN="/bin"
declare -r ETC="/etc"
declare -r SBIN="/sbin"
declare -r USRBIN="/usr/bin"
declare -r USRSBIN="/usr/sbin"

#Check root user
if [ $EUID -ne 0 ]; then
        echo "You need to be root to execute this script"
elif [ $EUID -eq 0 ]; then
        echo "[ Main menu ]"
        echo "Do you want to do?"
        echo "[1] Create "injection" in files"
        echo "[2] Check integrity of hash"
        read CHOICE

       if [ $CHOICE -eq 1 ]; then
		find $BIN -type d -o -type l -o -type f -exec $HASH {} \; | tee ./.checksum-bin
		find $ETC -type d -o -type l -o -type f -exec $HASH {} \; | tee ./.checksum-etc
		find $SBIN -type d -o -type l -o -type f -exec $HASH {} \; | tee ./.checksum-sbin
		find $USRBIN -type d -o -type l -o -type f -exec $HASH {} \; | tee ./.checksum-usrbin
		find $USRSBIN -type d -o -type l -o -type f -exec $HASH {} \; | tee ./.checksum-usrsbin
      elif [ $CHOICE -eq 2 ]; then
            # Check the integrity of the checksum files
	    	$HASH -c ".checksum-bin" | grep -v $WORD
	   	$HASH -c ".checksum-etc" | grep -v $WORD
	   	$HASH -c ".checksum-sbin" | grep -v $WORD
	   	$HASH -c ".checksum-usrbin" | grep -v $WORD
	   	$HASH -c ".checksum-usrsbin" | grep -v $WORD
     fi
fi
