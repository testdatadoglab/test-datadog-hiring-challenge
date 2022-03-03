/**
 * Copyright 2019 Google LLC
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


variable "credentials" {
  description = "The json credential for Terraform"
  default = "test-datadog-student-e3b67bf2e2d4.json"
}

variable "project_id" {
  description = "The project ID to host the cluster in"
  default = "test-datadog-student"
}

variable "service_account" {
  description = "The Service Account for GCP"
  default = "test-datadog-student@test-datadog-student.iam.gserviceaccount.com"
}

variable "cluster_name" {
  description = "The name for the GKE cluster"
  default     = "gke-datadog-cluster"
}

variable "region" {
  description = "The region to host the cluster in"
  default     = "europe-west2"
}

variable "zone" {
  description = "The zone to host the cluster in"
  default     = "europe-west2-c"
}


variable "network" {
  description = "The VPC network created to host the cluster in"
  default     = "gke-datadog-network"
}

variable "subnetwork" {
  description = "The subnetwork created to host the cluster in"
  default     = "gke-datadog-subnet"
}

variable "ip_range_pods_name" {
  description = "The secondary ip range to use for pods"
  default     = "ip-range-pods"
}

variable "ip_range_services_name" {
  description = "The secondary ip range to use for services"
  default     = "ip-range-scv"
}

variable "node-nginx" {
  description = "The name os the standalone virtual machine where NGINX will run"
  default = "test-datadog-nginx-instance"
}
variable "gke-node-pools" {
  description = "The name of the node pool for GKE Cluster"
  default = "datadog-node-pool"
}
