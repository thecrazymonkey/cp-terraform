#!/bin/bash
ids=$(terraform show -json | jq -r '.values.root_module.child_modules[].resources[]?.values.id? | match("i-.*") | .string')
aws ec2 stop-instances --instance-ids $ids
