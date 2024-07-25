data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "ansible_server" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = var.private_subnet_id
  vpc_security_group_ids = [var.ansible_sg_id]
  iam_instance_profile   = var.iam_instance_profile_name

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              amazon-linux-extras install ansible2 -y
              
              # Install kubectl
              curl -o kubectl https://s3.us-west-2.amazonaws.com/amazon-eks/1.23.7/2022-06-29/bin/linux/amd64/kubectl
              chmod +x ./kubectl
              mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$PATH:$HOME/bin
              echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc
              
              # Install AWS CLI v2
              curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
              unzip awscliv2.zip
              sudo ./aws/install
              
              # Install eksctl
              curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
              sudo mv /tmp/eksctl /usr/local/bin

               # Configure cluster connection
              aws eks --region ca-central-1 update-kubeconfig --name staging-jenkins-cluster
              
              # Verify connection
              kubectl get svc
              EOF

  tags = {
    Name        = "${var.environment}-ansible-server"
    Environment = var.environment
  }
}