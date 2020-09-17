#---------------------------------------------------------------
# Informação
# autor: Leonardo Viana Pereira
# email: leonardo.viana@armateus.com.br
# version: 0.1.0
# Descrição: Criando e configurando uma VPC e instâncias EC2 na AWS
# Desafio do Curso de DevOps | Ithappens - Referente aos módulos 3 e 4
#---------------------------------------------------------------
#
# Comandos importantes:
#
# terraform --help    => Mostra informações sobre os comandos
# terraform providers => Imprime uma árvore dos provedores usados ​​na configuração
# terraform init      => Inicializar um diretório de trabalho do Terraform
# terraform validate  => Valida os arquivos do Terraform
# terraform plan      => Gere e mostre um plano de execução
# terraform apply     => Cria ou altera a infraestrutura
# terraform show      => Inspecionar estado ou plano do Terraform
# terraform destroy   => Destruir a infraestrutura gerenciada pelo Terrafor
#---------------------------------------------------------------
# Os valores das variáveis ​​são definidos nos arquivos 'variables.tf' e

#---------------------------------------------------------------
#                           PROVEDOR
#---------------------------------------------------------------

provider "aws" {
    profile = "default"
    region = "us-east-1"
}

#---------------------------------------------------------------
#                             VPC
#---------------------------------------------------------------

resource "aws_vpc" "VPC_CursoDevOps" {
  cidr_block           = var.vpcCIDRblock
  instance_tenancy     = var.instanceTenancy 
  enable_dns_support   = var.dnsSupport 
  enable_dns_hostnames = var.dnsHostNames
tags = {
    Name = "VPC CursoDevOps"
}
}

#--------------------------------------------------------------
#                           SUBNETS
#--------------------------------------------------------------
#                 SUBNET1 - PÚBLICA - BALANCEADOR
#--------------------------------------------------------------

resource "aws_subnet" "Pub_subnet1" {
  vpc_id                  = aws_vpc.VPC_CursoDevOps.id
  cidr_block              = var.publicsCIDRblock
  map_public_ip_on_launch = var.mapPublicIP 
  availability_zone       = var.availabilityZone
tags = {
   Name = "Sub-Pub1"
}
}

#--------------------------------------------------------------
#                 SUBNET2 - PRIVADA - SERVIÇOS
#--------------------------------------------------------------

resource "aws_subnet" "Priv_subnet1" {
  vpc_id                  = aws_vpc.VPC_CursoDevOps.id
  cidr_block              = var.privateCIDRblock
  map_public_ip_on_launch = var.mapPublicIP 
  availability_zone       = var.availabilityZone
tags = {
   Name = "Sub-Priv1"
}
}

#--------------------------------------------------------------
#                 SUBNET3 - PRIVADA - MONITORAMENTO
#--------------------------------------------------------------

resource "aws_subnet" "Priv_subnet2" {
  vpc_id                  = aws_vpc.VPC_CursoDevOps.id
  cidr_block              = var.private2CIDRblock
  map_public_ip_on_launch = var.mapPublicIP 
  availability_zone       = var.availabilityZone
tags = {
   Name = "Sub-Priv2"
}
}

#--------------------------------------------------------------
#                            NACL
#--------------------------------------------------------------

resource "aws_network_acl" "DevOps_NACL" {
  vpc_id = aws_vpc.VPC_CursoDevOps.id
  subnet_ids = [ aws_subnet.Pub_subnet1.id, aws_subnet.Priv_subnet1.id, aws_subnet.Priv_subnet2.id ]
  #-----------------------------------------------------------
  #                    PORTAS EFÊMERAS
  #-----------------------------------------------------------
  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }

   egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }  
  #-----------------------------------------------------------
  #                         HTTP
  #-----------------------------------------------------------
  ingress {
    protocol   = "tcp"
    rule_no    = 110
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

   egress {
    protocol   = "tcp"
    rule_no    = 110
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80 
    to_port    = 80
  }
  #-----------------------------------------------------------
  #                         HTTPS
  #-----------------------------------------------------------
  ingress {
    protocol   = "tcp"
    rule_no    = 111
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }

   egress {
    protocol   = "tcp"
    rule_no    = 111
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }
   
  #----------------------------------------------------------
  #                          SSH
  #----------------------------------------------------------
  ingress {
    protocol   = "tcp"
    rule_no    = 120
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 22
    to_port    = 22
  }

   egress {
    protocol   = "tcp"
    rule_no    = 120
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 22 
    to_port    = 22
  } 
  
  
tags = {
    Name = "ACL-DevOps"
}
}


