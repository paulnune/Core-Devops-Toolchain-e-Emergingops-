name                = "paulonunes"
environments        = "coredevops"
region              = "us-east-1"
instance_type       = "t3.small"
instance_name       = "elastic"
instance_ami        = "ami-08c40ec9ead489470"
ebs_root_type       = "gp3"
ebs_root_size_in_gb = 32
key_pair            = "paulonunes"
default_tags = {
  owner     = "paulonunes"
  subject   = "coredevops"
  managedby = "terraform"
  contact   = "paulo.nunes@live.de"
  mba       = "fiap"
}
