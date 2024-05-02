#------------------------------------------------------------------------------
# Allow SSH Traffic from IAP Ranges
#------------------------------------------------------------------------------
resource "google_compute_firewall" "allow_iap_ssh" {
  project = var.project_id
  name    = "${var.prefix}-allow-iap-ssh"
  network = local.network

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["35.235.240.0/20", ]
  target_tags   = ["allow-iap-ssh"]
}

#------------------------------------------------------------------------------
# Allow Web Traffic from IAP Ranges
#------------------------------------------------------------------------------
resource "google_compute_firewall" "allow_iap_web" {
  project = var.project_id
  name    = "${var.prefix}-allow-iap-web"
  network = local.network

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["130.211.0.0/22", "35.191.0.0/16", ]
  target_tags   = ["allow-iap-web"]
}

#------------------------------------------------------------------------------
# Allow Load Balancer Health Check Traffic from Google
#------------------------------------------------------------------------------
resource "google_compute_firewall" "allow_health_checks" {
  project = var.project_id
  name    = "${var.prefix}-allow-health-checks"
  network = local.network

  allow {
    protocol = "tcp"
  }

  source_ranges = ["130.211.0.0/22", "35.191.0.0/16", "209.85.152.0/22", "209.85.204.0/22"]
  target_tags   = ["allow-health-check"]
}

#------------------------------------------------------------------------------
# Deny All Ingress
#------------------------------------------------------------------------------
resource "google_compute_firewall" "deny_all_ingress" {

  project = var.project_id
  network = local.network

  name = "${var.prefix}-deny-all-ingress"

  /* 
  Priority needs to be one above minimum, as there is always
  an implied rule at minimum priority with the same conditions
  but no logging.
  */
  priority = "65534"

  deny {
    protocol = "all"
  }

  dynamic "log_config" {
    for_each = var.enable_firewall_ingress_logs ? ["enable-logs"] : []
    content {
      metadata = "INCLUDE_ALL_METADATA"
    }
  }

  source_ranges = ["0.0.0.0/0"]
}
