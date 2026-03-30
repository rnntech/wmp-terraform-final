#data stands for Data Source — it fetches information about resources that already exist in AWS, rather than creating new ones.
data "aws_ami" "ami" {
  most_recent = true
  owners = ["973714476881"]
  
  filter {
    name   = "name"
    values = ["Redhat-9-DevOps-Practice"]
  }
    # Additional filters can be added for specificity
}

data "aws_route53_zone" "main" {
  name         = var.dns_domain
}