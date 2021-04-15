
#Dont hard code credentials directly in the configuration file
#Provider needs to be installed in the machine with "terraform init" command in the terminal

#We need to use the terraform command "terraform init" 
#We'll use "terraform apply" to create and make changes
provider "aws" {
  #set as AWS Global user, using aws cli
}

#declare variable, there is three ways to do it.
# 1)if we dont define a value for the variable, after terraform apply commnad it asking for in the terminal
# 2)we can define the value directli in the terminal with apply: terraform apply -var "<variable_name>=value"
#example: terraform apply -var "subnet_cdr_block=10.0.10.0/24"
# 3) Create the file "terraform.tfvars"
variable "subnet_cdr_block" {
  description = "ip subnet"
  default     = "10.0.10.0/24"
  type        = string
}

resource "aws_vpc" "demo-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    "Name"    = "demo",
    "vpc_env" = "development"
  }
}

#subnet value = "10.0.10.0/24"
resource "aws_subnet" "demo-subnet-1" {
  vpc_id            = aws_vpc.demo-vpc.id
  cidr_block        = var.subnet_cdr_block
  availability_zone = "us-west-1b"
  tags = {
    "Name" = "demo-subnet-1"
  }
}

#Create an existing VPC with data
data "aws_vpc" "existing_vpc" {
  default = true
}

resource "aws_subnet" "demo-subnet-2" {
  vpc_id            = data.aws_vpc.existing_vpc.id
  cidr_block        = "172.31.48.0/20"
  availability_zone = "us-west-1b"
  tags = {
    "Name" = "demo-subnet-2"
  }
}

# #output values: they are like returb values from a function
# output "dev-vpc-id" {
#   value = awc_vpc.demo-vpc.id
# }



#There is two way to remove source
#1.- Remove directly from the main.tf file
#2.- Apply the command "destroy" as follow: terraform destroy -target <source_type>.<source_name>  
#example terraform destroy -target aws_subnet.demo-subnet-2
#However, this not a good practice, use apply instead.  
#becouse after make destroy in the shell. the file doesn corresponde to the current state

#Terrform destroy
#without any arguments, it will be destroye each resource in the order in the code was writen.
#remove, destroy, clean

#apply auto-approve, this commands allows apply chnages without our confirmation question

#PLAN: this command will show the current state and the change to apply for  desire state.
#like un Git (git status)

#this command tell us that a new resource will be add

#To clean all configurstion file


