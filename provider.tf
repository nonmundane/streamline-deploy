provider "aws" {
  region  = var.aws_region
  profile = "default"
}
#us-east-1 required for ACM + cloudfront https://aws.amazon.com/premiumsupport/knowledge-center/custom-ssl-certificate-cloudfront/
provider "aws" {
  alias = "east"
  region  = "us-east-1"
  profile = "default"
}
