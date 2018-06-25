#!groovy

def AWS_CREDENTIALS = [[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'ae77cb24-5cee-43bb-adf5-1cbc197fb43b', accessKeyVariable: 'AWS_ACCESS_KEY_ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]

pipeline {
	agent {
		kubernetes {
			label 'user-session-export'
			defaultContainer 'ruby'
		}
	}

	options {
		disableConcurrentBuilds()
		buildDiscarder(logRotator(numToKeepStr: ('50')))
		timeout(time: 60, unit: 'MINUTES')
		timestamps()
	}

	stages {
		stage('Prepare') {
			steps {
				dir('terraform') {
					sh("apt-get update && apt-get install -y unzip")
					sh('wget https://releases.hashicorp.com/terraform/0.11.7/terraform_0.11.7_linux_amd64.zip')
					sh('unzip terraform_0.11.7_linux_amd64.zip')
					sh('mv terraform /usr/bin/terraform')
					sh('rm terraform_0.11.7_linux_amd64.zip')
					sh('gem install bundler')
					sh('bundle install')
					sh('mkdir ~/.ssh && ssh-keygen -f ~/.ssh/cloud.key -t rsa -b 4096 -q -N \"\"')
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
	}
	post {
		always {
			script {
				dir('terraform') {
					withCredentials(AWS_CREDENTIALS) {
						sh('bundle exec kitchen destroy')
					}
				}
			}
		}
	}
}