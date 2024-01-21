#!/bin/bash

#**************************************************************************
#   App:         Disk Desinfester                                         *
#   Version:     1.0                                                      *
#   Author:      Matia Zanella                                            *
#   Description: Disk Desinfester, aimed to be the first and most         *
#                complete linux maintenance program.                      *
#   Github:      https://github.com/akamura/                              *
#                                                                         *
#   Icon Author:        Kanin Abhiromsawat @Eucalyp                       *
#   Icon Author URL:    https://www.flaticon.com/authors/eucalyp          *
#   Icon Author Social: https://www.facebook.com/kanin.abhiromsawat       *
#                                                                         *
#   Copyright (C) 2024 Matia Zanella                                      *
#   https://www.matiazanella.com                                          *
#                                                                         *
#   This program is free software; you can redistribute it and/or modify  *
#   it under the terms of the GNU General Public License as published by  *
#   the Free Software Foundation; either version 2 of the License, or     *
#   (at your option) any later version.                                   *
#                                                                         *
#   This program is distributed in the hope that it will be useful,       *
#   but WITHOUT ANY WARRANTY; without even the implied warranty of        *
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
#   GNU General Public License for more details.                          *
#                                                                         *
#   You should have received a copy of the GNU General Public License     *
#   along with this program; if not, write to the                         *
#   Free Software Foundation, Inc.,                                       *
#   59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.             *
#**************************************************************************

clear

# ==================================================
# ANSI COLOR CODES
# ==================================================
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
MAGENTA='\033[1;35m'
CYAN='\033[1;36m'
NC='\033[0m'
BOLD='\033[1m'


# ==================================================
# Initialize variables to track maintenance status
# ==================================================
packages_updated=false
packages_upgraded=false
apps_installed=false
cleaned_up=false
kernels_removed=false
user_cache_cleared=false
log_files_cleaned=false
large_files_handled=false
dns_cache_flushed=false
maintenance_incomplete=false


# ==================================================
# Request privileges elevation
# ==================================================
echo -e "${CYAN}Let me elevate some privileges. I need to check every corner of your file system.${NC}"
if ! sudo -v; then
        echo -e "${YELLOW}Oh dear! I need the golden key to do my job! If you're feeling doubtful, feel free to inspect my code or give the competitors a ring! They may charge less, but they're less effective!${NC}"
    exit 1
fi


# ==================================================
# SYSTEM UPDATE AND UPGRADE
# ==================================================
for i in {1..2}; do echo; done #separator
echo -e "${CYAN}Updating package lists${NC}"
sudo apt-get update
packages_updated=true

for i in {1..2}; do echo; done #separator
echo -n -e "${MAGENTA}Do you want to upgrade installed packages? Yes [Y] - No [N]: ${NC}"
read answer
if [ "$answer" != "${answer#[Yy]}" ]; then
    sudo apt-get upgrade -y
    packages_upgraded=true
    else
    maintenance_incomplete=true
fi

for i in {1..2}; do echo; done #separator
echo -e "${CYAN}Updating Snap packages${NC}"
sudo snap refresh


# ==================================================
# INSTALL SOME USEFUL APPS
# ==================================================
for i in {1..2}; do echo; done #separator
echo -e "${CYAN}Installing useful applications like htop - iftop - iptraf${NC}"
sudo apt-get install htop iftop iptraf -y


# ==================================================
# CLEAN UP (Remove unused packages and clean cache)
# ==================================================
for i in {1..2}; do echo; done #separator
echo -e "${CYAN}Cleaning up unused packages and clearing cache${NC}"
sudo apt-get autoclean
sudo apt-get clean


# ==================================================
# REMOVE OLD KERNELS (Optional)
# ==================================================
for i in {1..2}; do echo; done #separator
echo -n -e "${MAGENTA}Do you want to remove old kernels? Yes [Y] - No [N]: ${NC}"
read answer
if [ "$answer" != "${answer#[Yy]}" ]; then
    sudo apt-get purge $(dpkg --list | grep '^rc' | awk '{print $2}') -y
    sudo apt-get autoremove -y
fi


