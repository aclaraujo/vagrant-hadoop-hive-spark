#!/bin/bash
# https://docs.vagrantup.com/v2/provisioning/shell.html

source "/vagrant/scripts/common.sh"

function setupHosts {
	echo "modifying /etc/hosts file"
    echo "10.211.55.101 node1" >> /etc/nhosts
	echo "10.211.55.102 node2" >> /etc/nhosts
	echo "10.211.55.103 node3" >> /etc/nhosts
	echo "127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4" >> /etc/nhosts
	echo "::1         localhost localhost.localdomain localhost6 localhost6.localdomain6" >> /etc/nhosts
	#cat /etc/hosts >> /etc/nhosts
	cp /etc/nhosts /etc/hosts
	rm -f /etc/nhosts
}

function setupSwap {
    # setup swapspace daemon to allow more memory usage.
    apt-get install -y swapspace
}


function installSSHPass {
	apt-get update
	apt-get install -y sshpass
}

function overwriteSSHCopyId {
	cp -f $RES_SSH_COPYID_MODIFIED /usr/bin/ssh-copy-id
}

function createSSHKey {
	echo "generating ssh key"

	#check for private key for vm-vm comm
	[ -f /vagrant/id_rsa ] || {
  		ssh-keygen -t rsa -f /vagrant/id_rsa -q -N ''
	}

	[ -f ~/.ssh/id_rsa ] || {
    	cp /vagrant/id_rsa ~/.ssh/id_rsa
    	chmod 0600 ~/.ssh/id_rsa
	}

	#allow ssh passwordless
	grep 'root@node' ~/.ssh/authorized_keys &>/dev/null || {
  		cat /vagrant/id_rsa.pub >> ~/.ssh/authorized_keys
  		chmod 0600 ~/.ssh/authorized_keys
	}

	cp -f $RES_SSH_CONFIG ~/.ssh
}

function setupUtilities {
    # so the `locate` command works
    apt-get install -y mlocate
    updatedb
    apt-get install -y ant
    apt-get install -y unzip
    apt-get install -y python-minimal
}

echo "setup ubuntu"

echo "setup hosts file"
setupHosts

echo "setup ssh"
installSSHPass
createSSHKey
overwriteSSHCopyId

echo "setup utilities"
setupUtilities

echo "setup swap daemon"
setupSwap

echo "ubuntu setup complete"
