#!/bin/bash

###############
# Usage: ./batch_run_tickets_json.sh data.json
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

GREEN='\033[0;32m'
RED='\033[0;31m'
NOCOLOR='\033[0m'

## go to working dir
HOME_DIR=$(pwd)
readarray -t data_array < <(jq --compact-output '.[]' $1)

mkdir -p Test_dir
TEST_DIR=$HOME_DIR/Test_dir
cd $TEST_DIR

# sudo rm -rf *  ## use this with care, will delete everything in the directory and sub-directories

for data in "${data_array[@]}";do
    ticket_id=$(jq -r '.ticket_id' <<< $data)
    yaml_path=$(jq -r '.yaml_path' <<< $data)
    dir_name=$(jq -r '.dir_name' <<< $data)
    
    echo -e "${GREEN}Processing the following dataset:${NOCOLOR}"
    echo "TicketId: ${ticket_id}"
    echo "Path To Yaml: ${yaml_path}"
    echo "Customer Directory Name: ${dir_name}"

    ## create dir for each ticket (DR_ticketID_foldername_given)
    mkdir DR_${ticket_id}_${dir_name}
    cd DR_${ticket_id}_${dir_name}

    ## copy yaml in each dir
    #cp ${yaml_path}/*.yaml .
    cp $HOME_DIR/test.yaml .    ##sample file copy here


    ## run parser for each directory
    # ../../parser_script.py -i *.yaml -t ${ticket_id}
    ../../test_python_script.py -i *.yaml -t ${ticket_id}

    echo -e "${GREEN}Processed the previously listed dataset!!!${NOCOLOR}"
    echo
    cd ${TEST_DIR}

done