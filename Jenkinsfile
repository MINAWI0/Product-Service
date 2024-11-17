pipeline { 
    agent any
    tools {
        jdk 'Java17'
        maven 'Maven3'
    }
    environment {
        REPO_URL = 'https://github.com/MINAWI0/Product-Service.git'
        REGISTRY = 'minaouimh/ai'
        REGISTRY_CREDENTIAL = 'dockerhub'
        SONARQUBE_CREDENTIALS_ID = 'sonar'
    }
    stages {
        stage('clean work-space') {
            steps {
                cleanWs()
            }
        }
        stage('Checkout from SCM') {
            steps {
                git branch: 'main',
                credentialsId: 'github',
                url: REPO_URL
            }
        }
        stage('Build Application') {
            steps {
                sh 'mvn clean package'
            }
        }
        stage('Test Application') {
            steps{
                sh 'mvn test'
            }
        }
        stage('sonar analysis') {
            steps {
                withSonarQubeEnv(installationName: 'sonar' , credentialsId: SONARQUBE_CREDENTIALS_ID) {
                    sh 'mvn sonar:sonar'
                }
            }
        }
        stage('Quality gate') {
            steps {
                script {
                    waitForQualityGate abortPipeline: false ,  credentialsId: SONARQUBE_CREDENTIALS_ID
                }
            }
        }
        stage('Docker Build and Push') {
            steps {
                script {
                    def repoName = REPO_URL.tokenize('/').last().replaceAll('.git', '')
                    docker.withRegistry('', REGISTRY_CREDENTIAL) {
                        DOCKER_IMAGE = docker.build("${REGISTRY}:${repoName}-${BUILD_NUMBER}")
                        DOCKER_IMAGE.push()
                    }
                }
            }
        }
    }
}
