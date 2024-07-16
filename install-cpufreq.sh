
sudo apt-get install -y linux-tools-common cpufrequtils
sudo apt-get install -y linux-tools-generic linux-cloud-tools-generic
sudo apt-get install -y linux-tools-$(uname -r) linux-cloud-tools-$(uname -r)

cpufreq-info
cpupower frequency-info
