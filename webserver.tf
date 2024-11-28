# Create EC2 instance
resource "aws_instance" "web_server" {
    ami = "ami-0866a3c8686eaeeba"
    instance_type = "t2.micro"
  
    key_name = "vockey"  # SSH key to connect instance
    
    subnet_id = aws_subnet.public_subnet_1.id
    
    vpc_security_group_ids = [ aws_security_group.allow_ssh_http.id ]
    
    associate_public_ip_address = true
    
    user_data = file("userdata.sh") # Script to provision EC2 instance
    
    tags = {
        Name = "Web Server"
    }
}

# Create security group for EC2
resource "aws_security_group" "allow_ssh_http" {
  name        = "allow_ssh_http"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.tf_lab_vpc.id

  tags = {
    Name = "Allow SSH and HTTP"
  }
}

# Create rule for security group to allow inbound HTTP
resource "aws_vpc_security_group_ingress_rule" "allow_http_ipv4" {
  security_group_id = aws_security_group.allow_ssh_http.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

# Create rule for security group to allow inbound HTTP on port 5000
resource "aws_vpc_security_group_ingress_rule" "allow_http5000_ipv4" {
  security_group_id = aws_security_group.allow_ssh_http.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 5000
  ip_protocol       = "tcp"
  to_port           = 5000
}

# Create rule for security group to allow inbound SSH
resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4" {
  security_group_id = aws_security_group.allow_ssh_http.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

# Create rule for security group to allow outbound traffic (all)
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_ssh_http.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}


output "instance_dns_addr" {
  value = aws_instance.web_server.public_dns
}

output "instance_ip_addr" {
  value = aws_instance.web_server.public_ip
}

