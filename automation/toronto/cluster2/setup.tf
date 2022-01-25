module "common" {
  source = "../common"
  PREFIX = var.PREFIX

  ibmcloud_api_key = var.ibmcloud_api_key

  REGION = local.REGION

  ZONE1 = local.ZONE1
  ZONE2 = local.ZONE2
  ZONE3 = local.ZONE3

  ZONE1_CIDR = local.ZONE1_CIDR
  ZONE2_CIDR = local.ZONE2_CIDR
  ZONE3_CIDR = local.ZONE3_CIDR

  VPC_NAME                        = local.VPC_NAME
  VPC_DEFAULT_SECURITY_GROUP_NAME = local.VPC_DEFAULT_SECURITY_GROUP_NAME

  # Subnets are ending with suffix "02" as we already have subnets with suffix "01" in another VPC
  SUBNET_1_NAME = "${local.SUBNET_PREFIX}-${local.ZONE1}-02"
  SUBNET_2_NAME = "${local.SUBNET_PREFIX}-${local.ZONE2}-02"
  SUBNET_3_NAME = "${local.SUBNET_PREFIX}-${local.ZONE3}-02"

  # We already have 3 security groups numbered 01/02 and 03. So, starting from 04 here
  SECURITY_GROUP_1_NAME = "${local.SECURITY_GROUP_PREFIX}-04"
  SECURITY_GROUP_2_NAME = "${local.SECURITY_GROUP_PREFIX}-05"

  tags = var.tags
}

module "nfs-server" {
  source = "../nfs"

  ibmcloud_api_key = var.ibmcloud_api_key
  ssh_key          = data.ibm_is_ssh_key.ssh_key_sg_mac

  PREFIX        = var.PREFIX
  INSTANCE_NAME = "${var.PREFIX}-${local.NFS_MAIN_ZONE}-${local.NFS_SUFFIX}-02"

  IMAGE            = data.ibm_is_image.redhat_8_min
  INSTANCE_PROFILE = local.INSTANCE_PROFILE

  REGION         = local.REGION
  MAIN_ZONE      = local.NFS_MAIN_ZONE
  MAIN_SUBNET_ID = local.NFS_MAIN_SUBNET_ID
  PRIVATE_IP     = local.NFS_PRIVATE_IP

  VPC                    = module.common.vpc
  MAIN_SECURITY_GROUP_ID = module.common.custom_sg_1_id
  DEFAULT_SECURITY_GROUP = module.common.default_vpc_sg

  USER_DATA_DIR = "../nfs/files/initial_setup-02.sh"

  tags = var.tags
}

module "broker-05-live" {
  source     = "../broker"
  depends_on = [module.nfs-server]

  ibmcloud_api_key = var.ibmcloud_api_key
  ssh_key          = data.ibm_is_ssh_key.ssh_key_sg_mac

  PREFIX        = var.PREFIX
  INSTANCE_NAME = "${var.PREFIX}-${local.BROKER_05_SUFFIX}"

  IMAGE            = data.ibm_is_image.redhat_8_min
  INSTANCE_PROFILE = local.INSTANCE_PROFILE

  REGION         = local.REGION
  MAIN_ZONE      = local.BROKER_05_MAIN_ZONE
  MAIN_SUBNET_ID = local.BROKER_05_MAIN_SUBNET_ID
  PRIVATE_IP     = local.BROKER_05_PRIVATE_IP

  VPC                    = module.common.vpc
  SECURITY_GROUP_1_ID    = module.common.custom_sg_1_id
  SECURITY_GROUP_2_ID    = module.common.custom_sg_2_id
  DEFAULT_SECURITY_GROUP = module.common.default_vpc_sg

  USER_DATA_DIR = "../broker/cluster2/broker5_live3/initial_setup-01.sh"

  tags = var.tags
}

module "broker-06-bak" {
  source     = "../broker"
  depends_on = [module.nfs-server]

  ibmcloud_api_key = var.ibmcloud_api_key
  ssh_key          = data.ibm_is_ssh_key.ssh_key_sg_mac

  PREFIX        = var.PREFIX
  INSTANCE_NAME = "${var.PREFIX}-${local.BROKER_06_SUFFIX}"

  IMAGE            = data.ibm_is_image.redhat_8_min
  INSTANCE_PROFILE = local.INSTANCE_PROFILE

  REGION         = local.REGION
  MAIN_ZONE      = local.BROKER_06_MAIN_ZONE
  MAIN_SUBNET_ID = local.BROKER_06_MAIN_SUBNET_ID
  PRIVATE_IP     = local.BROKER_06_PRIVATE_IP

