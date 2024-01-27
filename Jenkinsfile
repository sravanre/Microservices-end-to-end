pipeline {
    agent any
    environment {
    CR_PAT = credentials('github-token')
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
                git branch: 'main', url: 'https://github.com/sravanre/microservices-demo.git'
            }
        }
        // stage('Prepare for the docker login'){
        //     steps{
        //         sh """
        //         sudo docker login ghcr.io -u sravanre -p ${CR_PAT}
        //         """
        //     }
        // }
        stage('Build and tag Adservice microservice') {
            steps {
                // Use Maven to build your microservices
                sh """
                cd src/adservice
                docker build -t ghcr.io/sravanre/adservice:v1 .
                """
            }
        }
        stage('Build and tag cartservice microservice') {
            steps {
                // Use Maven to build your microservices
                sh """
                cd src/cartservice/src
                docker build -t ghcr.io/sravanre/cartservice:v1 .
                """
            }
        }

        stage("Sonarqube Analysis "){
            steps{
                withSonarQubeEnv('sonar-server') {
                    sh ''' $SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=Netflix \
                    -Dsonar.projectKey=Netflix '''
                }
            }
        }
        stage("quality gate"){
           steps {
                script {
                    waitForQualityGate abortPipeline: false, credentialsId: 'sonar-token' 
                }
            } 
        }
        

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
