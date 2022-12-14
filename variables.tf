variable "prefix" {
    type = string
    description = "Prefix for all resources being created"
    default = "1520"
    nullable = false
}

variable "environment" {
    type = string
    description = "Environment in which all resources should be created"
    default = "dev"
    nullable = false
}

variable "instance_type" {
    type = string
    description = "Instance size/family used in launch template"
    default = "t2.micro"    
}

variable "image_id" {
    type = string
    description = "Image Id used in launch template"
    #default = "ami-0b0dcb5067f052a63"
    default = "ami-0fe5f366c083f59ca"
}

variable "block_device_name" {
    type = string
    description = "The device name (for example, /dev/sdh or xvdh)"
    default = "/dev/sdh"
}

variable "disk_size" {
    type = string
    description = "EBS volume size used in launch template"
    default = "8"
}

variable "disk_type" {
    type = string
    description = "EBS volume type used in launch template"
    default = "gp2"
}

variable "key_pair_name" {
    type = string
    description = "The name of the key pair used to connect to ec2 instances."
    default = "AMtestkey"
}

variable "asg_min_size" {
    type = string
    description = "Auto scaling group minimum size"
    default = "2"
}

variable "asg_max_size" {
    type = string
    description = "Auto scaling group maximum size"
    default = "3"
}

variable "asg_desired_size" {
    type = string
    description = "Auto scaling group desired size"
    default = "2"
}

variable "ecs_service_desired_size" {
    type = string
    description = "ECS service desired count"
    default = "1"
}

variable "ip_whitelist" {
    type = string
    description = "IP address used to access instances (for example, a single IPv4 address with the /32 prefix length or a range of IPv4 addresses in CIDR block notation)"
    default = "0.0.0.0/0"
}

variable "db_name" {
    type = string
    description = "Name of the database"
    default = "petclinic"
}

variable "db_identifier" {
    type = string
    description = "Name of the RDS instance"
    default = "petclinic"
}

variable "db_username" {
    type = string
    description = "Username to the database"
    default = "petclinic"
}

variable "db_password" {
    type = string
    description = "Password to the database"
    default = "petclinic"
}

variable "db_instance_class" {
    type = string
    description = "Instance class of the database"
    default = "db.t3.micro"
}

variable "db_storage_type" {
    type = string
    description = "Storage type of the database"
    default = "gp2"
}

variable "alarm_threshold" {
    type = string
    description = "ECS CPUUtilization monitoring threshold"
    default = "1"
}