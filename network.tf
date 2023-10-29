locals {
  # Outputs from network module
  network              = module.network.network_name
  network_id           = module.network.network_id
  network_self_link    = module.network.network_self_link
  subnet               = module.network.subnets["${var.region}/${var.region}-subnet"].name
  vpc_connector_subnet = module.network.subnets["${var.region}/${var.prefix}-vpc-connector"].name

  # Subnets
  subnets = [
    {
      subnet_name = "${var.region}-subnet"
      subnet_ip   = "10.0.0.0/22"

      secondary_ranges = [
        {
          range_name    = "${var.region}-subnet-secondary-range"
          ip_cidr_range = "192.168.64.0/24"
        },
      ]
    },
    # Serverless VPC connector subnet
    {
      subnet_name           = "${var.prefix}-vpc-connector"
      subnet_ip             = "10.8.0.0/28"
      region                = var.region
      subnet_private_access = true
      subnet_flow_logs      = false
    },
  ]

  # Egress
  routes = [
    {
      name              = "${var.prefix}-vpc-egress-inet"
      description       = "route through IGW to access internet"
      destination_range = "0.0.0.0/0"
      tags              = "egress-inet"
      next_hop_internet = "true"
    },
  ]
}

#------------------------------------------------------------------------------
# Network/ Subnets
#------------------------------------------------------------------------------
module "network" {
  source       = "terraform-google-modules/network/google"
  version      = "7.5.0"
  project_id   = var.project_id
  network_name = "${var.prefix}-vpc"

  subnets = [for subnet in local.subnets : {
    subnet_name           = subnet.subnet_name
    subnet_ip             = subnet.subnet_ip
    subnet_region         = lookup(subnet, "subnet_region", var.region)
    subnet_private_access = lookup(subnet, "subnet_private_access", true)
    subnet_flow_logs      = lookup(subnet, "subnet_flow_logs", var.enable_subnet_flow_logs)
    aggregation_interval  = lookup(subnet, "aggregation_interval", "INTERVAL_10_MIN")
    flow_sampling         = lookup(subnet, "flow_sampling", 0.5)
    metadata              = lookup(subnet, "metadata", "INCLUDE_ALL_METADATA")
    }
  ]

  secondary_ranges = {
    for subnet in local.subnets : subnet.subnet_name => lookup(subnet, "secondary_ranges", [])
  }

  routes = local.routes
}

#------------------------------------------------------------------------------
# NAT
#------------------------------------------------------------------------------
resource "google_compute_router" "main_router" {
  project = var.project_id

  name    = "${var.prefix}-vpc-router"
  region  = var.region
  network = local.network_self_link

  bgp {
    asn = 64514
  }

  lifecycle {
    ignore_changes = all
  }
}

resource "google_compute_address" "main_nat" {
  count   = 1
  project = var.project_id
  name    = "${var.prefix}-vpc-nat-${count.index}"
  region  = var.region
}

resource "google_compute_router_nat" "main_nat" {
  project = var.project_id

  name                               = "${var.prefix}-vpc-nat"
  region                             = var.region
  router                             = google_compute_router.main_router.name
  nat_ip_allocate_option             = "MANUAL_ONLY"
  nat_ips                            = google_compute_address.main_nat.*.self_link
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"


  subnetwork {
    name                    = local.subnet
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }

  subnetwork {
    name                    = local.vpc_connector_subnet
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }

  log_config {
    enable = var.enable_nat_logs
    filter = "TRANSLATIONS_ONLY"
  }
}

#------------------------------------------------------------------------------
# Serverless VPC Access connector
#------------------------------------------------------------------------------
resource "google_vpc_access_connector" "connector" {
  project = var.project_id

  name   = "${var.prefix}-vpc-connector"
  region = var.region

  min_instances = 2
  max_instances = 3

  subnet {
    name       = local.vpc_connector_subnet
    project_id = var.project_id
  }
}

#------------------------------------------------------------------------------
# Private Services Access
#------------------------------------------------------------------------------
resource "google_compute_global_address" "private_service_connect" {
  project       = var.project_id
  name          = "${var.prefix}-vpc-private-service-connect"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  address       = "10.0.64.0"
  prefix_length = 18
  network       = local.network_self_link
}

resource "google_service_networking_connection" "private_service_connect" {
  network                 = local.network_self_link
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_service_connect.name]
}
