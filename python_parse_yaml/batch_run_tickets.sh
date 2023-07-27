#!/bin/bash

###############
set -e

# Function to display error and exit
handle_error() {
    local syntax=$1
    echo -e "\033[0;31m Error: Command '$syntax' failed !!! \033[0m"
    exit 1
}

# Set the trap function to call handle_error function when a non-zero return code is given from any command
trap 'handle_error "$BASH_COMMAND"' ERR
###############

source data.sh
OLD_IFS=$IFS    ## internal field separator
export GREEN='\033[0;32m'
export RED='\033[0;31m'
export NOCOLOR='\033[0m'

## go to working dir
HOME_DIR=$(pwd)
mkdir -p Test_dir
TEST_DIR=$HOME_DIR/Test_dir
cd $TEST_DIR

# sudo rm -rf *  ## use this with care, will delete everything in the directory and sub-directories 

for data in "${dataset[@]}"; do
    IFS=','
    set $data
    ticket_id=$1
    path_to_yaml=$2
    folder_name=$3
    
    echo -e "${GREEN}Processing the following dataset:${NOCOLOR}"
    echo "TicketId: $ticket_id"
    echo "Path To Yaml: $path_to_yaml"
    echo "Customer Directory Name: $folder_name"

    ## create dir for each ticket (DR_ticketID_foldername_given)
    mkdir DR_${ticket_id}_${folder_name}
    cd DR_${ticket_id}_${folder_name}

    ## copy yaml in each dir
    #cp $path_to_yaml/*.yaml .
    cp $HOME_DIR/test.yaml .    ##sample file copy here


    ## run parser for each directory
    # ../../parser_script.py -i *.yaml -t ${ticket_id}
    ../../test_python_script.py -i *.yaml -t ${ticket_id}

    echo -e "${GREEN}Processed the previously listed dataset!!!${NOCOLOR}"
    echo
    cd ${TEST_DIR}

done
IFS=$OLD_IFS