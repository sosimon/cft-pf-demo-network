/**
 * Copyright 2018 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "slalomsv"

    workspaces {
      name = "gcp-cft-pf-demo-host-network"
    }
  }
}

locals {
  credentials_file_path = "${var.credentials_path}"
}

/******************************************
  Provider configuration
 *****************************************/
provider "google" {
  project     = "${var.network_project_name}"
  credentials = "${file(local.credentials_file_path)}"
  version     = "~> 1.19"
}

provider "google-beta" {
  project     = "${var.network_project_name}"
  credentials = "${file(local.credentials_file_path)}"
  version     = "~> 1.19"
}

resource "google_compute_network" "network" {
  name                    = "${var.network_name}"
  auto_create_subnetworks = false
}

resource "google_compute_shared_vpc_host_project" "host" {
  project = "${var.network_project_name}"
}

resource "google_compute_subnetwork" "us-west1" {
  name                     = "us-west1"
  region                   = "us-west1"
  ip_cidr_range            = "10.0.128.0/24"
  network                  = "${google_compute_network.network.self_link}"
  private_ip_google_access = true
}

resource "google_compute_subnetwork" "us-east1" {
  name                     = "us-east1"
  region                   = "us-east1"
  ip_cidr_range            = "10.0.129.0/24"
  network                  = "${google_compute_network.network.self_link}"
  private_ip_google_access = true
}

resource "google_compute_subnetwork" "europe-west1" {
  name                     = "europe-west1"
  region                   = "europe-west1"
  ip_cidr_range            = "10.0.130.0/24"
  network                  = "${google_compute_network.network.self_link}"
  private_ip_google_access = true
}
