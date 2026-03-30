module "database" {
  source = "./modules/components"
  for_each = var.databases
  component = each.key
  env=var.env
  dns_domain = var.dns_domain
  ports = each.value.ports
  instance_type = each.value.instance_type


}

module "apps" {
  depends_on = [module.database]
  source = "./modules/components"
  for_each = var.apps
  component = each.key
  env=var.env
  dns_domain = var.dns_domain
  ports = each.value.ports
  instance_type = each.value.instance_type


}


