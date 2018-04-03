# Testbed-UserSessionExport
Starts the demo application Easytravel, a load generator, and an instance with Elasticsearch and Kibana, where user session can be exported to, in AWS. Find the accompanying blog article [here][1].

## Architecture
<add image here>

## Prerequisites
* Make sure you have [HashiCorp](http://www.hashicorp.com)s [Packer](http://www.packer.io) (used for creating images) and [HashiCorp](http://www.hashicorp.com)s [Terraform](http://www.terraform.io) (used for provisioning the cloud infrastructure components) installed
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
Provide the AWS region, the AWS instance flavor, the AWS keypair name, the Dynatrace environment ID, Dynatrace API token, and the path to the private key file in `terraform/vars.tf`
```sh
variable "aws_region" {
  default = ""
}

variable "aws_flavor" {
  default = ""
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

**4. Build the AMIs with [Packer](http://www.packer.io)**
```sh
$ pwd
~/TestBed-UserSessionExport/packer
$ packer build easytravel.json
... (output emitted) ...
$ packer build elastic.json
... (output emitted) ...
```

**5. Run [Terraform](http://www.terraform.io)**
```sh
$ pwd
~/TestBed-UserSessionExport/terraform
$ terraform plan
... (output emitted) ...
$ terraform apply
...
Apply complete! Resources: x added, x changed, x destroyed.

Outputs:

Easytravel = <PRIVATE_IP>/<PUBLIC_IP>
Elastic = <PRIVATE_IP>/<PUBLIC_IP>
```

**6. Finalize Dynatrace configuration**
* Disable monitoring for ``uemload.jar`` in the Dynatrace UI in the settings. Otherwise the visits of the load generator won't be displayed correctly.
* Follow the instructions [here][1] to enalbe the user session export to Elasticsearch.

**7. Finalize Easytravel configuration**
SSH into the ``easytravel`` instance and make sure the load generator service has been started successfully
```sh
$ journalctl -fu uemload
... (check for errors) ...
```
If you encounter errors, restart the service
```sh
$ sudo service uemload restart
```
and check again.

**8. Finalize Elasticsearch/Kibana configuration**
Setup authentication of Elasticsearch and Kibana
```sh
$ sudo /usr/share/elasticsearch/bin/x-pack/setup-passwords auto
... (output omitted) ...
```
Edit ``/etc/kibana/kibana.yml`` on the Elasticsearch/Kibana instance and set the generated password for the user ``elastic`` in ``elasticsearch.password``, and restart both Elasticsearch and Kibana.

**9. Check that there is user session data in Kibana**
![User sessions in Kibana](https://github.com/dynatrace-innovationlab/Testbed-UserSessionExport/raw/master/kibanaUserSessions.png)

[1]: https://www.dynatrace.com/news/blog/export-dynatrace-user-session-data-use-3rd-party-systems/