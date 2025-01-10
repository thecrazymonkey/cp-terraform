#!/bin/bash
state=${1:-terraform}
auth=${2:-rbac}
ids=$(terraform show -json $state.tfstate | jq -r '.values.root_module.child_modules[].resources[]?.values.id? | match("i-.*") | .string')
aws ec2 start-instances --instance-ids $ids --no-cli-pager
sleep 10
terraform plan -var-file=$state.tfvars -state=$state.tfstate  -out $state
terraform apply -state=$state.tfstate  $state
sleep 10
sudo killall -HUP mDNSResponder
./pushhosts.sh $state
cd ~/git/cp-ansible-custom
#ansible-playbook -i ./$auth/$state.yml ./playbooks/start_all.yml -v
