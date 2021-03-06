[![Build Status](https://travis-ci.org/dynatrace-innovationlab/UserSessionExport.svg?branch=master)](https://travis-ci.org/dynatrace-innovationlab/UserSessionExport)

# UserSessionExport
Starts the demo application [Sock Shop](https://microservices-demo.github.io/), a load generator using [CasperJS](http://casperjs.org), and an instance with Elasticsearch and Kibana, where user session can be exported to, in AWS. Find an accompanying blog article about Dynatrace user session export [here][1].

## Overview

![Testbed overview](https://github.com/dynatrace-innovationlab/Testbed-UserSessionExport/raw/master/assets/overview.png)

## Prerequisites
* Make sure you have [HashiCorp](http://www.hashicorp.com)s [Terraform](http://www.terraform.io) installed
* Have your Dynatrace SaaS ([Free trial](https://www.dynatrace.com/trial)) environment ID and API token ready (learn more [here](https://www.dynatrace.com/support/help/get-started/introduction/why-do-i-need-an-access-token-and-an-environment-id/?_ga=2.98498396.219005478.1522220422-2076053113.1510299770))
* Have your AWS credentials and an AWS EC2 keypair ready (learn more [here](https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#access-keys-and-secret-access-keys))

## Instructions
**1. Clone the repository**

```sh
$ git clone https://github.com/dynatrace-innovationlab/UserSessionExport
$ cd UserSessionExport
```

**2. Provide AWS access**

Provide your AWS credentials in a [Shared credentials file](https://www.terraform.io/docs/providers/aws/index.html#shared-credentials-file) so Terraform can use it.

```sh
$ cat ~/.aws/credentials
[default]
aws_access_key_id=<AWS_ACCES_KEY_ID>
aws_secret_access_key=<AWS_SECRET_ACCESS_KEY>
```

**3. Provide AWS and Dynatrace data**

Provide AWS region, the AWS keypair name, and a prefix in `terraform/vars.tf`. Adapt the recommended AWS instance flavors, if needed. Set environment variables for the Dynatrace data, or provide the variables when executing the terraform commands.

```sh
$ export TF_VAR_dynatrace_environment_id=abc12345
$ export TF_VAR_dynatrace_api_token=abcdef123456789abcdef1234567890
```

**4. Run [Terraform](http://www.terraform.io)**

```sh
$ pwd
~/UserSessionExport/terraform
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

* In Dynatrace you should see an Application with steady load and user sessions.
* Follow the instructions [here][1] to enable the user session export to Elasticsearch in Dynatrace.

**6. Check that there is user session data in Kibana**

* You need to create an index pattern in Kibana to be able to browse the data. The index to which data is sent has been configured in step 5.

![User sessions in Kibana](https://github.com/dynatrace-innovationlab/Testbed-UserSessionExport/raw/master/assets/kibanaUserSessions.png)

**7. Stop demo environment**
In order to shutdown the demo environment and get rid of all created artefacts you need to manually remove the created AMIs and execute the following Terraform command.

```sh
$ pwd
~/TestBed-UserSessionExport/terraform
$ terraform destroy
```

**8. Execute tests**

Prerequisites: 
* Make sure you have [Ruby](https://www.ruby-lang.org/) installed
* As in step 3, provide the path to the private key file (e.g. "~/.ssh/key.pem") in `terraform/.kitchen.yml`

```sh
$ pwd
~/UserSessionExport/terraform
$ gem install bundler
... (output omitted) ...
$ bundle install
... (output omitted) ...

// setup test environment using kitchen-terraform
$ bundle exec kitchen converge
... (output omitted) ...

// run tests against said environment (can be repeated several times)
$ bundle exec kitchen verify
... (output omitted) ...

// destroy test environment
$ bundle exec kitchen destroy
```

[1]: https://www.dynatrace.com/news/blog/export-dynatrace-user-session-data-use-3rd-party-systems/
