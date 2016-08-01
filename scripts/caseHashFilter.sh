#!/bin/bash

# LOCAL TESTING.
INPUT_FILE="../inputs/Bin3_hashes_clean_targetColumns_noHeadFileExt.csv";
SEARCH_DIR="../test_in";
RELOCATION_DIR="../test_out/";

# WRANGLER EXECUTION.
# INPUT_FILE="Bin3_hashes_clean_targetColumns_noHeadFileExt.csv";
# SEARCH_DIR=".";
# RELOCATION_DIR="/data/03325/jgentle/encompass/bsgam_cases_bin3_subset";

# cat $INPUT;
# echo $SEARCH_DIR/*;

# Iterate over input file.
getHashes () {
    for LINE in $(cat $INPUT_FILE); do
        # Process line.
        echo "Processing line: " $LINE;
    done;
}

# Iterate over directory.
getFiles () {
    for FILE in $SEARCH_DIR/*; do
        # Process file.
        echo "Located file named: " $FILE;
    done;
}

# Combine iterations and compare fies.
compareHash2File () {
    # Get hashes.
    for LINE in $(cat $INPUT_FILE); do
        # echo "Processing line: " $LINE;
        
        # Get files in dir.
        for FILE in $SEARCH_DIR/*; do
            # echo "Located file named: " $FILE;
            
            # Compare filename for hash.
            CASE=$(find $SEARCH_DIR -type d -name "*${LINE}*");
            # echo $CASE;

            # Filter out for empty matches.
            if [ -n "$CASE" ]; then
                
                # handle mathivn gdirs one at a time.
                for THIS_CASE in $CASE; do

                    # Filter for directories only.
                    if [ -d $THIS_CASE ]; then
                        echo $THIS_CASE;
                        # Copy the case folder to the new location.
                        cp -r $SEARCH_DIR/$THIS_CASE $RELOCATION_DIR;
                    fi;

                done;
            fi;
        done;
    done;
}

# getHashes
# getFiles
compareHash2File

# Succesful exit.
echo "Case data relocated based on input file list.";
echo "Goodbye.";
echo " ";
exit 0;
