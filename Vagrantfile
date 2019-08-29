# -*- mode: ruby -*-

ENV['VAGRANT_NO_PARALLEL'] = 'yes'

Vagrant.configure(2) do |config|

  #Setup.sh runs on all nodes being provisioned
  config.vm.provision "shell", path: "./scripts/setup.sh"

  # Kubernetes Master Node
  config.vm.define "master" do |master|
    master.vm.box = "bento/ubuntu-18.04" 
    master.vm.hostname = "master.example.com"
    master.vm.network "private_network", ip: "172.20.20.100"
    master.vm.provider "virtualbox" do |v|
      v.name = "master"
      v.cpus = 2 # A min of 2 cpus are required for master (https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#before-you-begin)
      v.memory = 2048 
    end
    master.vm.provision "shell", path: "./scripts/k8smaster.sh"
  end
    
  # Kubernetes Worker Node Count
  WorkerNodes = 2

  (1..WorkerNodes).each do |i|
    config.vm.define "worker#{i}" do |worker|
      worker.vm.box = "bento/ubuntu-18.04"
      worker.vm.hostname = "worker#{i}.example.com"
      worker.vm.network "private_network", ip: "172.20.20.10#{i}"
      worker.vm.provider "virtualbox" do |v|
        v.name = "worker#{i}"
        v.cpus = 1
        v.memory = 1024
      end
      worker.vm.provision "shell", path: "./scripts/k8sworker.sh"
    end
  end

end