resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "td2-vpc"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = var.availability_zones[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "td2-public-subnet"
  }
}

resource "aws_subnet" "private" {
  count = length(var.availability_zones)

  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.${count.index + 10}.0/24"
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "td2-private-subnet-${count.index}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "td2-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "td2-public-rt"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_instance" "vm" {
  count = var.vm_count

  ami           = var.ami_id
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.public.id

  tags = {
    Name = "td2-vm-${count.index}"
  }
}

resource "aws_db_subnet_group" "db" {
  name       = "td2-db-subnet-group"
  subnet_ids = aws_subnet.private[*].id
}

resource "random_password" "db_password" {
  length  = 16
  special = false
}

resource "aws_db_instance" "db" {
  identifier           = "td2-db-instance"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  allocated_storage    = 20
  db_name              = "td2db"
  username             = "admin"
  password             = random_password.db_password.result
  db_subnet_group_name = aws_db_subnet_group.db.name
  publicly_accessible  = false
  skip_final_snapshot  = true
}

resource "aws_route53_zone" "zone" {
  name = "kiowy.com"
}

resource "aws_route53_record" "app" {
  zone_id = aws_route53_zone.zone.zone_id
  name    = "app.${aws_route53_zone.zone.name}"
  type    = "A"
  ttl     = 300
  records = aws_instance.vm[*].public_ip
}
