#!/bin/bash

# Assemble list of output.dat files to parse.
for f in *; do
    if [[ -d $f && ! -L "$f" ]]; then
        # $f is a directory, not a file or symlink.
        echo $f >> dir_list.dat;
        find . | grep "output.dat" > "outputVOL.txt";

        # # Parse the contents of the output.dat files.
        # # Extract the cumulative section at the end.
        # while IFS='' read -r line || [[ -n "$line" ]]; do
        #     pth=${line%output.dat};
        #     echo $pth
        #     grep -a -A 40 -e "VOLUMETRIC.*12.*120" $line > "${pth}outputVOL.dat";

        # done < "outputVOL.txt";

    fi
done
