## Copyright (c) 2022 Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

output "joomla_user_name" {
  value = var.joomla_name
}

output "joomla_schema_name" {
  value = var.joomla_schema
}

output "public_ip" {
  value = var.numberOfNodes > 1 ? oci_core_public_ip.Joomla_public_ip_for_multi_node.*.ip_address : oci_core_public_ip.Joomla_public_ip_for_single_node.*.ip_address
}

output "Joomla_nodes_ids" {
  value = concat(oci_core_instance.Joomla.*.id, oci_core_instance.Joomla_from_image.*.id)
}

output "joomla_host_name" {
  value = concat(oci_core_instance.Joomla.*.display_name, oci_core_instance.Joomla_from_image.*.display_name)
}

output "generated_ssh_private_key" {
  value     = tls_private_key.public_private_key_pair.private_key_pem
  sensitive = true
}

output "bastion_ssh_metadata" {
  value = concat(oci_bastion_session.ssh_via_bastion_service.*.ssh_metadata, oci_bastion_session.ssh_via_bastion_service2plus.*.ssh_metadata)
}