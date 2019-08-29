#!/bin/bash

# Initialize Kubernetes
echo "--- Initializing Kubernetes Vagrant Cluster"
echo 1 > /proc/sys/net/ipv4/ip_forward
sudo kubeadm init --apiserver-advertise-address=172.20.20.100 --pod-network-cidr=10.244.0.0/16

# Copy Kube admin config
echo "--- Copying kube admin config to Vagrant user .kube directory"
mkdir /home/vagrant/.kube
cp /etc/kubernetes/admin.conf /home/vagrant/.kube/config
sudo chown -R vagrant:vagrant /home/vagrant/.kube

# Deploy flannel network
echo "--- Deploy flannel network"
su - vagrant -c "kubectl create -f /vagrant/kube-flannel.yml"

# Generate Cluster join command
echo "--- Generating join command to /join.sh"
sudo kubeadm token create --print-join-command > /joincluster.sh
