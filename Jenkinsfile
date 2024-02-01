pipeline {
    agent any


    environment {
        // CR_PAT = credentials('github-token')
        // add the sonar here , *****sravan***
        DOCKER_REGISTRY_CREDENTIALS = credentials('docker-creds')
        SCANNER_HOME=tool 'sonar-scanner'
        DOCKER_REGISTRY_URL = "ghcr.io"


    }

    stages {

        // stage('Checkout') {
        //     steps {
        //         // Checkout the code from your version control system (e.g., Git)
        //         checkout scm
        //     }
        // }

         stage('Checkout from Git'){
            steps{
                git branch: 'jenkins', url: 'https://github.com/sravanre/microservices-end-to-end.git'
            }
        }
        stage('Prepare for the docker login'){
            steps{
                script{
                    withCredentials([usernamePassword(credentialsId: 'docker-creds', passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                       sh """
                       docker login ghcr.io -u ${DOCKER_USERNAME} -p ${DOCKER_PASSWORD}
                       """
                       }
                }
                
            }
        }
        stage('Build and tag Adservice microservice') {
            steps {
                // Use Maven to build your microservices
                sh """
                cd src/adservice
                docker build -t ghcr.io/sravanre/adservice:V${env.BUILD_NUMBER} .
                // docker.build("${DOCKER_REGISTRY_URL}/adservice:${env.BUILD_NUMBER}", "-f ${DOCKERFILE_PATH}")
                docker push 
                """
            }
        }
        stage('Build and tag cartservice microservice') {
            steps {
                // Use Maven to build your microservices
                sh """
                cd src/cartservice/src
                docker build -t ghcr.io/sravanre/cartservice:V${env.BUILD_NUMBER} .
                docker push ghcr.io/sravanre/cartservice:V${env.BUILD_NUMBER}
                """
            }
        }

        stage("Sonarqube Analysis for recommendationservice "){
            steps{
                withSonarQubeEnv('sonar-server') {
                    sh """ $SCANNER_HOME/bin/sonar-scanner -Dsonar.projectKey=recommendationservice -Dsonar.sources=./src/recommendationservice/.  """
                }
            }
        }
        // stage("quality gate"){
        //    steps {
        //         script {
        //             waitForQualityGate abortPipeline: false, credentialsId: 'sonar-token' 
        //         }
        //     } 
        // }
        

        // stage('Test') {
        //     steps {
        //         // Run tests if applicable
        //         sh 'mvn test'
        //     }
        // }

        // stage('Package') {
        //     steps {
        //         // Package your microservices (e.g., create JARs or Docker images)
        //         sh 'mvn package'
        //     }
        // }

        stage('Deploy') {
            steps {
                // Deploy your microservices (e.g., to a container orchestration platform)
                // Add deployment steps based on your deployment strategy
                echo "done deployment"
            }
        }   
    }

    post {
        success {
            // Perform actions when the build is successful
            echo 'Build successful!'
        }
        failure {
            // Perform actions when the build fails
            echo 'Build failed!'
        }
    }
}
