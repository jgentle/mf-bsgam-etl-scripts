#!/bin/bash


##############################################
# Variables.
##############################################
# logFile="case_data_extraction.log";
# cwd=$PWD;
# start_time=$(date +"%r");

outputFile="../outputs/case_subsetting_output.log";
inputCleaned_commentsOnly="../inputs/Bin3_hashes_clean_commentsOnly.csv";
inputCleaned_noComments="../inputs/Bin3_hashes_clean_noComments.csv";
inputCleaned_noHeaders="../inputs/Bin3_hashes_clean_noHeaders.csv";
inputCleaned_dataOnly="../inputs/Bin3_hashes_clean_dataOnly.csv";
inputConverted_csv2tsv="../inputs/Bin3_hashes_convertedCsv.tsv";
inputConverted_tsv2csv="../inputs/Bin3_hashes_convertedTsv.csv";
inputExtracted_targetColumns="../inputs/Bin3_hashes_clean_targetColumns.csv";
inputFile="../inputs/Bin3_hashes.csv";
# inputFile="../inputs/inputTsv.tsv";
# inputFile=$inputConverted_csv2tsv;
iteratorValue=50;
targetColumns=1;  #1-4;
inputExtracted_targetColumns_noFileExt="../inputs/Bin3_hashes_clean_targetColumns_noFileExt.csv";
inputExtracted_targetColumns_noHeadFileExt="../inputs/Bin3_hashes_clean_targetColumns_noHeadFileExt.csv";

##############################################
# Functions.
##############################################

# File Inspection.
##############################################

# List all the lines in a csv:
listLines () {
    echo " ";
    echo "Contents of $inputFile:";
    echo " ";
    grep -v "^#" $inputFile;
    echo " ";
}

# Get line count for file:
lineCount () {
    echo " ";
    echo "Number of lines in $inputFile: ";
    grep -v "^#" $inputFile | wc -l;
    echo " ";
}

# File Cleanup.
##############################################

# Pipe output into a new file (clobber):
pipeLinesClobber () {
    echo " ";
    echo "Writing $inputFile to $outputFile... ";
    echo " ";
    grep -v "^#" $inputFile > $outputFile;
}

# Pipe output into a new file (append):
pipeLinesAppend () {
    echo " ";
    echo "Appending $inputFile to $outputFile... ";
    echo " ";
    grep -v "^#" $inputFile >> $outputFile;
}

# Get number of comments from csv:
numberComments () {
    echo " ";
    echo "Number of comments in $inputFile... ";
    echo " ";
    grep "#" $inputFile | wc -l;
}

# Print comments from csv:
printComments () {
    echo " ";
    echo "Comments in $inputFile... ";
    echo " ";
    cat $inputFile | grep "#";
}

# Get number of data rows:
numberDataRows () {
    echo " ";
    echo "Number of data rows in $inputFile... ";
    echo " ";
    cat $inputFile | grep -v "^#" | sed "1 d" | wc -l;
}

# Get the number of data columns:
# If more than one number is returned, there is some variation in the 
# number of records per line in the file.
numberDataCols () {
    echo " ";
    echo "Number of data columns in $inputFile... ";
    echo " ";
    cat $inputFile | grep -v "^#" | awk "{print NF}" FS=, | uniq;
}

# File Conversion.
##############################################

# Convert Csv to Tsv:
csv2tsv () {
    echo " ";
    echo "Converting $inputFile to tsv... ";
    echo " ";
    cat $inputFile | tr "," "\\t" > $inputConverted_csv2tsv
}

# Convert Tsv to Csv:
tsv2csv () {
    echo " ";
    echo "Converting $inputFile to csv... ";
    echo " ";
    cat $inputFile | tr "\\t" "," > $inputConverted_tsv2csv
}

# Query Files.
##############################################

# View the intial 10 lines in the file:
getHead () {
    echo " ";
    echo "The first 10 lines of the $inputFile: ";
    echo " ";
    head $inputFile;
}

# View a specific intial number of lines in the file:
getSpecificHead () {
    echo " ";
    echo "The first ${1} lines of the $inputFile: ";
    echo " ";
    head -n $1 $inputFile;
}

# Extract Data.
##############################################

# Extract comments from csv:
extractComments () {
    echo " ";
    echo "Extracting comments from $inputFile... ";
    echo " ";
    grep "#" $inputFile > $inputCleaned_commentsOnly;
}


# Remove comments from csv:
removeComments () {
    echo " ";
    echo "Removing comments from $inputFile... ";
    echo " ";
    grep -v "^#" $inputFile > $inputCleaned_noComments;
}

# Remove headers from csv:
removeHeaders () {
    echo " ";
    echo "Removing headers from $inputFile... ";
    echo " ";
    cat $inputFile | sed "1 d" > $inputCleaned_noHeaders;
}

# Extract only data from csv:
dataOnly () {
    echo " ";
    echo "Extractng data only from $inputFile... ";
    echo " ";
    cat $inputFile | grep -v "^#" | sed "1 d" > $inputCleaned_dataOnly;
}

# Extract Columns:
# The -f argument can take a single column number or a 
# comma-separated list of numbers and ranges.
extractColumn () {
    echo " ";
    echo "Extractng data from column ${targetColumns} in $inputFile... ";
    echo " ";
    cut -d , -f $1 $inputFile > $inputExtracted_targetColumns;
}

# Extract column and trim file extension:
extractColumnNoExt () {
    echo " ";
    echo "Extractng data from column ${targetColumns} in $inputFile and trimming file extension... ";
    echo " ";
    cat $inputFile | cut -d , -f $1 | cut -c -32 > $inputExtracted_targetColumns_noFileExt;
}

# Extract column, strip headers and trim file extension:
extractColumnNoHeadExt () {
    echo " ";
    echo "Extractng data from column ${targetColumns} in $inputFile and trimming file extension... ";
    echo " ";
    cat $inputFile | cut -d , -f $1 | sed "1 d" | cut -c -32 > $inputExtracted_targetColumns_noHeadFileExt;
}

##############################################
# Invocations.
##############################################


# listLines
# lineCount
# pipeLinesClobber
# pipeLinesAppend
# numberComments
# printComments
# extractComments
# removeComments
# numberDataRows
# numberDataCols
# removeHeaders
# dataOnly
# csv2tsv
# tsv2csv
# getHead
# getSpecificHead $iteratorValue
# extractColumn $targetColumns

# extractColumnNoExt $targetColumns
extractColumnNoHeadExt $targetColumns