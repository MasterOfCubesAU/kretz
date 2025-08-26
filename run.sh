#!/bin/bash
FILE_SUFFIX="*.vol"

# Define colours
RED='\033[0;31m'
GREEN='\033[0;32m'
NORMAL='\033[0m'

if [ $# -eq 1 ]; then
    BIN="$1"
    INPUT_DIR="./inputs"
    OUTPUT_DIR="./outputs"
    shift
else
    BIN="/kretz-programs-build/KretzConverter"
    INPUT_DIR="/kretz/inputs"
    OUTPUT_DIR="/kretz/outputs"
fi

# Check if there are any input files
if ! [ "$(ls -A "$INPUT_DIR")" ]; then
    echo -e "${RED}No input files found.${NORMAL}"
    exit 1
fi

# Establish what format to convert the files to
read -p "What file format would you like to convert to? " format

total_files=$(find "$INPUT_DIR" -name "*$FILE_SUFFIX"| wc -l)
count=1

# Find all input files and convert
for filepath in $(find "$INPUT_DIR" -name "*$FILE_SUFFIX"); do
    filename=$(basename "$filepath")
    if [ -z "$*" ]; then
        echo -en "(${count}/${total_files}) Converting ${CYAN}$filename${NORMAL} to ${CYAN}${filename%.vol}_bm.$format${NORMAL}..."
        if [ -f "${OUTPUT_DIR}/${filename%.vol}_bm.$format" ]; then
		echo -e "${NORMAL}SKIPPED${NORMAL}"
	else
		"$BIN" -i "$filepath" -o "${OUTPUT_DIR}/${filename%.vol}_bm.$format" -r 0.2 0.2 0.2 >/dev/null
		if [ "$?" -eq 0 ]; then
			echo -e "${GREEN}DONE${NORMAL}"
		else
		    echo -e "${RED}FAILED${NORMAL}"
		fi
    	fi
        
        
        echo -en "(${count}/${total_files}) Converting ${CYAN}$filename${NORMAL} to ${CYAN}${filename%.vol}_pd.$format${NORMAL}..."
         if [ -f "${OUTPUT_DIR}/${filename%.vol}_pd.$format" ]; then
		echo -e "${NORMAL}SKIPPED${NORMAL}"
	else
		"$BIN" -i "$filepath" -o "${OUTPUT_DIR}/${filename%.vol}_pd.$format" -r 0.2 0.2 0.2 -d >/dev/null
		if [ "$?" -eq 0 ]; then
			echo -e "${GREEN}DONE${NORMAL}"
		else
			echo -e "${RED}FAILED${NORMAL}"
		fi
	fi
	((count++))
    else
        "$BIN" -i "$filepath" -o "${OUTPUT_DIR}/${filename%.vol}.$format" "$@" >/dev/null
    fi
done
echo "Finished running volume conversion"
