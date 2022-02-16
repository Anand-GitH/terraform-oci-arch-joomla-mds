## Copyright (c) 2022 Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

output "joomla_home_URL" {
  value = "http://${module.joomla.public_ip[0]}/"
}

output "joomla_console_URL" {
  value = "http://${module.joomla.public_ip[0]}/administrator/"
}

output "joomla_console_user" {
  value = var.joomla_console_user
}

output "joomla_console_password" {
  value = var.joomla_console_password
}

output "joomla_console_email" {
  value = var.joomla_console_email
} 

output "mds_instance_ip" {
  value = module.mds-instance.private_ip
}

output "generated_ssh_private_key" {
  value     = module.joomla.generated_ssh_private_key
  sensitive = true
}