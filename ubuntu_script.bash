# sed -i -e 's/\r$//' ./test_script.bash
# linuxify this script - head -1 ./test_script.bash
# Install fio and run the io tests for 2Gib and 5Gib.
sudo apt-get -y update
sudo apt-get -y install fio
sudo apt-get -y install ioping
fio --randrepeat=1 --ioengine=libaio --direct=1 --gtod_reduce=1 --name=test --filename=random_read_write.fio --bs=4k --iodepth=64 --size=2G --readwrite=randrw --rwmixread=75 | tee total_test.txt
rm random_read_write.fio
fio --randrepeat=1 --ioengine=libaio --direct=1 --gtod_reduce=1 --name=test --filename=random_read_write.fio --bs=4k --iodepth=64 --size=5G --readwrite=randrw --rwmixread=75 | tee -a total_test.txt
rm random_read_write.fio
# ioping disk latency test
ioping -c 20 . | tee -a ./total_test.txt
# Install passmark tests
curl https://www.passmark.com/downloads/pt_linux_x64.zip --output passmark.zip
sudo apt install -y unzip
unzip ./passmark.zip
./pt_linux_x64 -p 1 -i 1 -d 1 -r 3
cat ./results_all.yml >> ./total_test.txt
