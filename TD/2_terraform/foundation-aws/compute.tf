resource "aws_instance" "vm" {
  count = var.vm_count

  ami           = var.ami_id
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.public.id

  tags = {
    Name = "td2-vm-${count.index}"
  }
}
