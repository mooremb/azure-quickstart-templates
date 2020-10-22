

#!/bin/bash
# $1 = Azure storage account name
# $2 = Azure storage account key
# $3 = Azure file share name
# $4 = mountpoint path
# $5 - username

# For more details refer to https://azure.microsoft.com/en-us/documentation/articles/storage-how-to-use-files-linux/

# update package lists
sudo apt-get -y update

# install cifs-utils and mount file share
sudo apt-get install cifs-utils
mkdir -p $4
#sudo mount -t cifs //$1.file.core.windows.net/$3 $4 -o vers=3.0,username=$1,password=$2,dir_mode=0777,file_mode=0666
sudo mkdir $4
if [ ! -d "/etc/smbcredentials" ]; then
sudo mkdir /etc/smbcredentials
fi
if [ ! -f "/etc/smbcredentials/vimstoradrplmrkt001.cred" ]; then
    sudo bash -c 'echo "username=$5" >> /etc/smbcredentials/$5.cred'
    sudo bash -c 'echo "password=$2" >> /etc/smbcredentials/$5.cred'
fi
sudo chmod 600 /etc/smbcredentials/$5.cred

sudo bash -c 'echo "//$1.file.core.windows.net/drupalvmfileshare $4 cifs nofail,vers=3.0,credentials=/etc/smbcredentials/$1.cred,dir_mode=0777,file_mode=0777,serverino" >> /etc/fstab'
sudo mount -t cifs //$1.file.core.windows.net/drupalvmfileshare $4 -o vers=3.0,credentials=/etc/smbcredentials/$1.cred,dir_mode=0777,file_mode=0777,serverino

# create a symlink from /mountpath/xxx to ~/username/xxx
linkpoint=`echo $4 | sed 's/.*\///'`
eval ln -s $4 ~/$5/$linkpoint

# create marker files for testing
echo "hello from $HOSTNAME" > $5/$HOSTNAME.txt



