# process-explorer-in-windows-server

## 0. create dev.tfvars

```bash
# create dev.tfvars
touch dev.tfvars

# create access key from AWS console
# see https://aws.amazon.com/jp/premiumsupport/knowledge-center/create-access-key/

# set and confirm keys
cat dev.tfvars
region         = "us-east-1"
aws_access_key = "xxxx"
aws_secret_key = "xxxx"

```

## 1. terraform init / plan
```bash
❯ terraform init

❯ terraform plan -var-file=./dev.tfvars

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_instance.process_explorer_server will be created
  + resource "aws_instance" "process_explorer_server" {
    ...

      + public_key_fingerprint_md5    = (known after apply)
      + public_key_fingerprint_sha256 = (known after apply)
      + public_key_openssh            = (known after apply)
      + public_key_pem                = (known after apply)
      + rsa_bits                      = 4096
    }

Plan: 4 to add, 0 to change, 0 to destroy.

────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.
```

## 2. terraform apply

```bash
❯ terraform apply -var-file=./dev.tfvars

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_instance.process_explorer_server will be created
  + resource "aws_instance" "process_explorer_server" {

      ...
      + public_key_pem                = (known after apply)
      + rsa_bits                      = 4096
    }

Plan: 4 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

tls_private_key.key_pair: Creating...
tls_private_key.key_pair: Creation complete after 1s [id=01b56254ffed773015e2cf20a2f4db41b019e162]
aws_key_pair.key_pair: Creating...
aws_key_pair.key_pair: Creation complete after 2s [id=windows-key-pair]
local_file.ssh_key: Creating...
local_file.ssh_key: Creation complete after 0s [id=c81fcd40b05f4be455c034bac6febabe2c241c61]
aws_instance.process_explorer_server: Creating...
...
aws_instance.process_explorer_server: Still creating... [30s elapsed]
aws_instance.process_explorer_server: Still creating... [40s elapsed]
aws_instance.process_explorer_server: Creation complete after 49s [id=i-094c37b1476005fad]

Apply complete! Resources: 4 added, 0 changed, 0 destroyed.
```

## 3. connect to Windows Server (RDP)

see https://dev.classmethod.jp/articles/mac-ec2-windows-rdp-connect/