provider "openstack" {
  cloud = "sausage"
}

resource "openstack_compute_instance_v2" "mgmt" {
  name            = "beegfs-mgmt"
  image_name      = "CentOS 7.6"
  flavor_name     = "chipolata"
  key_pair        = "bharat"
  security_groups = ["default"]

  network {
    name = "gateway"
  }
}

resource "openstack_compute_instance_v2" "oss" {
  name            = "beegfs-oss-${count.index}"
  image_name      = "CentOS 7.6"
  flavor_name     = "chipolata"
  key_pair        = "bharat"
  security_groups = ["default"]
  count           = 4

  network {
    name = "gateway"
  }
}

data  "template_file" "beegfs" {
    template = "${file("./beegfs.tpl")}"
    vars = {
      beegfs_mgmt = <<EOT
${openstack_compute_instance_v2.mgmt.name} ansible_host=${openstack_compute_instance_v2.mgmt.network[0].fixed_ip_v4} ansible_user=centos
EOT
      beegfs_oss = <<EOT
%{for oss in openstack_compute_instance_v2.oss}
${oss.name} ansible_host=${oss.network[0].fixed_ip_v4} ansible_user=centos%{ endfor }
EOT
    }
}

resource "local_file" "hosts" {
  content  = "${data.template_file.beegfs.rendered}"
  filename = "inventory-beegfs"
}
