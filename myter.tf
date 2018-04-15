####Variables#####

variable "region" {
  default = "us-west-2"
}

variable "vpccidr" {
    default = "10.0.0.0/16"
  description = "This is the vpc cdir"
}
variable "pubsubnet1" {
  default = "10.0.1.0/24"
  description = "This is the cidr for Public subnet1"
}
variable "prisubnet1" {
  default = "10.0.2.0/24"
  description = "This is cidr for private subnet1"
}

variable "pubsubnet2" {
  default = "10.0.3.0/24"
  description = "This is the cidr for Public subnet2"
}
variable "prisubnet2" {
  default = "10.0.4.0/24"
  description = "This is cidr for private subnet2"
}
#####Provider#####
provider "aws" {
 region     = "${var.region}"
}

#####VPC Creation#####
resource "aws_vpc" "vpc" {
  cidr_block = "${var.vpccidr}"
 
  tags {
    Name = "TerraTestVPC"
  }
}

####Data Sources for AZs######

data "aws_availability_zone" "az1" {
 name = "us-west-2a"
}

data "aws_availability_zone" "az2" {
 name = "us-west-2b"
}




#####Subnets Creation#####

resource "aws_subnet" "pubsub1" {
  vpc_id     = "${aws_vpc.vpc.id}"
  cidr_block = "${var.pubsubnet1}"
  map_public_ip_on_launch = true
  availability_zone = "${data.aws_availability_zone.az1.name}"

  tags {
    Name = "TerraPubSub1"
  }
}

resource "aws_subnet" "prisub1" {
  vpc_id     = "${aws_vpc.vpc.id}"
  cidr_block = "${var.prisubnet1}"
  availability_zone = "${data.aws_availability_zone.az1.name}"

  tags {
    Name = "TerraPriSub1"
  }
}


resource "aws_subnet" "pubsub2" {
  vpc_id     = "${aws_vpc.vpc.id}"
  cidr_block = "${var.pubsubnet2}"
  map_public_ip_on_launch = true
  availability_zone = "${data.aws_availability_zone.az2.name}"

  tags {
    Name = "TerraPubSub2"
  }
}

resource "aws_subnet" "prisub2" {
  vpc_id     = "${aws_vpc.vpc.id}"
  cidr_block = "${var.prisubnet2}"
  availability_zone = "${data.aws_availability_zone.az2.name}"

  tags {
    Name = "TerraPriSub2"
  }
}

####IGW#####
resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "TerraIGW"
  }
}

######Route Table######

resource "aws_route_table" "r" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags {
    Name = "TerraRouteTable"
  }
}

### Subnet Associations to Route Table####
resource "aws_route_table_association" "a" {
  route_table_id = "${aws_route_table.r.id}"
  subnet_id      = "${aws_subnet.pubsub1.id}"
  subnet_id      = "${aws_subnet.pubsub2.id}"
}



#####Security Group######
resource "aws_security_group" "sec" {
  name        = "allow_all"
  description = "Allow all inbound traffic"
  vpc_id = "${aws_vpc.vpc.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "TerraSecGrp"
  }
}

#####Spinning EC2 Instance####
resource "aws_instance" "myins" {
    ami = "ami-223f945a" # us-west-2
    instance_type = "t2.micro"
    associate_public_ip_address = "true"
    subnet_id = "${aws_subnet.pubsub1.id}"
    vpc_security_group_ids = ["${aws_security_group.sec.id}"] 
  
}
 

