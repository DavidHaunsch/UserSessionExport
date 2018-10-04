#!groovy

def AWS_CREDENTIALS = [[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'ae77cb24-5cee-43bb-adf5-1cbc197fb43b', accessKeyVariable: 'AWS_ACCESS_KEY_ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']]

pipeline {
	agent {
		kubernetes {
			label 'user-session-export'
			defaultContainer 'ruby'
		}
	}

	environment {
		TF_VAR_dynatrace_environment_id = credentials('d6451612-c2ca-48f4-9794-a14bd0dbac2c')
		TF_VAR_dynatrace_api_token = credentials('fb65580b-235a-41be-af81-fffd06320fc4')
	}
	
	options {
		disableConcurrentBuilds()
		buildDiscarder(logRotator(numToKeepStr: (env.BRANCH_NAME == 'master') ? '30' : '5'))
		timeout(time: 3, unit: 'HOURS')
		timestamps()
	}

	triggers {
		cron((env.BRANCH_NAME == 'master') ? 'H 0 * * *' : '')
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
		
		failure {
			script {
				withCredentials([string(credentialsId: 'e85a1bb2-96fa-42fa-8230-7decf949cef8', variable: 'emailRecipient')]) {
					sendEmail(emailRecipient)
				}
			}
		}
	}
}