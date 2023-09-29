resource "null_resource" "run_commands" {
  count = length(var.provision)

  triggers = {
    host = var.provision[count.index].ssh.address
  }

  connection {
    type        = "ssh"
    user        = var.provision[count.index].ssh.user
    private_key = file(var.provision[count.index].ssh.keyPath)
    host        = var.provision[count.index].ssh.address
  }

  provisioner "remote-exec" {
    inline = [
      "sudo systemctl stop multipathd",
      "sudo systemctl disable multipathd",
      "sudo apt update",
      "sudo apt install -y nfs-common"
    ]
  }
}

