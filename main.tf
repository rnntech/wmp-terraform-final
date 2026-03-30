module database "database" {
  source = "./modules/components"
  for_each = var.databases
  component = each.key
  env=var.env
  dns_domain = var.dns_domain
  port = each.value.ports
  instance_type = each.value.instance_type


}

module apps "apps" {
  depends_on = [module.databases]
  source = "./modules/components"
  for_each = var.apps
  component = each.key
  env=var.env
  dns_domain = var.dns_domain
  port = each.value.ports
  instance_type = each.value.instance_type


}


