## Copyright (c) 2022 Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

module "joomla" {
  source                = "./modules/joomla"
  availability_domains  = data.template_file.ad_names.*.rendered
  compartment_ocid      = var.compartment_ocid
  image_id              = var.node_image_id == "" ? data.oci_core_images.images_for_shape.images[0].id : var.node_image_id
  shape                 = var.node_shape
  label_prefix          = var.label_prefix
  subnet_id             = local.public_subnet_id
  ssh_authorized_keys   = local.ssh_key
  ssh_private_key       = local.ssh_private_key
  mds_ip                = module.mds-instance.private_ip
  admin_password        = var.admin_password
  admin_username        = var.admin_username
  joomla_schema         = var.joomla_schema
  joomla_name           = var.joomla_name
  joomla_password       = var.joomla_password
  display_name          = var.joomla_instance_name
  nb_of_webserver       = var.nb_of_webserver
  use_AD                = var.use_AD
  dedicated             = var.dedicated
  flex_shape_ocpus      = var.node_flex_shape_ocpus
  flex_shape_memory     = var.node_flex_shape_memory
  defined_tags          = var.defined_tags
}