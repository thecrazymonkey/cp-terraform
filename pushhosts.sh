#!/bin/bash
#servers=$(<test)
servers=$(terraform output -json)
rm -f temp_hosts
touch temp_hosts
for x in `echo $servers | jq -r 'keys | .[]' | grep -v _ip`;
do
   length=$(echo $servers | jq -r ".${x}.value[] | length")
   counter=0
   while [ $counter -lt $length ];
   do
     line=$(echo $servers | jq -r ".${x}_ip.value[][${counter}],.${x}.value[][${counter}]" | tr '\n' ' ')
     echo ${line} >> temp_hosts
     counter=$(( $counter + 1 ))
   done
done
while read line; do
    host=$(echo $line | awk '{print $2}')
    all_hosts=$(cat temp_hosts)
    export all_hosts
    ssh -n -t -o SendEnv=all_hosts centos@$host 'echo "'"$all_hosts"'" | sudo tee -a /etc/hosts > /dev/null'
done < temp_hosts
rm -f temp_hosts
