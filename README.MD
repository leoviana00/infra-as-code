
## Modelagem do ambiente 

![](/imagens/terraform-aws.jpg)

----

![](/imagens/terraform-aws.jpeg)



# Provisionamento de ambiente em cloud com terraform e instalação e configuração de alguns serviços com ansible.

# Provider AWS

- vpc : 10.0.0.0/16

# 1 Instancia para o balanceador (haproxy)

- Instância: T2 MICRO
- Subnet Pública com acesso externo: 10.0.1.0/24
- Serviços: haproxy
- Acesso as demais instâncias  onde seus serviços serão acessados por meio desse balanceador.

# 1 Instância para para rodar os serviços em containers (Docker)

- Instância: T2 MICRO
- Subnet Privada sem acesso externo: 10.0.2.0/24
- Será acessada por meio do haproxy
- Instalar e configurar : docker, mcedit, nfs-common, nano, net-tools
- Subir um serviço em docker que tenha rota de teste

# 1 Instância para monitoramento - (zabbix e grafana )

- Instância: T2 MICRO
- Subnet Privada sem acesso externo: 10.0.3.0/16
- Serviços: Zabbix e Grafana
- Integrar o zabbix com grafana
- Zabbix: Monitora a Instância de balanceamento e de serviços
- O acesso do Grafana e Zabbix externamente sera via haproxy (instalado na instância do balanceador)
