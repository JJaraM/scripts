#!/bin/bash
#
# The following script allows you to start all the VMs simultaneously
#
# @author jonathan jara morales
# @since 2025-05-03

VM_LIST=(
  "lvub-dns-01" 
  "lvub-grf-01" 
  "lvub-prmt-01"
)

for vm in "${VM_LIST[@]}"; do
    VBoxManage startvm "$vm" --type headless &
done

wait
