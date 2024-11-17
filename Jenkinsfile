pipeline { 
    agent any
    tools {
        jdk 'Java17'
        maven 'Maven3'
    }
    environment{
        REPO_URL = 'https://github.com/MINAWI0/Product-Service.git' // Static value
        REGISTRY = 'minaouimh/ai'
        REGISTRY_CREDENTIAL = 'dockerhub'
        dockerImage = ''
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
                withSonarQubeEnv(installationName: 'sonar' , credentialsId:'sonar'){
                    sh 'mvn sonar:sonar'
                }
            }
        }
        stage('Quality gate') {
            steps {
                script {
                    waitForQualityGate abortPipeline: false ,  credentialsId: 'sonar'
                }
            }
        }
        stage('Docker Build and Push') {
            steps {
                script{
                    docker.withRegistry('', REGISTRY_CREDENTIAL) {
                        DOCKER_IMAGE = docker.build("${REGISTRY}:${BUILD_NUMBER}")
                        DOCKER_IMAGE.push()
                    }
                }
            }
        }
    }
}
