def AWS_CREDENTIALS = [[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: CREDENTIALS_ID_AWS, accessKeyVariable: 'AWS_ACCESS_KEY_ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]

pipeline {
	agent {
		kubernetes {
			label 'default'
			defaultContainer 'ruby-testbed'
		}
	}
	
	stages {
		stage('Prepare') {
			steps {
				dir('terraform') {
					sh script: """\
						apt-get update && apt-get install -y unzip \
						wget https://releases.hashicorp.com/terraform/0.11.7/terraform_0.11.7_linux_amd64.zip \
						unzip terraform_0.11.7_linux_amd64.zip \
						mv terraform /usr/bin/terraform \
						rm terraform_0.11.7_linux_amd64.zip \
						ssh-keygen -f ~/.ssh/cloud.key -t rsa -b 4096 -q -N "" \
						gem install bundler \
						bundle install
					"""
				}
			}
		}
		
		stage('Converge') {
			steps {
				dir('terraform') {
					withCredentials(AWS_CREDENTIALS) {
						sh('bundle exec kitchen converge')
					}
				}
			}
		}

		stage('Verify') {
			steps {
				dir('terraform') {
					withCredentials(AWS_CREDENTIALS) {
						sh('bundle exec kitchen verify')
					}
				}
			}
		}
		
		stage('Destroy') {
			steps {
				dir('terraform') {
					withCredentials(AWS_CREDENTIALS) {
						sh('bundle exec kitchen destroy')
					}
				}
			}
		}
	}
}