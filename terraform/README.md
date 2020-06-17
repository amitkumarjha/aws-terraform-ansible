# Aws-Terraform-Ansible
Repository for the creating aws instance  using terrafomr

####Export the aws credentials like this

```
#> export AWS_ACCESS_KEY_ID="**************"
#> export AWS_SECRET_ACCESS_KEY="**************"
```

####Create the Infrastructure like this

Create the networking and common stack
```buildoutcfg
#> cd common
#common> terraform init && terraform plan && terraform apply -auto-approve -lock=true

```
Before create the bastion server we need to create a key that will be used to have the global
keys to access the servers.
Create the bastion server for ssh authentication
```buildoutcfg
#> cd bastion
#bastion> ssh-keygen -f bastion_public_key
#bastion> terraform init && terraform plan && terraform apply -auto-approve -lock=true
```

Finally create the elastic search node
```buildoutcfg
#> cd elasticsearch
#elasticsearch> terraform init && terraform plan && terraform apply -auto-approve -lock=true
```

