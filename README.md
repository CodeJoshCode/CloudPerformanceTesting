# CloudPerformanceTesting
Script to test the performance of a cloud instance. Testing IOPS, Disk Latency, memory and CPU performance.

Currently available for Debian based linux instances, tested on Ubuntu 18.04.

## Usage
1. Clone the repo. git clone https://github.com/CodeJoshCode/CloudPerformanceTesting.git

2. Make a file called credentials.txt with three lines:
USER=nextcloud-username
PWD=nextcloud-password
results_file_location_nextcloud=nextcloud-folder-location
TODO: examples

3. Run the script and the results will appear in a file labeled with a unix timestamp of when the test ran.

That's all!
My next steps are getting output options such as csv, command parameters to tweak the tests, and writing/testing scripts for other Operating Systems.
TODO: Make the timer output readable dates/times.

Cheers,
Josh
