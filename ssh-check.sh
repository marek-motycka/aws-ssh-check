#!/bin/bash

#try ssh as motycka to all instances

user="mmotycka"
ssh_timeout="10"

echo "[[[$(date)]]]"
echo "[[[$(date)]]]" >&2

for reg in $(aws ec2 describe-regions | jq '.Regions[].RegionName') ; do

	inst_list=$(aws ec2 describe-instances --region=${reg} \
		| jq '.Reservations[].Instances[]')

	for ip_quoted in $(echo ${inst_list} | jq '.PublicIpAddress') ; do
		ip=$(echo ${ip_quoted} | tr -d '"')

		if [ ${ip} = 'null' ] ; then
			continue
		fi

		ssh -o 'ConnectTimeout '${ssh_timeout} -o 'KbdInteractiveAuthentication no' \
			-o 'BatchMode yes' ${user}@${ip} exit

		last=$?

		if [ ${last} -eq 0 ] ; then
			echo ${user}'@'${ip}': success'
			continue
		fi

		echo ${user}'@'${ip}': failure' >&2

	done

done