# ==================================================
# REMOVE USER CACHE
# ==================================================
for i in {1..2}; do echo; done #separator
echo -e "${CYAN}Cleaning user cache files${NC}"
rm -rf ~/.cache/*


# ==================================================
# CLEANING LOG FILES
# ==================================================
for i in {1..2}; do echo; done #separator
echo -e "${CYAN}Cleaning old log files${NC}"
sudo find /var/log -type f -name "*.log" -exec truncate -s 0 {} \;


# ===================================================================================
# HUNT FOR HEAVYWEIGHT FILES (> 1GB) WHILE SPARING THE PRECIOUS .vmdk AND .qcow FILES
# ===================================================================================
for i in {1..2}; do echo; done #separator
echo -e "${CYAN}Embarking on a digital treasure hunt for hefty files (>1GB). No .vmdk or .qcow files will be harmed in this quest!${NC}"

file_list=$(mktemp)
find / -type f -size +1G ! -name "*.vmdk" ! -name "*.qcow" -exec du -h {} + 2>/dev/null | sort -hr > "$file_list"

# Check if the file list is empty
if [ ! -s "$file_list" ]; then
    echo -e "[${BOLD}${GREEN} SUCCESS ${NC}] Wow! Your disk is as clean as a whistle in a soap factory. No bulky files here!"
    rm "$file_list"
    # Continue with the script instead of exiting
else
    cat "$file_list"
    total_space_freed=$(awk '{sum += $1} END {print sum}' "$file_list")

    # Calculate total space occupied by the found files
    if [ -z "$total_space_freed" ] || (( $(echo "$total_space_freed < 1" | bc -l) )); then
        echo -e "[${BOLD}${GREEN} SUCCESS ${NC}] Hmm... Looks like someone already cleaned this floor. Nothing significant to clean here!"
        rm "$file_list"
        # Continue with the script
    else
        # Proceed to ask for deletion only if there is something substantial to clean
        echo -e "[${BOLD}${GREEN} SUCCESS ${NC}] Potential digital slimming space: ${total_space_freed}G. That's a lot of bytes to bite!"
        for i in {1..2}; do echo; done #separator
        echo -n -e "${MAGENTA}Fancy a digital declutter? Shall I vaporize these files (excluding the royal .vmdk and .qcow)? Yes [Y] - No [N]: ${NC}"
        read -r answer
        if [[ "$answer" =~ ^[Yy]$ ]]; then
            while IFS= read -r line; do
                file=$(echo "$line" | awk '{print $2}')
                rm -f "$file"
                echo -e "${BOLD}${GREEN}Poof! $file has vanished into thin air!${NC}"
            done < "$file_list"
            echo -e "${BOLD}${GREEN}All chosen files (sans .vmdk and .qcow) have been escorted off the premises.${NC}"
        else
            echo -e "${BOLD}${YELLOW}Change of heart? No problem. The files are throwing a no-deletion party!${NC}"
        fi
        rm "$file_list"
    fi
fi


# ==================================================
# NETWORK FLUSH (CLEAR AND RESTART NETWORK SERVICES)
# ==================================================
for i in {1..2}; do echo; done #separator
echo -e "${BOLD}${CYAN}Flushing DNS cache${NC}"
sudo resolvectl flush-caches
sudo systemctl restart systemd-resolved
sudo systemctl restart NetworkManager
echo -e "[${BOLD}${GREEN} SUCCESS ${NC}] DNS cache cleared and services restarted"
dns_cache_flushed=true


# ==================================================
# BUILD THE SUMMARY
# ==================================================
for i in {1..3}; do echo; done #separator
echo -e "${BOLD}${CYAN}HOUSEKEEPING SUMMARY${NC}"

# Function to colorize the status
colorize_status() {
    if [ "$1" = true ]; then
        echo -e "${GREEN}$1${NC}"
    else
        echo -e "${RED}$1${NC}"
    fi
}

echo "Packages Updated          [$(colorize_status $packages_updated)]"
echo "Packages Upgraded         [$(colorize_status $packages_upgraded)]"
echo "Applications Installed    [$(colorize_status $apps_installed)]"
echo "System Cleaned Up         [$(colorize_status $cleaned_up)]"
echo "Old Kernels Removed       [$(colorize_status $kernels_removed)]"
echo "User Cache Cleared        [$(colorize_status $user_cache_cleared)]"
echo "Log Files Cleaned         [$(colorize_status $log_files_cleaned)]"
echo "Large Files Handled       [$(colorize_status $large_files_handled)]"
echo "DNS Cache Flushed         [$(colorize_status $dns_cache_flushed)]"
for i in {1..3}; do echo; done #separator

if [ "$maintenance_incomplete" = true ]; then
    echo -e "${BOLD}${YELLOW}Oops! I couldn't finish the housekeeping task. Maybe your pc has some clutter or oversized files, but hey, at least your system isn't infested by DLL's hell!\033[0m"
else
    echo -e "${BOLD}${GREEN}All maintenance tasks completed successfully!${NC}"
fi


# ==================================================
# RETURN TO THE MAIN MENU
# ==================================================
for i in {1..3}; do echo; done #separator
echo -e "${BOLD}${GREEN}Press any key to return to the main menu.${NC}"
read -r -s -n 1
clear