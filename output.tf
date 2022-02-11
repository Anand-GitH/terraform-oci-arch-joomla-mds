## Copyright (c) 2022 Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

output "joomla_public_ip" {
  value = module.joomla.public_ip
}

output "joomla_db_user" {
  value = module.joomla.joomla_user_name
}

output "joomla_schema" {
  value = module.joomla.joomla_schema_name
}

output "joomla_db_password" {
  value = var.joomla_password
}

output "mds_instance_ip" {
  value = module.mds-instance.private_ip
}

output "ssh_private_key" {
  value = local.private_key_to_show
  sensitive = true
}