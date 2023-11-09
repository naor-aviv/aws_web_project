	#!/bin/bash
	yum update -y
	yum install MySQL-python -y
	yum install python3-devel mysql-devel -y
	cd /home/ec2-user
	aws s3 sync s3://${s3_name}/two-tiers-web-application/ ./
	pip3 install -r requirements.txt
	mv cred.tftpl cred.py
	python3 main.py
