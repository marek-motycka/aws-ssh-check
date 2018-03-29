#!/bin/bash

#try ssh as motycka to all instances

user="mmotycka"

for reg in $(aws ec2 describe-regions | jq '.Regions[].RegionName') ; do

	inst_list=$(aws ec2 describe-instances --region=eu-west-1 \
		| jq '.Reservations[].Instances[]')

	for ip in $(echo ${inst_list} | jq '.PublicIpAddress') ; do
		ssh ${user}@${ip} exit

		last=$?

		if [ ${last} -eq 0 ] ; then
			
		fi

	done


done


