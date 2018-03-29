# Testbed-UserSessionExport
Starts the demo application Easytravel, a load generator, and an instance with Elasticsearch and Kibana, where user session can be exported to, in AWS.

## Architecture
<add image here>

## Prerequisites
* Make sure you have [HashiCorp](http://www.hashicorp.com)s [Packer](http://www.packer.io) (used for creating images) and [HashiCorp](http://www.hashicorp.com)s [Terraform](http://www.terraform.io) (used for provisioning the cloud infrastructure components) installed
* Have your Dynatrace environment ID and token ready
* Have your AWS credentials and an AWS EC2 keypair ready

## Instructions
Clone the repository
```sh
$ git clone https://github.com/dynatrace-innovationlab/Testbed-UserSessionExport
$ cd Testbed-UserSessionExport
```

Provide your AWS credentials in a [Shared credentials file](https://www.terraform.io/docs/providers/aws/index.html#shared-credentials-file)
```sh
$ cat ~/.aws/credentials
[default]
aws_access_key_id=<AWS_ACCES_KEY_ID>
aws_secret_access_key=<AWS_SECRET_ACCESS_KEY>
```

Provide the AWS region, the instance flavor, the AWS keypair name, the Dynatrace environment ID, and Dynatrace API token in `terraform.tfvars`
```sh
aws_region = "<AWS_REGION>"
aws_flavor = "<AWS_FLAVOR>"
aws_keypair_name = "<AWS_KEYPAIR_NAME>"
aws_owner = "<OWNER>"
dynatrace_environment_id = "<DYNATRACE_ENVIRONMENT_ID>"
dynatrace_api_token = "<DYNATRACE_API_TOKEN>"
```

Build the AMIs with [Packer](http://www.packer.io)
```sh
$ cd packer
$ packer build easytravel.json
... (output emitted) ...
$ packer build elastic.json
... (output emitted) ...
$ packer build loadgenerator.json
... (output emitted) ...
```

Run [Terraform](http://www.terraform.io)
```sh
$ cd terraform
$ terraform plan
... (output emitted) ...
$ terraform apply
...
Apply complete! Resources: x added, x changed, x destroyed.

Outputs:

Easytravel public IP = x.x.x.x
Elastic public IP = x.x.x.x
Loadgenerator public IP = x.x.x.x
```
