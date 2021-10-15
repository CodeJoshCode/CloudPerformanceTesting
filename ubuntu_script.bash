#!/bin/bash
# sed -i -e 's/\r$//' ./test_script.bash
# ^to linuxify this script - head -1 ./test_script.bash

# generate results file name
start=`date +%s`
location=/root/testing/CloudPerformanceTesting/
results_file=$location"$start".txt

# install fio and run the io tests for 2Gib and 5Gib.
sudo apt-get -y update
sudo apt-get -y install fio
sudo apt-get -y install ioping

# time first test
start=`date +%s`
# first nonsequential rw test 2G
fio --randrepeat=1 --ioengine=libaio --direct=1 --gtod_reduce=1 --name=test --filename=random_read_write.fio --bs=4k --iodepth=64 --size=2G --readwrite=randrw --rwmixread=75 | tee $results_file
rm random_read_write.fio
# finish collecting runtime
end=`date +%s`
test_1_runtime=$((end-start))
echo "fio test 1 runtime: $test_1_runtime" >> $results_file

# time second test
start=`date +%s`
# second nonsequential rw test 5G
fio --randrepeat=1 --ioengine=libaio --direct=1 --gtod_reduce=1 --name=test --filename=random_read_write.fio --bs=4k --iodepth=64 --size=5G --readwrite=randrw --rwmixread=75 | tee -a $results_file
rm random_read_write.fio
# finish collecting runtime
end=`date +%s`
test_2_runtime=$((end-start))
echo "fio test 2 runtime: $test_2_runtime" >> $results_file

# time disk latency test
start=`date +%s`
# ioping disk latency test
ioping -c 20 . | tee -a $results_file
# finish collecting runtime
end=`date +%s`
test_3_runtime=$((end-start))
echo "disk latency test 3 runtime: $test_3_runtime" >> $results_file

# Install passmark tests
curl https://www.passmark.com/downloads/pt_linux_x64.zip --output passmark.zip
sudo apt install -y unzip
unzip -y ./passmark.zip

# time passmark tests
start=`date +%s`
# collect CPU/Mem performance data
./pt_linux_x64 -p 1 -i 1 -d 1 -r 3
cat ./results_all.yml >> $results_file
# finish collecting runtime
end=`date +%s`
test_4_runtime=$((end-start))
echo "passmark test 4 runtime: $test_4_runtime" >> $results_file
