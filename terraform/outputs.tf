# DNS Público BALANCEADOR (IPV4)
output "lb_address" {
  value = ["${aws_instance.lb_ec2.*.public_dns}"]
}

# IP Público BALANCEADOR
output "lb_ip" {
  value = ["${aws_instance.lb_ec2.*.public_ip}"]
}

# DNS Público SERVIÇOS (IPV4)
output "svc_address" {
  value = ["${aws_instance.svc_ec2.*.public_dns}"]
}

# IP Público SERVIÇOS
output "svc_ip" {
  value = ["${aws_instance.svc_ec2.*.public_ip}"]
}


# DNS Público MONITORAMENTO (IPV4)
output "mt_address" {
  value = ["${aws_instance.mt_ec2.*.public_dns}"]
}

# IP Público MONITORAMENTO
output "mt_ip" {
  value = ["${aws_instance.mt_ec2.*.public_ip}"]
}