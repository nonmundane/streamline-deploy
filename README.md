# Streamline/MovieNight Deploy

A terraform 12.X based deploy for Streamline and MovieNight (https://github.com/zorchenhimer/MovieNight). MovieNight is just here for group chat
functionality and is going to get modified to use the Streamline CDN output for the video part. Consider this a WIP. Current version of this
does not deploy the live streaming aspect of Streamline on the EC2 server, but does create the Cloudfront CDN needed (along with an EC2 instance
to act as your origin server)

## Deploy
This Terraform assumes you already have the following setup in your AWS account:

* An AWS API key & secret key for Terraform to use to talk to the AWS API
* A DNS domain setup in Route53 to get a Zone ID for

## Why this exists
Terraform can build all of the things needed for a Streamline deploy, but the documentation for the CDN part is not exactly the best and relies on some things only documented in Github issues and various blog posts. The idea behind this is to enable users to easily spinup the infrastructure in AWS for ad-hoc streaming needs and to be torn down once no longer needed so the end user costs are contained to primarily the bandwidth transfer costs with Cloudfront CDN traffic

## What this does
Creates a Cloudfront CDN according to Streamline needs.
Creates a DNS A record in Route53 for the EC2 server
Creates a security group for the EC2 instance that allows: SSH, RTMP, HTTP, HTTPS inbound
Creates an EC2 spot instance to act as an origin server (look at scripts/install.sh to see what is being done via cloud-init)
Creates an SSL certificate via Lets Encrypt for Nginx to use
Creates a private SSH key pem to use to connect to the EC2 server (can be converted to a PuTTY PPK using PuTTYgen)

After a successful terraform init, terraform plan -out the.plan, and terraform apply the.plan you will be presented with the following outputs:
Outputs:

cloudfront_domain = XXXXXXXXXXXXXX.cloudfront.net

cloudfront_id = YYYYYYYYYYYYYY

dns_record = streamline.FOO.BAR

id = RANDOM_UUID_STRING <--- this is used as the Stream Key and Admin Password for MovieNight

private_key = ssh_key.pem file in repo directory

public_ip = ZZZ.ZZZ.ZZZ.ZZZ

## Post Setup

Run `./scripts/post.sh`

This will generate utility scripts for ssh and sftp to the host. 

Use `./scripts/sftp.sh` to upload your encoded movie, then `./scripts/ssh.sh` and `./playout-mpd.sh <my_encoded_video.mp4>` to start your stream.