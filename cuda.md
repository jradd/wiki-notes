svn co http://trac.aircrack-ng.org/svn/branch/aircrack-ng-cuda aircrack-ng-cuda 
Next we will build it like normal but it needs a few extra arguments 
root@bt~# cd aircrack-ng-cuda 
root@bt:~/aircrack-ng-cuda~#CUDA=true make 
root@bt:~/aircrack-ng-cuda~#make CUDA=true sqlite=true unstable=true install 
Test to ensure everything is working, run aircrack on the test wpa-psk capture file, with the 
included wordlist : 
root@bt~# cd src 
root@bt~# ./aircrack-ng  -p 1 ../test/wpa.cap  -w ../test/password.lst 
29
The -p switch is what adds the CUDA function to aircrack-ng. I have tested the tool and it does 
work but like I said its underdevelopment and could use some optimization. In my testing pyrit 
was still quite a bit faster however your milage may vary. 
Special thanks to Zermelo and fnord0 for testing and posting the results of this tool. 

===========================================================================================
CUDA:DEBIAN:WHEEZY
-------------------------------------------------------------------------------------------

Download:


https://developer.nvidia.com/cuda-downloads



Then run a permutation of the following commands as root.

apt-get install libcr-dev mpich2 mpich2-doc libglu1-mesa-dev libglu1-mesa 
apt-get install libglui-dev libxmu-dev libxi-dev linux-headers-`uname -r` 
apt-get install build-essential binutils gcc-4.6 g++-4.6 ld
cuda_5.0.35_linux_64_ubuntu11.10-1.run -extract=/root/



#Drop to a terminal to install the graphics driver
/etc/init.d/gdm3 stop
/root/devdriver_5.0_linux_64_304.54.run
/etc/init.d/gdm3 start

/root/cuda_5.0.35_linux_64_ubuntu11.10-1.run
/root/cuda-samples_5.0.35_linux.run
ln -s /usr/bin/gcc-4.6 /usr/local/cuda-5.0/bin/gcc
ldconfig /usr/local/cuda-5.0/lib64/

?????????????????????????????????
If you then want to install Theano:
sudo apt-get install python-numpy python-scipy python-dev python-pip python-nose g++ git libatlas3gf-base libatlas-dev
sudo pip install Theano
Add to ~/.bashrc
export LD_LIBRARY_PATH=/usr/local/cuda-5.0/lib64/
export THEANO_FLAGS=floatX=float32,device=gpu

=========================================================================================



The typical way to place these values in your environment is with the following commands:

export PATH=/usr/local/cuda-5.0/bin:$PATH
and

export LD_LIBRARY_PATH=/usr/local/cuda-5.0/lib:$LD_LIBRARY_PATH
for 32-bit operating systems, or

export LD_LIBRARY_PATH=/usr/local/cuda-5.0/lib:/usr/local/cuda-5.0/lib64:$LD_LIBRARY_PATH
for 64-bit operating systems.

To make such settings permanent, place them in ~/.bash_profile.