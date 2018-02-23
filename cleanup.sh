#!/bin/bash

sudo virsh net-destroy caasp-net
sudo virsh net-undefine caasp-net

function deleteVol {
  sudo virsh vol-delete $1 --pool default
}

function deleteDomain() {
  sudo virsh destroy $1
  sudo virsh undefine $1
}

deleteVol "caasp_admin.qcow2"
deleteVol "caasp_admin_cloud_init.iso"
deleteVol "caasp_master_0.qcow2"
deleteVol "caasp_master_cloud_init_0.iso"
deleteVol "caasp_worker_0.qcow2"
deleteVol "caasp_worker_1.qcow2"
deleteVol "caasp_worker_2.qcow2"
deleteVol "caasp_worker_cloud_init_0.iso"
deleteVol "caasp_worker_cloud_init_1.iso"
deleteVol "caasp_worker_cloud_init_2.iso"

deleteDomain "caasp_admin"
deleteDomain "caasp_master_0"
deleteDomain "caasp_worker_0"
deleteDomain "caasp_worker_1"
deleteDomain "caasp_worker_2"
