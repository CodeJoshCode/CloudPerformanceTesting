#!/bin/bash

# get credentials
. "$(dirname "$0")"/credentials.txt

# generate results file name
start=`date +%m_%d_%y__%H_%M%P`
location=$(pwd)
results_file_location=$location"$start".txt
results_file="$start.txt"

# install fio and run the io tests for 2Gib and 5Gib.
sudo apt-get -y update
sudo apt-get -y install fio
sudo apt-get -y install ioping

# time first test
start=`date +%s`
# first nonsequential rw test 2G
fio --randrepeat=1 --ioengine=libaio --direct=1 --gtod_reduce=1 --name=test --filename=random_read_write.fio --bs=4k --iodepth=64 --size=2G --readwrite=randrw --rwmixread=75 | tee $results_file_location
rm random_read_write.fio
# finish collecting runtime
end=`date +%s`
test_1_runtime=$((end-start))
echo "fio test 1 runtime: $test_1_runtime" >> $results_file_location

# time second test
start=`date +%s`
# second nonsequential rw test 5G
fio --randrepeat=1 --ioengine=libaio --direct=1 --gtod_reduce=1 --name=test --filename=random_read_write.fio --bs=4k --iodepth=64 --size=5G --readwrite=randrw --rwmixread=75 | tee -a $results_file_location
rm random_read_write.fio
# finish collecting runtime
end=`date +%s`
test_2_runtime=$((end-start))
echo "fio test 2 runtime: $test_2_runtime" >> $results_file_locatione

# time disk latency test
start=`date +%s`
# ioping disk latency test
ioping -c 20 . | tee -a $results_file_location
# finish collecting runtime
end=`date +%s`
test_3_runtime=$((end-start))
echo "disk latency test 3 runtime: $test_3_runtime" >> $results_file_location

# Install passmark tests
curl https://www.passmark.com/downloads/pt_linux_x64.zip --output passmark.zip
sudo apt install -y unzip
unzip -o ./passmark.zip

# time passmark tests
start=`date +%s`
# collect CPU/Mem performance data
./pt_linux_x64 -p 1 -i 1 -d 1 -r 3
cat ./results_all.yml >> $results_file_location
# finish collecting runtime
end=`date +%s`
test_4_runtime=$((end-start))
echo "passmark test 4 runtime: $test_4_runtime" >> $results_file_location


# Send to NextCloud (TODO: Make optional with credentials file a required paramenter.
# In case of failure, save test results locally)
curl -u $USER:$PWD "$results_file_location_nextcloud$results_file" -X PUT -H "Content-Type:text/plain" --data-binary "@$results_file_location"
