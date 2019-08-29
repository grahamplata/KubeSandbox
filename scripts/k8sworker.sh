#!/bin/bash

# Join node to the Kubernetes cluster
export SSHPASS=ry3AvbWO0oupYX9HCMzp0Axx

echo "--- Worker attempting to join Kubernetes Cluster"
sudo apt-get install sshpass -y
sudo sshpass -p 'root' scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -r kubeadmin@master.example.com:/joincluster.sh /joincluster.sh
sudo bash /joincluster.sh
