#!/bin/bash
state=${1:-terraform}
ids=$(terraform show -json $state.tfstate | jq -r '.values.root_module.child_modules[].resources[]?.values.id? | match("i-.*") | .string')
aws ec2 stop-instances --instance-ids $ids --no-cli-pager
