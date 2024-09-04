packer {
  required_plugins {
    qemu = {
      version = "~> 1"
      source  = "github.com/hashicorp/qemu"
    }
  }
}

source "qemu" "centos9" {
  accelerator      = "kvm"
  boot_command     = ["<tab><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs> inst.text inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/http/centos9-kickstart.cfg<enter><wait>"]
  boot_wait        = "10s"
  disk_cache       = "none"
  disk_compression = true
  disk_discard     = "unmap"
  disk_interface   = "virtio"
  disk_size        = "40000"
  format           = "qcow2"
  headless         = "true"
  http_directory   = "."
  iso_checksum     = "sha256:75f1380f7b02a073f4f789da44adb4fcdadbc521062407798e9aba2c09f3ae8c"
  # iso_url          = "http://mirror.stream.centos.org/9-stream/BaseOS/x86_64/iso/CentOS-Stream-9-20240902.0-x86_64-boot.iso"
  iso_url          = "CentOS-Stream-9-20240902.0-x86_64-boot.iso"
  net_device       = "virtio-net"
  output_directory = "artifacts/qemu/centos/9"
  qemu_binary      = "/usr/bin/qemu-system-x86_64"
  qemuargs         = [["-m", "2048M"], ["-smp", "2"], ["-cpu", "host"]]
  shutdown_command = "sudo /usr/sbin/shutdown -h now"
  ssh_password     = "censys"
  ssh_username     = "censys"
  ssh_wait_timeout = "30m"
  vnc_bind_address = "0.0.0.0"
  vnc_port_min = "5995"
  vnc_port_max = "5995"
}

build {
  sources = ["source.qemu.centos9"]

  provisioner "shell" {
    execute_command = "{{ .Vars }} sudo -E bash '{{ .Path }}'"
    inline          = ["dnf -y install epel-release", "dnf repolist", "dnf -y install ansible"]
  }

  # provisioner "ansible-local" {
  #   playbook_dir  = "ansible"
  #   playbook_file = "ansible/playbook.yml"
  # }

  # post-processor "shell-local" {
  #   environment_vars = ["IMAGE_NAME=${var.name}", "IMAGE_VERSION=${var.version}", "DESTINATION_SERVER=${var.destination_server}"]
  #   script           = "scripts/push-image.sh"
  # }
}
