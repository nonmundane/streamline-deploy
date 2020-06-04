locals {
  public_ip   = var.instance_spot ? aws_spot_instance_request.streamline[0].public_ip : aws_instance.streamline[0].public_ip
  instance_id = var.instance_spot ? aws_spot_instance_request.streamline[0].id : aws_instance.streamline[0].id
  public_dns  = aws_route53_record.streamline.fqdn
}

resource "local_file" "private_key" {
  sensitive_content = tls_private_key.streamline.private_key_pem
  file_permission   = "0600"
  filename          = "ssh_${local.public_dns}.pem"

  count = var.private_key_file ? "1" : "0"
}

output "id" {
  description = "A randomly generated UUID to identify this module run from others"
  value       = random_uuid.streamline.result
}

output "public_ip" {
  description = "The public IP of the launched instance"
  value       = local.public_ip
}

output "dns_record" {
  description = "The DNS records of the launched instance"
  value       = local.public_dns
}

output "private_key" {
  description = "The unique private key for the launched instance"
  sensitive   = false
  value       = tls_private_key.streamline.private_key_pem
}

output "cloudfront_id" {
  description = "The identifier for the distribution."
  value       = aws_cloudfront_distribution.streamline_distribution.id
}

output "cloudfront_domain" {
  description = "The domain name corresponding to the distribution."
  value       = aws_cloudfront_distribution.streamline_distribution.domain_name
}
