data "aws_ami" "ami" {
  most_recent = true
  owners = [var.ami_owner]
  
  filter {
    name = "name"
    values = [var.ami_name_filter]
  }
}

resource "aws_instance" "instance" {
  ami = data.aws_ami.ami.id
  instance_type = var.instance_type
  key_name = var.key_pair

  associate_public_ip_address = var.generate_public_ip

  vpc_security_group_ids = var.security_groups

  tags = {
    Name = var.name
  }

  root_block_device {
    volume_size = var.root_vol_size
    volume_type = var.root_vol_type
  }
  
  subnet_id = var.subnet_id
}

resource "null_resource" "provisioner" {
  count = var.playbook != "" ? 1 : 0

  triggers = {
    cluster_instance_ids = aws_instance.instance.id
  }

  provisioner "local-exec" {
    command = "sleep 30;cd ~/projects/ansible-de;source venv-activate.sh;ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i '${aws_instance.instance.public_ip},' provisioners/${var.playbook} -u ec2-user --private-key ~/.keys/${var.key_pair}.pem --ssh-common-args='-o ProxyCommand=\"/usr/local/bin/corkscrew 10.40.32.20 80 %h %p\"'"
    interpreter = ["bash","-c"]
  }
}
