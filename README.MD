
# Provisionamento e configuração de ambiente em nuvem.

## Tools
```
- Terraform
- Ansible
- Haproxy
- Aws
- Zabbix
- Grafana
- Docker
```

## Modelagem do ambiente 

![](/imagens/terraform-aws.jpg)

---

![](/imagens/terraform-aws.jpeg)


## Provider AWS: 
- VPC
```
- vpc : 10.0.0.0/16
```

## Elastic Cloud Computer
- Balanceador - Haproxy
```
- Instância: T2 MICRO
- Subnet Pública com acesso externo: 10.0.1.0/24
- Serviços: haproxy
- Acesso as demais instâncias  onde seus serviços serão acessados por meio desse balanceador.
```
- Serviços - SpringApp
```
- Instância: T2 MICRO
- Subnet Privada sem acesso externo: 10.0.2.0/24
- Será acessada por meio do haproxy
- Instalar e configurar : docker, mcedit, nfs-common, nano, net-tools
- Subir um serviço em docker que tenha rota de teste
```
- Monitoramento - Zabbix e Grafana
```
- Instância: T2 MICRO
- Subnet Privada sem acesso externo: 10.0.3.0/16
- Serviços: Zabbix e Grafana
- Integrar o zabbix com grafana
- Zabbix: Monitora a Instância de balanceamento e de serviços
- O acesso do Grafana e Zabbix externamente sera via haproxy (instalado na instância do balanceador)
```
