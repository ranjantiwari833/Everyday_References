#!/bin/bash

###############
# Usage: ./parallel_batch_run_tickets_json.sh data.json
###############
set -e

# Function to display error and exit
handle_error() {
    local syntax=$1
    echo -e "\033[0;31m Error: Command '$syntax' failed !!! \033[0m"
    # exit 1
}

# Set the trap function to call handle_error function when a non-zero return code is given from any command
trap 'handle_error "$BASH_COMMAND"' ERR
###############

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NOCOLOR='\033[0m'

# Check if the data.json file argument is provided
if [[ $# -lt 1 ]]; then
    echo "Usage: $0 <data.json>"
    exit 1
fi

# Store the data.json file name from the command-line argument
data_json="$1"

# Check if the data.json file exists
if [[ ! -f "$data_json" ]]; then
    echo "Error: $data_json not found."
    exit 1
fi

## go to working dir
HOME_DIR=$(pwd)
readarray -t data_array < <(jq --compact-output '.[]' $data_json)

mkdir -p Test_dir
TEST_DIR=$HOME_DIR/Test_dir
cd $TEST_DIR

sudo rm -rf *  ## use this with care, will delete everything in the directory and sub-directories

# background jobs PIDs in an array
pids=()

for data in "${data_array[@]}";do
    ticket_id=$(jq -r '.ticket_id' <<< $data)
    yaml_path=$(jq -r '.yaml_path' <<< $data)
    dir_name=$(jq -r '.dir_name' <<< $data)
    
    echo -e "${GREEN}Following dataset extracted:${NOCOLOR}"
    echo "TicketId: ${ticket_id}"
    echo "Path To Yaml: ${yaml_path}"
    echo "Customer Directory Name: ${dir_name}"

    ## create dir for each ticket (DR_ticketID_foldername_given)
    mkdir DR_${ticket_id}_${dir_name}
    cd DR_${ticket_id}_${dir_name}

    ## copy yaml in each dir
    #cp ${yaml_path}/*.yaml .
    cp $HOME_DIR/test.yaml .    ##sample file copy here
    sleep 2

    ## run parser for each directory
    # ../../parser_script.py -i *.yaml -t ${ticket_id}
    set +e
    ../../parallel_test_python_script.py -i *.yaml -t ${ticket_id} & pids+=($!)
    set -e

    echo -e "${GREEN}Started processing the dataset in background!!!${NOCOLOR}"
    echo
    cd ${TEST_DIR}

done

finished_pids=()

# While loop to continuously check if any background job is still running
while [[ ${#pids[@]} -gt 0 ]]; do
    # Array for unfinished PID of bg jobs
    unfinished_pids=()

    for pid in "${pids[@]}"; do
        # kill -0 sends a signal 0 to $pid which just checks if the process with given pid exists or not
        # the response is not given to terminal but to /dev/null. 
        # if process exists rc is 0, aka if conditional is true, otherwise the rc is 1 and if condition false.
        if kill -0 $pid 2>/dev/null; then
            echo -e "${YELLOW}Background job with PID $pid is still running.${NOCOLOR}"
            unfinished_pids+=($pid)
        else
            echo -e "${GREEN}Background job with PID $pid has finished.${NOCOLOR}"
            finished_pids+=($pid)
        fi
    done

    # Replaces the lits of active pids with unfinished bg job pids
    pids=("${unfinished_pids[@]}")
    
    echo "Unfinished Jobs: ${pids[@]}"
    echo "Finished Jobs: ${finished_pids[@]}"
    sleep 2
    echo
done

# Continue with the rest of the script after all jobs have finished
echo -e "${GREEN}All background jobs have finished.${NOCOLOR}"