#--------------------------------------------------------------
#                      INTERNET GATEWAY
#--------------------------------------------------------------

resource "aws_internet_gateway" "IGW_CursoDevOps" {
 vpc_id = aws_vpc.VPC_CursoDevOps.id
 tags = {
        Name = "IG - CursoDevOps"
}
} 

#--------------------------------------------------------------
#                   ROTA PÚBLICA SUBNET PUB
#--------------------------------------------------------------

resource "aws_route_table" "Pub1_rt" {
 vpc_id = aws_vpc.VPC_CursoDevOps.id
 tags = {
        Name = "RT_Pub1"
}
} 

#--------------------------------------------------------------
#                  ROTA PRIVADA SUBNET PRIV 1
#--------------------------------------------------------------

resource "aws_route_table" "Priv1_rt" {
 vpc_id = aws_vpc.VPC_CursoDevOps.id
 tags = {
        Name = "RT_Priv1"
}
} 

#--------------------------------------------------------------
#                  ROTA PRIVADA SUBNET PRIV 2 Publica
#--------------------------------------------------------------

resource "aws_route_table" "Priv2_rt" {
 vpc_id = aws_vpc.VPC_CursoDevOps.id
 tags = {
        Name = "RT_Priv2"
}
} 

#--------------------------------------------------------------
#                   ROTA PARA INTENET SUBNET1
#--------------------------------------------------------------

resource "aws_route" "acesso_internet" {
  route_table_id         = aws_route_table.Pub1_rt.id
  destination_cidr_block = var.publicdestCIDRblock
  gateway_id             = aws_internet_gateway.IGW_CursoDevOps.id
}

# Rotas temporárias
resource "aws_route" "acesso_internet2" {
  route_table_id         = aws_route_table.Priv1_rt.id
  destination_cidr_block = var.publicdestCIDRblock
  gateway_id             = aws_internet_gateway.IGW_CursoDevOps.id
}

resource "aws_route" "acesso_internet3" {
  route_table_id         = aws_route_table.Priv2_rt.id
  destination_cidr_block = var.publicdestCIDRblock
  gateway_id             = aws_internet_gateway.IGW_CursoDevOps.id
}

#--------------------------------------------------------------
#                  Associando rota a subnet
#--------------------------------------------------------------

# Associação a subnet 1 - Pública
resource "aws_route_table_association" "Pub_associacao" {
  subnet_id      = aws_subnet.Pub_subnet1.id
  route_table_id = aws_route_table.Pub1_rt.id
}
# Associação a subnet 2 - Privada
resource "aws_route_table_association" "Priv1_associacao" {
  subnet_id      = aws_subnet.Priv_subnet1.id
  route_table_id = aws_route_table.Priv1_rt.id
}
# Associação a subnet 3 - Privada
resource "aws_route_table_association" "Priv2_associacao" {
  subnet_id      = aws_subnet.Priv_subnet2.id
  route_table_id = aws_route_table.Priv2_rt.id
}

#--------------------------------------------------------------
#                      SECURITY GROUP
#--------------------------------------------------------------
#                    SG 1 - BALANCEADOR
#--------------------------------------------------------------

