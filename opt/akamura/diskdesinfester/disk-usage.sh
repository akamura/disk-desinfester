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

# Print header
for i in {1..1}; do echo; done #separator
echo -e "${CYAN}System Disk Summary${NC}"
for i in {1..1}; do echo; done #separator

# Function to determine color based on used percentage
color_output() {
    local used_percent=${1%?}  # Remove the '%' character

    if (( used_percent < 50 )); then
        echo -e "\e[32m" # Green
    elif (( used_percent >= 50 && used_percent < 70 )); then
        echo -e "\e[33m" # Yellow
    else
        echo -e "\e[31m" # Red
    fi
}

# Calculate the maximum width for the Filesystem and Mounted on columns
max_fs_width=$(df -h | awk '{print length($1)}' | sort -nr | head -n 1)
max_mounted_width=$(df -h | awk '{print length($6)}' | sort -nr | head -n 1)
max_fs_width=$(( max_fs_width > 12 ? max_fs_width : 12 ))  # Ensure a minimum width for Filesystem
max_mounted_width=$(( max_mounted_width > 10 ? max_mounted_width : 10 ))  # Ensure a minimum width for Mounted on

# Define fixed widths for Size, Used, Avail, and Use% columns
size_width=6
used_width=6
avail_width=6
usep_width=6

# Function to provide summary based on disk usage
provide_summary() {
    if (( max_used < 50 )); then
        for i in {1..1}; do echo; done #separator
        echo -e "Everything looks good here. Let's move on. [ ${BOLD}${GREEN}TASK COMPLETED${NC} ] "
    else
        for i in {1..1}; do echo; done #separator
        echo -e "${BOLD}${RED}Wow, it looks like your PC has quite the infestation! Let me see if I can assist in cleaning this up for you.${NC}"
        read -p "Do you want to proceed? (yes/no) " response
        if [[ $response == "yes" ]]; then
            echo "Proceeding with further steps..."
            # Still in development further steps will be done later
        else
            echo "Operation aborted. Exiting."
            exit 0
        fi
    fi
}

# Function to create a dynamic horizontal border
print_border() {
    total_width=$(( max_fs_width + size_width + used_width + avail_width + usep_width + max_mounted_width + 17 )) # 17 for column separators and spaces
    printf "+"
    for ((i=0; i<total_width; i++)); do printf "-"; done
    printf "+\n"
}

# Print header with dynamic width
print_border
printf "| %-$((${max_fs_width}))s | %-$((${size_width}))s | %-$((${used_width}))s | %-$((${avail_width}))s | %-$((${usep_width}))s | %-$((${max_mounted_width}))s |\n" "Filesystem" "Size" "Used" "Avail" "Use%" "Mounted on"
print_border

# Process each line of df -h output
df -h | awk 'NR>1 {print}' | while read -r line; do
    filesystem=$(echo "$line" | awk '{print $1}')
    size=$(echo "$line" | awk '{print $2}')
    used=$(echo "$line" | awk '{print $3}')
    avail=$(echo "$line" | awk '{print $4}')
    usep=$(echo "$line" | awk '{print $5}')
    mounted=$(echo "$line" | awk '{print $6}')

    # Determine the color
    color=$(color_output "$usep")
    echo -n -e "$color"

    # Print the formatted line with dynamic width for the filesystem and mounted on
    printf "| %-$((${max_fs_width}))s | %-$((${size_width}))s | %-$((${used_width}))s | %-$((${avail_width}))s | %-$((${usep_width}))s | %-$((${max_mounted_width}))s |\n" "$filesystem" "$size" "$used" "$avail" "$usep" "$mounted"

    # Reset to default color
    echo -e "\e[0m"
done

print_border
provide_summary


# ==================================================
# RETURN TO THE MAIN MENU
# ==================================================
for i in {1..2}; do echo; done #separator
echo -e "${BOLD}${GREEN}Press any key to return to the main menu.${NC}"
read -r -s -n 1
clear