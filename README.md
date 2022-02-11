# terraform-oci-arch-joomla-mds

Deploy Joomla on Oracle Cloud Intrastructure (OCI) and MySQL Database Service (MDS) using these Terraform modules.

## Prerequisites

- Permission to `manage` the following types of resources in your Oracle Cloud Infrastructure tenancy: `vcns`, `internet-gateways`, `route-tables`, `security-lists`, `subnets`, `mysql-family`, and `instances`.

- Quota to create the following resources: 1 VCN, 2 subnets, 1 Internet Gateway, 1 NAT Gateway, 2 route rules, 1 MySQL Database System (MDS) instance, and 1 compute instance (Joomla CMS).

If you don't have the required permissions and quota, contact your tenancy administrator. See [Policy Reference](https://docs.cloud.oracle.com/en-us/iaas/Content/Identity/Reference/policyreference.htm), [Service Limits](https://docs.cloud.oracle.com/en-us/iaas/Content/General/Concepts/servicelimits.htm), [Compartment Quotas](https://docs.cloud.oracle.com/iaas/Content/General/Concepts/resourcequotas.htm).

## Deploy Using Oracle Resource Manager

1. Click [![Deploy to Oracle Cloud](https://oci-resourcemanager-plugin.plugins.oci.oraclecloud.com/latest/deploy-to-oracle-cloud.svg)](https://cloud.oracle.com/resourcemanager/stacks/create?zipUrl=https://github.com/oracle-devrel/terraform-oci-arch-joomla-mds/releases/latest/download/terraform-oci-arch-joomla-mds-stack-latest.zip)

    If you aren't already signed in, when prompted, enter the tenancy and user credentials.

2. Review and accept the terms and conditions.

3. Select the region where you want to deploy the stack.

4. Follow the on-screen prompts and instructions to create the stack.

5. After creating the stack, click **Terraform Actions**, and select **Plan**.

6. Wait for the job to be completed, and review the plan.

    To make any changes, return to the Stack Details page, click **Edit Stack**, and make the required changes. Then, run the **Plan** action again.

7. If no further changes are necessary, return to the Stack Details page, click **Terraform Actions**, and select **Apply**. 

## Deploy Using the Terraform CLI

### Clone the Module

Now, you'll want a local copy of this repo. You can make that with the commands:

```
    git clone https://github.com/oracle-devrel/terraform-oci-arch-joomla-mds.git
    cd terraform-oci-arch-joomla-mds
    ls
```

### Prerequisites
First off, you'll need to do some pre-deploy setup.  That's all detailed [here](https://github.com/cloud-partners/oci-prerequisites).

Create a `terraform.tfvars` file, and specify the following variables:

```
# Authentication
tenancy_ocid         = "<tenancy_ocid>"
user_ocid            = "<user_ocid>"
fingerprint          = "<finger_print>"
private_key_path     = "<pem_private_key_path>"

# Region
region = "<oci_region>"

# Compartment
compartment_ocid = "<compartment_ocid>"

# MDS admin_password
admin_password = "<admin_password>"

# joomla_password
joomla_password = "<joomla_password>"
````

### Create the Resources
Run the following commands:

    terraform init
    terraform plan
    terraform apply

### Destroy the Deployment
When you no longer need the deployment, you can run this command to destroy the resources:

    terraform destroy

## Deploy as a Module
It's possible to utilize this repository as remote module, providing the necessary inputs:

```
module "oci-arch-joomla-mds" {
  source                        = "github.com/oracle-devrel/terraform-oci-arch-joomla-mds"
  tenancy_ocid                  = "<tenancy_ocid>"
  user_ocid                     = "<user_ocid>"
  fingerprint                   = "<finger_print>"
  private_key_path              = "<private_key_path>"
  region                        = "<oci_region>"
  compartment_ocid              = "<compartment_ocid>"
  admin_password                = "<admin_password>" 
  joomla_password               = "<joomla_password>"  
}
```

### Testing your Deployment

1. After the deployment is finished, you can access Joomla installer by picking joomla_public_ip output and pasting into web browser window. In the installation wizard please continue to fill in the form:

````
joomla_public_ip = 129.158.62.151
`````

![](./images/joomla_setup_01.png)

2. In a Database tab of the installer please fill in the form's fields as follows (for the Host Name provide MDS private ip from output - mds_instance_ip). Then click Next button: 

````
mds_instance_ip = 10.0.1.64
`````

![](./images/joomla_setup_02.png)

3. You need to access Joomla Webserver with SSH protocol and remove installation files (then click Next button):

![](./images/joomla_setup_03.png)

4. In a Overview tab just click Install button:

![](./images/joomla_setup_04.png)

5. When installation is done you need to remove installation from the server (continue to do it with your SSH session):

![](./images/joomla_setup_05.png)

6. Now you can access the initial Joomla home page:

![](./images/joomla_setup_06.png)

7. To access Joomla admin page you need to login:

![](./images/joomla_setup_07.png)

![](./images/joomla_setup_08.png)

## Contributing
This project is open source.  Please submit your contributions by forking this repository and submitting a pull request!  Oracle appreciates any contributions that are made by the open source community.

### Attribution & Credits
This repository was initially inspired on the materials found in [lefred's blog](https://lefred.be/content/deploying-joomla-on-oci-and-mds/).

That being the case, we would sincerely like to thank:
- Frédéric Descamps (https://github.com/lefred)

## License
Copyright (c) 2022 Oracle and/or its affiliates.

Licensed under the Universal Permissive License (UPL), Version 1.0.

See [LICENSE](LICENSE) for more details.
