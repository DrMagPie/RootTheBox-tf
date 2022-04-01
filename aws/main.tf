data "aws_ami" "app" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu-*-20.04-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  owners = ["099720109477"]
}

data "template_cloudinit_config" "user_data" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/userdata/cloudinit.yml",
      {
        SERVICE    = indent(6, base64encode(file("${path.module}/userdata/etc/systemd/system/rtb.service")))
        NGINX_CONF = indent(6, base64encode(file("${path.module}/userdata/etc/nginx/nginx.conf")))
        BKP = indent(6,
          base64encode(
            templatefile("${path.module}/userdata/opt/bkp.sh",
              {
                BUCKET = "bkt.${var.application}.${var.environment}"
              }
            )
          )
        )
        RTB_NGINX = indent(6,
          base64encode(
            templatefile("${path.module}/userdata/etc/nginx/sites-enabled/RootTheBox.conf",
              {
                SERVER_NAME = var.domain
                ROOT        = "/opt/RootTheBox"
              }
            )
          )
        )
      }
    )
  }
  part {
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/userdata/bootstrap.sh",
      {
        BUCKET = "bkt.${var.application}.${var.environment}"
        DOMAIN = var.domain
        EMAIL  = var.owner
      }
    )
  }
}

resource "aws_instance" "server" {
  ami                         = data.aws_ami.app.id
  instance_type               = var.instance_type
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.server.id]
  user_data                   = data.template_cloudinit_config.user_data.rendered
  iam_instance_profile        = aws_iam_instance_profile.profile.name

  tags = { Name = "ec2.${var.application}.${var.environment}" }
}

resource "aws_security_group" "server" {
  name        = "sg.${var.application}.${var.environment}"
  description = "SG for EC2 instances"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8888
    to_port     = 8888
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "sg.${var.application}.${var.environment}" }
}

# resource "aws_s3_bucket" "bucket" {
#   bucket = "bkt.${var.application}.${var.environment}"
#   acl    = "private"
#   tags = {
#     Name = "bkt.${var.application}.${var.environment}"
#   }
#   # lifecycle {
#   #   prevent_destroy = true
#   # }
# }

data "aws_caller_identity" "default" {}
resource "aws_iam_role" "role" {
  name = "rle.${var.application}.${var.environment}"
  lifecycle {
    create_before_destroy = true
  }
  inline_policy {
    name = "plc.${var.application}.${var.environment}"
    policy = jsonencode(
      {
        Version = "2012-10-17"
        Statement = [
          {
            Effect = "Allow"
            Action = [
              "s3:*"
            ],
            Resource = [
              "arn:aws:s3:::bkt.${var.application}.${var.environment}",
              "arn:aws:s3:::bkt.${var.application}.${var.environment}/*"
            ]
          }
        ]
      }
    )
  }
  assume_role_policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Effect = "Allow"
          Action = "sts:AssumeRole"
          Principal = {
            Service = "ec2.amazonaws.com"
          }
        }
      ]
    }
  )
}

resource "aws_iam_instance_profile" "profile" {
  name = "prf.${var.application}.${var.environment}"
  role = aws_iam_role.role.name
}


data "aws_route53_zone" "hosted_zone" {
  name         = var.hosted_zone
  private_zone = false
}

resource "aws_route53_record" "web" {
  zone_id = data.aws_route53_zone.hosted_zone.zone_id
  name    = var.domain
  type    = "A"
  ttl     = "60"
  records = [aws_instance.server.public_ip]
}
