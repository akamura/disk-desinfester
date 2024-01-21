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

echo "Checking for any failed system services."
systemctl --failed


# ==================================================
# RETURN TO THE MAIN MENU
# ==================================================
for i in {1..2}; do echo; done #separator
echo -e "${BOLD}${GREEN}Press any key to return to the main menu.${NC}"
read -r -s -n 1
clear