resource "aws_security_group" "srv_lb_sg" {
  name           = "lb_sg"
  description    = "SG para acesso externo - HAproxy"
  vpc_id         = aws_vpc.VPC_CursoDevOps.id

  tags = {
        Name = "srv_lb_sg"
    } 
  
  # Todas as políticas liberadas temporariamente
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.ingressCIDRblock
  }   

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.egressCIDRblock
  }

}

#--------------------------------------------------------------
#                     SG 2 - SERVIÇOS
#--------------------------------------------------------------

resource "aws_security_group" "srv_svc_sg" {
  name           = "svc_sg"
  description    = "SG para o docker"
  vpc_id         = aws_vpc.VPC_CursoDevOps.id

  tags = {
        Name = "srv_svc_sg"
    } 
  # Todas as políticas liberadas temporariamente
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.ingressCIDRblock
  # security_groups = [aws_security_group.srv_lb_sg.id, aws_security_group.srv_mt_sg.id]
  }   

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.egressCIDRblock
  # security_groups = [aws_security_group.srv_lb_sg.id, aws_security_group.srv_mt_sg.id]
  }

}

#--------------------------------------------------------------
#                     SG 3 - MONITORAMENTO
#--------------------------------------------------------------

resource "aws_security_group" "srv_mt_sg" {
  name           = "mt_sg"
  description    = "SG para o zabbix e grafana"
  vpc_id         = aws_vpc.VPC_CursoDevOps.id

  tags = {
        Name = "srv_mt_sg"
    } 
  
  # Todas as políticas liberadas temporariamente
  ingress {
    description = "Todas as politicas liberadas temporariamente"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.ingressCIDRblock
   # security_groups = [aws_security_group.srv_lb_sg.id]
   # security_groups = [aws_security_group.srv_lb_sg.id, aws_security_group.srv_svc_sg.id]
    
  }   

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.egressCIDRblock
  # security_groups = [aws_security_group.srv_lb_sg.id]
  # security_groups = [aws_security_group.srv_lb_sg.id, aws_security_group.srv_svc_sg.id]
  }

}

#--------------------------------------------------------------
#                       INSTÂNCIAS EC2 
#--------------------------------------------------------------
#                  INSTÂNCIA 1 - BALANCEADOR
#--------------------------------------------------------------
# Serviços a serem rodados:
# HAproxy
#--------------------------------------------------------------
resource "aws_instance" "lb_ec2" {
    instance_type          = var.typeInstance
    ami                    = var.amiUbuntu
    key_name               = var.key_name

    # Grupo de segurança 
    vpc_security_group_ids = [aws_security_group.srv_lb_sg.id]
    subnet_id              = aws_subnet.Pub_subnet1.id
    
    # Tags da instância
    tags = {
        Name = "SRV_LB"
    }   
}

#--------------------------------------------------------------
#                  INSTÂNCIA 2 - SERVIÇOS
#--------------------------------------------------------------
# Serviços a serem rodados:
# docker
# mcedit
# nfs-common
# nano
# net-tools
#--------------------------------------------------------------

resource "aws_instance" "svc_ec2" {
    instance_type          = var.typeInstance
    ami                    = var.amiUbuntu
    key_name               = var.key_name

    # Grupo de segurança 
    vpc_security_group_ids = [aws_security_group.srv_svc_sg.id]
    subnet_id              = aws_subnet.Priv_subnet1.id
    
    # Tags da instância
    tags = {
        Name = "SRV_SVC"
    }   
}

#--------------------------------------------------------------
#                  INSTÂNCIA 3 - MONITORAMENTO
#--------------------------------------------------------------
# Serviços a serem rodados:
# zabbix
# grafana
#--------------------------------------------------------------

resource "aws_instance" "mt_ec2" {
    instance_type          = var.typeInstance
    ami                    = var.amiUbuntu
    key_name               = var.key_name

    # Grupo de segurança 
    vpc_security_group_ids = [aws_security_group.srv_mt_sg.id]
    subnet_id              = aws_subnet.Priv_subnet2.id
    
    # Tags da instância
    tags = {
        Name = "SRV_MT"
    }   
}

