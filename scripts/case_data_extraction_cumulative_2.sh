#!/bin/bash

inputFile="outputVOL.fullpath.txt";
logFile="case_data_extraction.log";
cwd=$PWD;
start_time=$(date +"%r");

if [ ! -f $logFile ]; then
    # echo "File not found!"
    touch $logFile
fi

echo ' ' >> $logFile
echo '=== Job Execution Log ===' >> $logFile;
echo 'Current working dir: ' ${cwd} >> $logFile;
echo 'Extraction start time: ' ${start_time} >> $logFile;
echo ' ' >> $logFile;
echo 'Starting case data extraction process...' >> $logFile;
echo ' ' >> $logFile;

# Parse the contents of the output.dat files.
while IFS='' read -r line || [[ -n "$line" ]]; do

    path=${line%output.dat};
    datpath=${path}outputVOL.dat;
    
    echo '---------------------------------------------------' >> $logFile;
    echo 'Extracting data from target case dir path: ' ${path} >> $logFile;
    echo 'Target case data input file path: ' ${line} >> $logFile;
    echo 'Target case data output path: ' ${datpath} >> $logFile;
    echo 'Data extraction in progress...' >> $logFile;

    # Extract the cumulative section at the end.
    if [ -f $line ]; then
        echo '-- case data input file found: ' ${line} >> $logFile;
        grep -a -A 40 -e "VOLUMETRIC.*12.*120" $line > $datpath;
    else
        echo '-- case data input file ' ${line} ' not found. Skipping.' >> $logFile;
    fi

    # Extract the cumulative section at the end.
    #grep -a -A 40 -e "VOLUMETRIC.*12.*120" $line > "${path}outputVOL.dat";
    # grep -a -A 40 -e "VOLUMETRIC.*12.*120" $line > ${datpath};

    echo 'Case data extraction on target completed.' >> $logFile;
    echo ' ' >> $logFile;

done < $inputFile;

end_time=$(date +"%r");

echo 'All case data has been extracted.' >> $logFile;
echo ' ' >> $logFile;
echo 'Extraction end time: ' ${end_time} >> $logFile;
echo '=========================' >> $logFile;
echo ' ' >> $logFile;
