#!/bin/bash

##########################
# https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/
# The tasks below were formed from the kubernetes docs
##########################
echo "--- Beginning K8s Master Node Setup"

USERNAME="kubeadmin"
PASSWORD="root"

# Update the hosts file
echo "--- Updating /etc/hosts file"
sudo cat >>/etc/hosts <<EOF
172.20.20.100 master.example.com master
172.20.20.101 worker1.example.com worker1
172.20.20.102 worker2.example.com worker2
EOF

# Packages
echo "--- Installing nessesary libs and packages"
sudo apt-get install apt-transport-https curl -y

# Installing container runtime -- Docker CE
echo "--- Installing docker"
sudo apt remove docker docker-engine docker.io
sudo apt install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt install docker-ce -y

# Setup daemon.
sudo cat >/etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF
mkdir -p /etc/systemd/system/docker.service.d
# Restart docker.
sudo systemctl daemon-reload
sudo systemctl restart docker

# Enable docker service
echo "--- Enable and start docker service"
sudo systemctl start docker
sudo systemctl enable docker

# Disable swap
echo "--- Disabling swap"
sudo sed -i '/swap/d' /etc/fstab
sudo swapoff -a

# Install Kubernetes
echo "--- Installing Kubernetes"
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add
sudo apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"
sudo apt-get install kubeadm -y

# Start kubelet service
echo "--- Enable and start kubelet service"
sudo systemctl enable kubelet
sudo systemctl start kubelet

# Enable ssh password authentication
echo "--- Enable ssh password authentication"
sudo sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
sudo systemctl reload sshd

# Set Root password
echo "Set password"
if id -u "$USERNAME" >/dev/null 2>&1; then
    userdel -r -f $USERNAME
    useradd -m -p $PASSWORD -s /bin/bash $USERNAME
    usermod -a -G sudo $USERNAME
    echo $USERNAME:$PASSWORD | chpasswd

else
    useradd -m -p $PASSWORD -s /bin/bash $USERNAME
    usermod -a -G sudo $USERNAME
    echo $USERNAME:$PASSWORD | chpasswd
fi