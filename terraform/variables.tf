
variable "region" {
     default = "us-east-1"
}
variable "availabilityZone" {
     default = "us-east-1a"
}
variable "instanceTenancy" {
    default = "default"
}
variable "dnsSupport" {
    default = true
}
variable "dnsHostNames" {
    default = true
}
variable "vpcCIDRblock" {
    default = "10.0.0.0/16"
}
variable "publicsCIDRblock" {
    default = "10.0.1.0/24"
}
variable "privateCIDRblock" {
    default = "10.0.2.0/24"
}
variable "private2CIDRblock" {
    default = "10.0.3.0/24"
}
variable "publicdestCIDRblock" {
    default = "0.0.0.0/0"
}
variable "localdestCIDRblock" {
    default = "10.0.0.0/16"
}
variable "ingressCIDRblock" {
    type = list
    default = [ "0.0.0.0/0" ]
}
variable "egressCIDRblock" {
    type = list
    default = [ "0.0.0.0/0" ]
}
variable "mapPublicIP" {
    default = true
}
variable "typeInstance" {
    default = "t2.micro"
}
variable "amiUbuntu" {
    default = "ami-085925f297f89fce1"
}
variable "key_name" {
    default = "devops"
}