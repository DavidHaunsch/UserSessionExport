# Testbed-UserSessionExport
Starts the demo application [Sock Shop](https://microservices-demo.github.io/), a load generator using [CasperJS](http://casperjs.org), and an instance with Elasticsearch and Kibana, where user session can be exported to, in AWS. Find an accompanying blog article about Dynatrace user session export [here][1].

## Prerequisites
* Make sure you have [HashiCorp](http://www.hashicorp.com)s [Terraform](http://www.terraform.io) (used for provisioning the cloud infrastructure components) installed
* Have your Dynatrace environment ID and API token ready (learn more [here](https://www.dynatrace.com/support/help/get-started/introduction/why-do-i-need-an-access-token-and-an-environment-id/?_ga=2.98498396.219005478.1522220422-2076053113.1510299770))
* Have your AWS credentials and an AWS EC2 keypair ready (learn more [here](https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#access-keys-and-secret-access-keys))

## Instructions
**1. Clone the repository**

```sh
$ git clone https://github.com/dynatrace-innovationlab/Testbed-UserSessionExport
$ cd Testbed-UserSessionExport
```

**2. Provide AWS access**

Provide your AWS credentials in a [Shared credentials file](https://www.terraform.io/docs/providers/aws/index.html#shared-credentials-file) so both Packer and Terraform can make use of it and you don't have to provide credentials in two different locations.

```sh
$ cat ~/.aws/credentials
[default]
aws_access_key_id=<AWS_ACCES_KEY_ID>
aws_secret_access_key=<AWS_SECRET_ACCESS_KEY>
```

**3. Provide AWS and Dynatrace data**

Provide AWS region, the AWS keypair name, the Dynatrace environment ID, Dynatrace API token, and the path to the private key file in `terraform/vars.tf`. Adapt the recommended AWS instance flavors, if needed.

```sh
variable "aws_region" {
  default = ""
}

variable "aws_flavor_elastic" {
  default = "t2.small"
}

variable "aws_flavor_loadgen" {
  default = "t2.xlarge"
}

variable "aws_flavor_sockshop" {
  default = "t2.xlarge"
}

variable "aws_keypair_name" {
  default = ""
}

variable "dynatrace_environment_id" {
  default = ""
}

variable "dynatrace_api_token" {
  default = ""
}

variable "private_key_file" {
  default = ""
}
```

**4. Run [Terraform](http://www.terraform.io)**

```sh
$ pwd
~/TestBed-UserSessionExport/terraform
$ terraform init
... (output emitted) ...
$ terraform plan
... (output emitted) ...
$ terraform apply
...
Apply complete! Resources: x added, x changed, x destroyed.

Outputs:

Elastic/Kibana = <PRIVATE_IP>/<PUBLIC_IP>
Load Generator = <PRIVATE_IP>/<PUBLIC_IP>
Sock Shop = <PRIVATE_IP>/<PUBLIC_IP>
```

**5. Finalize Dynatrace configuration**

* Follow the instructions [here][1] to enalbe the user session export to Elasticsearch.

**6. Check that there is user session data in Kibana**

![User sessions in Kibana](https://github.com/dynatrace-innovationlab/Testbed-UserSessionExport/raw/master/kibanaUserSessions.png)

**7. Stop demo environment**
In order to shutdown the demo environment and get rid of all created artefacts you need to manually remove the created AMIs and execute the following Terraform command.

```sh
$ pwd
~/TestBed-UserSessionExport/terraform
$ terraform destroy
```

[1]: https://www.dynatrace.com/news/blog/export-dynatrace-user-session-data-use-3rd-party-systems/
