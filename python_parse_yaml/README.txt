This script dir has 3 versions of batch data ticket processing.
1. batch_run_tickets.sh: 
    using yaml data in a bash file that is sourced to running script, the run of python scripts is sequential.
2. batch_run_tickets_json.sh: 
    using json data that needs to be provided when executing the script, the run of python scripts is sequential.
3. parallel_batch_run_tickets_json.sh: 
    using json data that needs to be provided when executing the script, the run of python scripts is parallel.

Json format is more readable and also can be directly integrated with curl output for webapi integration

Note:
Windows line ending characters might cause issues in linux. Run the following command to mitigate that error.
sed -i -e 's/\r$//' <script name>