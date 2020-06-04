#!/bin/bash
terraform output private_key > key.key
chmod 600 key.key

IP=$(terraform output public_ip)
echo """#!/bin/bash
ssh -i key.key ubuntu@$IP""" > scripts/ssh.sh
echo """#!/bin/bash
sftp -i key.key ubuntu@$IP""" > scripts/sftp.sh
chmod +x scripts/ssh.sh
chmod +x scripts/sftp.sh
