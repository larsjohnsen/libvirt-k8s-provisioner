provider "libvirt" {
  uri = "qemu:///system"
}

module "libvirt_pool" {
  source  = "kubealex/libvirt-resources/libvirt//modules/terraform-libvirt-pool"
  version = "0.0.1"
  pool_name = var.pool_name
}

module "libvirt_network" {
  source  = "kubealex/libvirt-resources/libvirt//modules/terraform-libvirt-network"
  version = "0.0.1"
  network_name = var.network_name
  network_domain = var.network_domain
  network_cidr = var.network_cidr
  network_dhcp_enabled = var.network_dhcp_enabled
  network_dhcp_local = var.network_dhcp_local
  network_dnsmasq_options = var.network_dnsmasq_options
}


module "master_nodes" {
  source  = "kubealex/libvirt-resources/libvirt//modules/terraform-libvirt-instance"
  version = "0.0.1"
  depends_on = [ module.libvirt_network, module.libvirt_pool ]
  instance_libvirt_network =    var.master_instance_libvirt_network
  instance_libvirt_pool =       var.master_instance_libvirt_pool
  instance_cloud_image =        var.master_instance_cloud_image
  instance_hostname =           var.master_instance_hostname
  instance_domain =             var.master_instance_domain
  instance_memory =             var.master_instance_memory
  instance_cpu =                var.master_instance_cpu
  instance_count =              var.master_instance_count
  instance_cloud_user =         var.master_instance_cloud_user
  instance_uefi_enabled =       var.master_instance_uefi_enabled
}

module "worker_nodes" {
  source  = "kubealex/libvirt-resources/libvirt//modules/terraform-libvirt-instance"
  version = "0.0.1"
  depends_on = [ module.libvirt_network, module.libvirt_pool ]
  instance_libvirt_network =    var.worker_instance_libvirt_network
  instance_libvirt_pool =       var.worker_instance_libvirt_pool
  instance_cloud_image =        var.worker_instance_cloud_image
  instance_hostname =           var.worker_instance_hostname
  instance_domain =             var.worker_instance_domain
  instance_memory =             var.worker_instance_memory
  instance_cpu =                var.worker_instance_cpu
  instance_count =              var.worker_instance_count
  instance_cloud_user =         var.worker_instance_cloud_user
  instance_uefi_enabled =       var.worker_instance_uefi_enabled
}

module "worker_nodes_rook" {
  source  = "kubealex/libvirt-resources/libvirt//modules/terraform-libvirt-instance"
  version = "0.0.1"
  count = var.worker_rook_enabled ? 1 : 0
  depends_on = [ module.libvirt_network, module.libvirt_pool ]
  instance_libvirt_network =        var.worker_rook_instance_libvirt_network
  instance_additional_volume_size = var.worker_rook_instance_additional_volume_size
  instance_libvirt_pool =           var.worker_rook_instance_libvirt_pool
  instance_cloud_image =            var.worker_rook_instance_cloud_image
  instance_hostname =               var.worker_rook_instance_hostname
  instance_domain =                 var.worker_rook_instance_domain
  instance_memory =                 var.worker_rook_instance_memory
  instance_cpu =                    var.worker_rook_instance_cpu
  instance_count =                  var.worker_rook_instance_count
  instance_cloud_user =             var.worker_rook_instance_cloud_user
  instance_uefi_enabled =           var.worker_rook_instance_uefi_enabled
}

module "loadbalancer" {
  source  = "kubealex/libvirt-resources/libvirt//modules/terraform-libvirt-instance"
  version = "0.0.1"
  count = var.loadbalancer_enabled ? 1 : 0
  depends_on = [ module.libvirt_network, module.libvirt_pool ]
  instance_libvirt_network =        var.loadbalancer_instance_libvirt_network
  instance_additional_volume_size = var.loadbalancer_instance_additional_volume_size
  instance_libvirt_pool =           var.loadbalancer_instance_libvirt_pool
  instance_cloud_image =            var.loadbalancer_instance_cloud_image
  instance_hostname =               var.loadbalancer_instance_hostname
  instance_domain =                 var.loadbalancer_instance_domain
  instance_memory =                 var.loadbalancer_instance_memory
  instance_cpu =                    var.loadbalancer_instance_cpu
  instance_count =                  var.loadbalancer_instance_count
  instance_cloud_user =             var.loadbalancer_instance_cloud_user
  instance_uefi_enabled =           var.loadbalancer_instance_uefi_enabled
}


terraform {
 required_version = ">= 1.0"
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.7.6"
    }
  }
}