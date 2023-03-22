#!/bin/bash

echo "[TASK 1] Pull required containers"
kubeadm config images pull >/dev/null 2>&1

echo "[TASK 2] Initialize Kubernetes Cluster"
kubeadm init --apiserver-advertise-address=192.168.56.10  --pod-network-cidr=10.244.0.0/16 >> /root/kubeinit.log 2>/dev/null

echo "[TASK 3] Deploy Calico network"
kubectl --kubeconfig=/etc/kubernetes/admin.conf create -f https://docs.projectcalico.org/v3.25/manifests/calico.yaml >/dev/null 2>&1
mkdir /home/vagrant/.kube
cp /etc/kubernetes/admin.conf /home/vagrant/.kube/config
chown -R vagrant:vagrant /home/vagrant/.kube

echo "[TASK 4] Generate and save cluster join command"
kubeadm token create --print-join-command > /home/vagrant/kubeadm_token.txt