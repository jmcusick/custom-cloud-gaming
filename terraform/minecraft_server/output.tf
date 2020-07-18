output "IP" {
  value = aws_instance.minecraft.public_ip
  description = "The minecraft server ip"
}
