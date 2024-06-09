#!/bin/bash

user=$1
password=$2
suffix=$3
pub_key_path="~/.ssh/id_rsa.pub"
priv_key_path="~/.ssh/id_rsa"
resource_group="vpn_nodes"
location_list="japaneast westus2 southeastasia westus3 italynorth australiaeast"

if [ "$1" = "remove" ] || [ "$1" = "init" ]; then
  echo "Removing existing resource group $resource_group..."
  az group delete --name $resource_group --yes 
fi

if [ "$1" = "init" ]; then
  echo "Creating resource group $resource_group..."
  az group create --name $resource_group --location westus2
  vm_list=$(az vm list -g $resource_group --output tsv --query "[].name")
  for location in $location_list
  do
    vm_name=$suffix$location
    if echo "$vm_list" | grep -q "$vm_name"; then
      echo "VM $vm_name already exists, skipping..."
      continue
    fi
    echo "Creating a VM in $location, named $vm_name..."
    az vm create -n $vm_name -g $resource_group --image Ubuntu2204 --public-ip-address-dns-name $vm_name --size Standard_B1s --location $location --ssh-key-values $pub_key_path --admin-username $user
  done

  for location in $location_list
  do
    vm_name=$suffix$location
    if ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i $priv_key_path $user@$vm_name.$location.cloudapp.azure.com test -e vpn.sh
    then
      echo "VPN already setup on $vm_name, skipping..."
      continue
    fi
    echo "Downloading vpn.sh to $vm_name..."
    ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i $priv_key_path $user@$vm_name.$location.cloudapp.azure.com wget https://get.vpnsetup.net -O vpn.sh
    echo "Running vpn.sh on $vm_name..."
    ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i $priv_key_path $user@$vm_name.$location.cloudapp.azure.com sudo VPN_IPSEC_PSK=$password VPN_USER=$user VPN_PASSWORD=$password sh vpn.sh
  done

  echo "Opening ports 500 and 4500 on all VPN nodes..."
  az vm open-port --ids $(az vm list -g $resource_group --query "[].id" -o tsv) --port 500,4500
  echo "VPN nodes created successfully!"
  az vm list-ip-addresses --resource-group $resource_group --output table
fi

if [ "$1" = "reset" ]; then
  vm_list=$(az vm list -g $resource_group --output tsv --query "[].name")
  for location in $location_list
  do
    vm_name=$suffix$location
    vm_nic_name=$suffix$location"VMNic"
    vm_ip_name=$suffix$location"PublicIP"
    ip_config_name="ipconfig"$suffix$location
    if echo "$vm_list" | grep -q "$vm_name"; then
      az network nic ip-config update --name $ip_config_name --resource-group $resource_group --nic-name $vm_nic_name --public-ip-address null
      az network public-ip delete -g $resource_group -n $vm_ip_name
      az network public-ip create --name $vm_ip_name --resource-group $resource_group --location $location --dns-name $vm_name
      az network nic ip-config update --name $ip_config_name --nic-name $vm_nic_name --resource-group $resource_group --public-ip-address $vm_ip_name
    fi
  done
fi
