#!/bin/bash

# Quick test script to see if ec2 recovery could be set up in conjunction with a bash script

instance_id=$(aws ec2 run-instances --region us-east-1 --key-name test --instance-type t2.micro --image-id ami-098bb5d92c8886ca1 --output text --query 'Instances[*].InstanceId')
echo $instance_id
sleep 30
aws cloudwatch put-metric-alarm --alarm-name "${instance_id} status_test" --alarm-description "Alarm when system status check fails for ${instance_id}" --metric-name StatusCheckFailed_System --namespace AWS/EC2 --statistic Maximum --period 60 --threshold 1 --comparison-operator GreaterThanOrEqualToThreshold  --dimensions "Name=InstanceId,Value=${instance_id}" --evaluation-periods 2 --alarm-actions arn:aws:automate:us-east-1:ec2:recover