  VPC                    = module.common.vpc
  SECURITY_GROUP_1_ID    = module.common.custom_sg_1_id
  SECURITY_GROUP_2_ID    = module.common.custom_sg_2_id
  DEFAULT_SECURITY_GROUP = module.common.default_vpc_sg

  USER_DATA_DIR = "../broker/cluster2/broker6_bak3/initial_setup-01.sh"

  tags = var.tags
}

module "broker-07-live" {
  source     = "../broker"
  depends_on = [module.nfs-server]

  ibmcloud_api_key = var.ibmcloud_api_key
  ssh_key          = data.ibm_is_ssh_key.ssh_key_sg_mac

  PREFIX        = var.PREFIX
  INSTANCE_NAME = "${var.PREFIX}-${local.BROKER_07_SUFFIX}"

  IMAGE            = data.ibm_is_image.redhat_8_min
  INSTANCE_PROFILE = local.INSTANCE_PROFILE

  REGION         = local.REGION
  MAIN_ZONE      = local.BROKER_07_MAIN_ZONE
  MAIN_SUBNET_ID = local.BROKER_07_MAIN_SUBNET_ID
  PRIVATE_IP     = local.BROKER_07_PRIVATE_IP

  VPC                    = module.common.vpc
  SECURITY_GROUP_1_ID    = module.common.custom_sg_1_id
  SECURITY_GROUP_2_ID    = module.common.custom_sg_2_id
  DEFAULT_SECURITY_GROUP = module.common.default_vpc_sg

  USER_DATA_DIR = "../broker/cluster2/broker7_live4/initial_setup-01.sh"

  tags = var.tags
}

module "broker-08-bak" {
  source     = "../broker"
  depends_on = [module.nfs-server]

  ibmcloud_api_key = var.ibmcloud_api_key
  ssh_key          = data.ibm_is_ssh_key.ssh_key_sg_mac

  PREFIX        = var.PREFIX
  INSTANCE_NAME = "${var.PREFIX}-${local.BROKER_08_SUFFIX}"

  IMAGE            = data.ibm_is_image.redhat_8_min
  INSTANCE_PROFILE = local.INSTANCE_PROFILE

  REGION         = local.REGION
  MAIN_ZONE      = local.BROKER_08_MAIN_ZONE
  MAIN_SUBNET_ID = local.BROKER_08_MAIN_SUBNET_ID
  PRIVATE_IP     = local.BROKER_08_PRIVATE_IP

  VPC                    = module.common.vpc
  SECURITY_GROUP_1_ID    = module.common.custom_sg_1_id
  SECURITY_GROUP_2_ID    = module.common.custom_sg_2_id
  DEFAULT_SECURITY_GROUP = module.common.default_vpc_sg

  USER_DATA_DIR = "../broker/cluster2/broker8_bak4/initial_setup-01.sh"

  tags = var.tags
}

module "router_common" {
  source = "../router/common"

  ibmcloud_api_key = var.ibmcloud_api_key

  INSTANCE_PROFILE = local.INSTANCE_PROFILE

  SECURITY_GROUP_NAME = "${local.SECURITY_GROUP_PREFIX}-03"
  VPC_ID              = module.common.vpc_id

  tags = var.tags
}

module "router-03-spoke" {
  source = "../router/hub-n-spoke"

  ibmcloud_api_key = var.ibmcloud_api_key
  ssh_key          = data.ibm_is_ssh_key.ssh_key_sg_mac

  PREFIX        = var.PREFIX
  INSTANCE_NAME = "${var.PREFIX}-${local.SPOKE_ROUTER_03_SUFFIX}"

  IMAGE            = data.ibm_is_image.redhat_8_min
  INSTANCE_PROFILE = local.INSTANCE_PROFILE

  REGION         = local.REGION
  MAIN_ZONE      = local.SPOKE_ROUTER_03_MAIN_ZONE
  MAIN_SUBNET_ID = local.SPOKE_ROUTER_03_MAIN_SUBNET_ID
  PRIVATE_IP     = local.SPOKE_ROUTER_03_PRIVATE_IP

  VPC                    = module.common.vpc
  SECURITY_GROUP_1_ID    = module.common.custom_sg_1_id
  SECURITY_GROUP_2_ID    = module.common.custom_sg_2_id
  SECURITY_GROUP_3_ID    = module.router_common.custom_sg_3_id
  DEFAULT_SECURITY_GROUP = module.common.default_vpc_sg

  USER_DATA_DIR = "../router/spoke-router3/initial_setup-01.sh"

  tags = var.tags
}
