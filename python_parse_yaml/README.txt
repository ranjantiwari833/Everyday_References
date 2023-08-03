This script dir has 3 versions of batch data ticket processing.
1. using yaml data in a bash file that is sourced to running script, the run of python scripts is sequential.
2. using json data that needs to be provided when executing the script, the run of python scripts is sequential.
3. using json data that needs to be provided when executing the script, the run of python scripts is parallel.

Json format is more readable and also can be directly integrated with curl output for webapi integration