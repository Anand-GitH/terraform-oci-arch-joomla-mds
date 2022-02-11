## Copyright (c) 2022 Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}

variable "release" {
  description = "Reference Architecture Release (OCI Architecture Center)"
  default     = "1.0"
}

variable "tenancy_ocid" {
  description = "Tenancy's OCID"
}

variable "compartment_ocid" {
  description = "Compartment's OCID where VCN will be created. "
}

variable "region" {
  description = "OCI Region"
}

variable "existing_vcn_ocid" {
  description = "OCID of an existing VCN to use"
  default     = ""
}

variable "existing_public_subnet_ocid" {
  description = "OCID of an existing public subnet to use"
  default     = ""
}

variable "existing_private_subnet_ocid" {
  description = "OCID of an existing private subnet to use"
  default     = ""
}

variable "existing_internet_gateway_ocid" {
  description = "OCID of an existing internet gateway to use"
  default     = ""
}

variable "existing_nat_gateway_ocid" {
  description = "OCID of an existing NAT gateway to use"
  default     = ""
}

variable "existing_public_route_table_ocid" {
  description = "OCID of an existing public route table to use"
  default     = ""
}

variable "existing_private_route_table_ocid" {
  description = "OCID of an existing private route table to use"
  default     = ""
}

variable "existing_public_security_list_ocid" {
  description = "OCID of an existing public security list (ssh) to use"
  default     = ""
}

variable "existing_public_security_list_http_ocid" {
  description = "OCID of an existing security list allowing https and https to use"
  default     = ""
}

variable "existing_private_security_list_ocid" {
  description = "OCID of an existing private security list allowing MySQL access to use"
  default     = ""
}

variable "existing_mds_instance_ocid" {
  description = "OCID of an existing MDS instance to use"
  default     = ""
}


variable "vcn" {
  description = "VCN Name"
  default     = "joomla_mds_vcn"
}

variable "vcn_cidr" {
  description = "VCN's CIDR IP Block"
  default     = "10.0.0.0/16"
}

variable "node_image_id" {
  description = "The OCID of an image for a node instance to use. "
  default     = ""
}

variable "node_shape" {
description = "Instance shape to use for master instance. "
 default     = "VM.Standard.E4.Flex"
}

variable "node_flex_shape_ocpus" {
  description = "Flex Instance shape OCPUs"
  default = 1
}

variable "node_flex_shape_memory" {
  description = "Flex Instance shape Memory (GB)"
  default = 6
}

variable "label_prefix" {
  description = "To create unique identifier for multiple setup in a compartment."
  default     = ""
}


variable "admin_password" {
  description = "Password for the admin user for MySQL Database Service"
}

variable "admin_username" {
  description = "MySQL Database Service Username"
  default = "admin"
}

variable "ssh_authorized_keys_path" {
  description = "Public SSH keys path to be included in the ~/.ssh/authorized_keys file for the default user on the instance. DO NOT FILL WHEN USING REOSURCE MANAGER STACK!"
  default     = ""
}

variable "ssh_private_key_path" {
  description = "The private key path to access instance. DO NOT FILL WHEN USING RESOURCE MANAGER STACK!"
  default     = ""
}

variable "mysql_shape" {
    default = "MySQL.VM.Standard.E3.1.8GB"
}

variable "joomla_name" {
  description = "Joomla Database User Name."
  default     = "joomla"
}

variable "joomla_password" {
  description = "Joomla Database User Password."
  default     = ""
}

variable "joomla_schema" {
  description = "Joomla MySQL Schema"
  default     = "joomla"
}

variable "mds_instance_name" {
  description = "Name of the MDS instance"
  default     = "JoomlaMDS"
}

variable "joomla_instance_name" {
  description = "Name of the Joomla compute instance"
  default     = "JoomlaServer"
}

variable "nb_of_webserver" {
    description = "Amount of Webservers to deploy"
    default = 1
}

variable "use_AD" {
  description = "Using different Availability Domain, by default use of Fault Domain"
  type        = bool
  default     = false
}

variable "dedicated" {
  description = "Create a dedicated user and a dedicated database for each Webservers"
  type        = bool
  default     = false
}

variable "deploy_mds_ha" {
  description = "Deploy High Availability for MDS"
  type        = bool
  default     = false
}