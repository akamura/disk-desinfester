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


# ====================================================
# I NEED TO CHECK IF YOU HAVE ALL COMPONENTS INSTALLED
# ====================================================
check_and_install_mpstat() {
    if ! command -v mpstat &> /dev/null; then
        echo -e "${RED}mpstat could not be found. It is required for this script to run.${NC}"
        read -p "Would you like to install sysstat (which includes mpstat)? (y/n) " response
        if [[ "$response" =~ ^[Yy]$ ]]; then
            sudo apt-get install sysstat
            # Rerun the script after installation
            exec "$0"
        else
            echo "sysstat installation aborted. Exiting."
            exit 1
        fi
    fi
}

# Check if mpstat is available and prompt for installation if necessary
check_and_install_mpstat


# ==================================================
# CPU STATISTICS
# ==================================================
echo -e "${CYAN}CPU LOAD (UPTIME)${NC}"
    uptime


for i in {1..2}; do echo; done #separator
echo -e "${CYAN}TOP 5 CPU CONSUMING PROCESSES${NC}"
    ps -eo %cpu,%mem,comm --sort=-%cpu | head -n 6


for i in {1..2}; do echo; done #separator
echo -e "${CYAN}CPU USAGE PER CORE${NC}"
    if command -v mpstat &> /dev/null; then
        mpstat -P ALL 1 1
    fi


 for i in {1..2}; do echo; done #separator
    echo -e "${CYAN}SYSTEM ACTIVITY REPORT${NC}"
    vmstat


 for i in {1..2}; do echo; done #separator
    echo -e "${CYAN}I/O STATISTICS${NC}"
    if command -v iostat &> /dev/null; then
        iostat
    fi


# ==================================================
# RAM STATISTICS
# ==================================================
# Function to print header with border
print_header() {
    printf "+%-17s+%-9s+%-9s+%-9s+%-9s+%-14s+%-12s+\n" "-----------------" "--------" "--------" "--------" "--------" "-------------" "------------"
    printf "|%-17s|%-9s|%-9s|%-9s|%-9s|%-14s|%-12s|\n" " Type" "Total" "Used" "Free" "Shared" "Buff/Cached" "Available"
    printf "+%-17s+%-9s+%-9s+%-9s+%-9s+%-14s+%-12s+\n" "-----------------" "--------" "--------" "--------" "--------" "-------------" "------------"
}

# Function to print data with border
print_data() {
    local type=$1
    local total=$2
    local used=$3
    local free=$4
    local shared=$5
    local buff_cached=$6
    local available=$7
    printf "|%-17s|%-9s|%-9s|%-9s|%-9s|%-14s|%-12s|\n" "$type" "$total" "$used" "$free" "$shared" "$buff_cached" "$available"
}

# Function to color the output based on the percentage
color_output() {
    local percent=$1
    if (( percent > 70 )); then
        echo -ne "${GREEN}"
    elif (( percent >= 40 )); then
        echo -ne "${YELLOW}"
    else
        echo -ne "${RED}"
    fi
}

# Print header
for i in {1..2}; do echo; done #separator
echo -e "${CYAN}SYSTEM MEMORY SUMMARY${NC}"
for i in {1..1}; do echo; done #separator
print_header

# Get memory and swap data
read -r mem_type mem_total mem_used mem_free mem_shared mem_buff_cached mem_available <<< $(free -h | awk '/Mem:/ { printf "Mem %s %s %s %s %s %s", $2, $3, $4, $5, $6, $7 }')
read -r swap_type swap_total swap_used swap_free swap_shared swap_buff_cached swap_available <<< $(free -h | awk '/Swap:/ { printf "Swap %s %s %s", $2, $3, $4 }')

# Calculate the percentage of free memory and swap
mem_free_percent=$(free | awk '/Mem:/ { printf "%.0f", ($4/$2 * 100) }')
swap_free_percent=$(free | awk '/Swap:/ { printf "%.0f", ($4/$2 * 100) }')

# Color the output for memory and swap
mem_color=$(color_output $mem_free_percent)
swap_color=$(color_output $swap_free_percent)

# Print memory data with color
echo -ne "$mem_color"
print_data "$mem_type" "$mem_total" "$mem_used" "$mem_free" "$mem_shared" "$mem_buff_cached" "$mem_available"
echo -ne "$NC"
printf "+%-17s+%-9s+%-9s+%-9s+%-9s+%-14s+%-12s+\n" "-----------------" "--------" "--------" "--------" "--------" "-------------" "------------"

# Print swap data with color
echo -ne "$swap_color"
print_data "$swap_type" "$swap_total" "$swap_used" "$swap_free" "$swap_shared" "$swap_buff_cached" "$swap_available"
echo -ne "$NC"
printf "+%-17s+%-9s+%-9s+%-9s+%-9s+%-14s+%-12s+\n" "-----------------" "--------" "--------" "--------" "--------" "-------------" "------------"


# ==================================================
# RETURN TO THE MAIN MENU
# ==================================================
for i in {1..2}; do echo; done #separator
echo -e "${BOLD}${GREEN}Press any key to return to the main menu.${NC}"
read -r -s -n 1
clear