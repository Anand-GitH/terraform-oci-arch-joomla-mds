## Copyright (c) 2022 Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

output "id" {
  value = oci_core_instance.Joomla.*.id
}

output "public_ip" {
  value = join(", ", oci_core_instance.Joomla.*.public_ip)
}

output "joomla_user_name" {
  value = var.joomla_name
}

output "joomla_schema_name" {
  value = var.joomla_schema
}

output "joomla_host_name" {
  value = oci_core_instance.Joomla.*.display_name
}
