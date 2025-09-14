provider "aws"{
    region = "ap-south-1"
}

resource "aws_instance" "terra-demo" {
    ami = "ami-0b982602dbb32c5bd"
    instance_type = "t3.micro"
    key_name = "ops"

}

