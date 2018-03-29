# Testbed-UserSessionExport
Starts the demo application Easytravel, a load generator, and an instance with Elasticsearch and Kibana, where user session can be exported to, in AWS.

## Architecture
<add image here>

## Prerequisites
* Make sure you have [HashiCorp](http://www.hashicorp.com)s [Packer](http://www.packer.io) (used for creating images) and [HashiCorp](http://www.hashicorp.com)s [Terraform](http://www.terraform.io) (used for provisioning the cloud infrastructure components) installed
* Have your Dynatrace environment ID and API token ready (learn more [here](https://www.dynatrace.com/support/help/get-started/introduction/why-do-i-need-an-access-token-and-an-environment-id/?_ga=2.98498396.219005478.1522220422-2076053113.1510299770))
* Have your AWS credentials and an AWS EC2 keypair ready (learn more [here](https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#access-keys-and-secret-access-keys))

## Instructions
Clone the repository
```sh
$ git clone https://github.com/dynatrace-innovationlab/Testbed-UserSessionExport
$ cd Testbed-UserSessionExport
```

Provide your AWS credentials in a [Shared credentials file](https://www.terraform.io/docs/providers/aws/index.html#shared-credentials-file) so both Packer and Terraform can make use of it and you don't have to provide your credentials in two different locations.
```sh
$ cat ~/.aws/credentials
[default]
aws_access_key_id=<AWS_ACCES_KEY_ID>
aws_secret_access_key=<AWS_SECRET_ACCESS_KEY>
```

Provide the AWS region, the instance flavor, the AWS keypair name, the Dynatrace environment ID, Dynatrace API token, and the path to the private key file in `terraform/terraform.tfvars`
```sh
aws_region = "<AWS_REGION>"
aws_flavor = "<AWS_FLAVOR>"
aws_keypair_name = "<AWS_KEYPAIR_NAME>"
aws_owner = "<OWNER>"
dynatrace_environment_id = "<DYNATRACE_ENVIRONMENT_ID>"
dynatrace_api_token = "<DYNATRACE_API_TOKEN>"
private_key_file = "<PATH_TO_PRIVATE_KEY_FILE>"
```

Build the AMIs with [Packer](http://www.packer.io)
```sh
$ pwd
~/TestBed-UserSessionExport/packer
$ packer build easytravel.json
... (output emitted) ...
$ packer build elastic.json
... (output emitted) ...
$ packer build loadgenerator.json
... (output emitted) ...
```

Run [Terraform](http://www.terraform.io)
```sh
$ pwd
~/TestBed-UserSessionExport/terraform
$ terraform plan
... (output emitted) ...
$ terraform apply
...
xxx Elastic password = <PASSWORD>
...
Apply complete! Resources: x added, x changed, x destroyed.

Outputs:

Easytravel = <PRIVATE_IP>/<PUBLIC_IP>
Elastic = <PRIVATE_IP>/<PUBLIC_IP>
Load Generator = <PRIVATE_IP>/<PUBLIC_IP>
```
