## Copyright (c) 2022 Oracle and/or its affiliates.
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

resource "oci_core_virtual_network" "mysqlvcn" {
  cidr_block = var.vcn_cidr
  compartment_id = var.compartment_ocid
  display_name = var.vcn
  dns_label = "joomlavcn"
  count = var.existing_vcn_ocid == "" ? 1 : 0
  defined_tags   = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}


resource "oci_core_internet_gateway" "internet_gateway" {
  compartment_id = var.compartment_ocid
  display_name = "internet_gateway"
  vcn_id = local.vcn_id
  count = var.existing_internet_gateway_ocid == "" ? 1 : 0
  defined_tags   = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}


resource "oci_core_nat_gateway" "nat_gateway" {
  compartment_id = var.compartment_ocid
  vcn_id = local.vcn_id
  display_name   = "nat_gateway"
  count = var.existing_nat_gateway_ocid == "" ? 1 : 0
  defined_tags   = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}


resource "oci_core_route_table" "public_route_table" {
  compartment_id = var.compartment_ocid
  vcn_id = local.vcn_id
  display_name = "RouteTableForMySQLPublic"
  route_rules {
    destination = "0.0.0.0/0"
    network_entity_id = local.internet_gateway_id
  }
  count = var.existing_public_route_table_ocid == "" ? 1 : 0
  defined_tags   = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}


resource "oci_core_route_table" "private_route_table" {
  compartment_id = var.compartment_ocid
  vcn_id = local.vcn_id
  display_name   = "RouteTableForMySQLPrivate"
  route_rules {
    destination       = "0.0.0.0/0"
    network_entity_id = local.nat_gatway_id
  }
  count = var.existing_private_route_table_ocid == "" ? 1 : 0
  defined_tags   = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}

resource "oci_core_security_list" "public_security_list" {
  compartment_id = var.compartment_ocid
  display_name = "Allow Public SSH Connections to Joomla"
  vcn_id = local.vcn_id
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol = "6"
  }
  ingress_security_rules {
    tcp_options {
      max = 22
      min = 22
    }
    protocol = "6"
    source   = "0.0.0.0/0"
  }
  count = var.existing_public_security_list_ocid == "" ? 1 : 0
  defined_tags   = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}

resource "oci_core_security_list" "public_security_list_http" {
  compartment_id = var.compartment_ocid
  display_name = "Allow HTTP(S) to Joomla"
  vcn_id = local.vcn_id
  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol = "6"
  }
  ingress_security_rules {
    tcp_options {
      max = 80
      min = 80
    }
    protocol = "6"
    source   = "0.0.0.0/0"
  }
  ingress_security_rules {
    tcp_options {
      max = 443
      min = 443
    }
    protocol = "6"
    source   = "0.0.0.0/0"
  }
  count = var.existing_public_security_list_http_ocid == "" ? 1 : 0
  defined_tags   = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}

resource "oci_core_security_list" "private_security_list" {
  compartment_id = var.compartment_ocid
  display_name   = "Private"
  vcn_id = local.vcn_id

  egress_security_rules {
    destination = "0.0.0.0/0"
    protocol    = "all"
  }
  ingress_security_rules  {
    protocol = "1"
    source   = var.vcn_cidr
  }
  ingress_security_rules  {
    tcp_options  {
      max = 22
      min = 22
    }
    protocol = "6"
    source   = var.vcn_cidr
  }
  ingress_security_rules  {
    tcp_options  {
      max = 3306
      min = 3306
    }
    protocol = "6"
    source   = var.vcn_cidr
  }
  ingress_security_rules  {
    tcp_options  {
      max = 33061
      min = 33060
    }
    protocol = "6"
    source   = var.vcn_cidr
  }
  count = var.existing_private_security_list_ocid == "" ? 1 : 0
  defined_tags   = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}

resource "oci_core_subnet" "public" {
  cidr_block = cidrsubnet(var.vcn_cidr, 8, 0)
  display_name = "mysql_public_subnet"
  compartment_id = var.compartment_ocid
  vcn_id = local.vcn_id
  route_table_id = local.public_route_table_id
  security_list_ids = [local.public_security_list_id, local.public_security_list_http_id]
  #dhcp_options_id = var.use_existing_vcn_ocid ? var.existing_vcn_ocid.default_dhcp_options_id : oci_core_virtual_network.mysqlvcn[0].default_dhcp_options_id
  dns_label = "joomlapub"
  count = var.existing_public_subnet_ocid == "" ? 1 : 0
  defined_tags   = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}

resource "oci_core_subnet" "private" {
  cidr_block                 = cidrsubnet(var.vcn_cidr, 8, 1)
  display_name               = "mysql_private_subnet"
  compartment_id             = var.compartment_ocid
  vcn_id                     = local.vcn_id
  route_table_id             = local.private_route_table_id
  security_list_ids          = [local.private_security_list_id]
  #dhcp_options_id = var.use_existing_vcn_ocid ? var.existing_vcn_ocid.default_dhcp_options_id : oci_core_virtual_network.mysqlvcn[0].default_dhcp_options_id
  prohibit_public_ip_on_vnic = "true"
  dns_label                  = "joomlapriv"
  count = var.existing_private_subnet_ocid == "" ? 1 : 0
  defined_tags   = { "${oci_identity_tag_namespace.ArchitectureCenterTagNamespace.name}.${oci_identity_tag.ArchitectureCenterTag.name}" = var.release }
}




