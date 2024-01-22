terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "0.105.0"
    }
  }
}

provider "yandex" {
  
  token     = "keglia"
  cloud_id  = "b1gto83v8fdqgm5tjb2c"
  folder_id = "b1g7eg0ncndrirrrbobi"
  zone = "ru-central1-a"
}
resource "yandex_compute_instance" "default" {
  name = "new1"
  allow_stopping_for_update = true
  resources {
    cores  = 2
    memory = 2
  }
  boot_disk {
    disk_id = yandex_compute_disk.ubuntu2004_15GB.id
  }
  network_interface {
    subnet_id = "b0c9qst4f421skas5p13"
    nat       = true
  }
  metadata = {
    ssh-keys = "b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAAAMwAAAAtzc2gtZWQyNTUxOQAAACANpPdOm0tphcrXuUA6eGdfPYWljhKTdln/j9916IDkaAAAAJiT8Duxk/A7sQAAAAtzc2gtZWQyNTUxOQAAACANpPdOm0tphcrXuUA6eGdfPYWljhKTdln/j9916IDkaAAAAEABJewnwMZ5RvP+wuSblvtjvLYBLUo3dnjt2CbCVyIB9A2k906bS2mFyte5QDp4Z189
haWOEpN2Wf+P33XogORoAAAAEnhwQExBUFRPUC0wOEE1TTI5NAECAw=="
  }
  scheduling_policy {
    preemptible = true 
  }
connection {
    type     = "ssh"
    user     = "keglia"
    private_key = file("/home/keglia/myterrafor/id_ed25519.pub")
    host = yandex_compute_instance.default.network_interface.0.nat_ip_address
  }
  provisioner "remote-exec" {
    inline = [
      "sudo apt update", 
      "sudo apt install mc -y",
      "sudo apt install tomcat9 -y",
      "sudo apt install docker.io -y",

    ]
  }

}
data "yandex_compute_image" "ubuntu_image" {
  family = "ubuntu-2004-lts"
}
resource "yandex_compute_disk" "ubuntu_15GB"  {
  type     = "network-ssd"
  zone     = "ru-central1-a"
  image_id = data.yandex_compute_image.ubuntu_image.id
  size = 15
}