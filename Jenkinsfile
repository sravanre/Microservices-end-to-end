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
                docker push ghcr.io/sravanre/adservice:V${env.BUILD_NUMBER}
                """
            }
        }
        stage('Build and tag Push cartservice microservice') {
            steps {
                // Use Maven to build your microservices
                sh """
                cd src/cartservice/src
                docker build -t ghcr.io/sravanre/cartservice:V${env.BUILD_NUMBER} .
                docker push ghcr.io/sravanre/cartservice:V${env.BUILD_NUMBER}
                """
            }
        }

        stage('Build and tag Push checkoutservice microservice') {
            steps {
                // Use Maven to build your microservices
                sh """
                cd src/checkoutservice
                docker build -t ghcr.io/sravanre/checkoutservice:V${env.BUILD_NUMBER} .
                docker push ghcr.io/sravanre/checkoutservice:V${env.BUILD_NUMBER}
                """
            }
        }

        stage('Build and tag Push currencyservice microservice') {
            steps {
                // Use Maven to build your microservices
                sh """
                cd src/currencyservice
                docker build -t ghcr.io/sravanre/currencyservice:V${env.BUILD_NUMBER} .
                docker push ghcr.io/sravanre/currencyservice:V${env.BUILD_NUMBER}
                """
            }
        }

        stage('Build and tag Push emailservice microservice') {
            steps {
                // Use Maven to build your microservices
                sh """
                cd src/emailservice
                docker build -t ghcr.io/sravanre/emailservice:V${env.BUILD_NUMBER} .
                docker push ghcr.io/sravanre/emailservice:V${env.BUILD_NUMBER}
                """
            }
        }

        stage('Build and tag Push frontend microservice') {
            steps {
                // Use Maven to build your microservices
                sh """
                cd src/frontend
                docker build -t ghcr.io/sravanre/frontend:V${env.BUILD_NUMBER} .
                docker push ghcr.io/sravanre/frontend:V${env.BUILD_NUMBER}
                """
            }
        }

        stage('Build and tag Push loadgenerator microservice') {
            steps {
                // Use Maven to build your microservices
                sh """
                cd src/loadgenerator
                docker build -t ghcr.io/sravanre/loadgenerator:V${env.BUILD_NUMBER} .
                docker push ghcr.io/sravanre/loadgenerator:V${env.BUILD_NUMBER}
                """
            }
        }

        stage('Build and tag Push paymentservice microservice') {
            steps {
                // Use Maven to build your microservices
                sh """
                cd src/paymentservice
                docker build -t ghcr.io/sravanre/paymentservice:V${env.BUILD_NUMBER} .
                docker push ghcr.io/sravanre/paymentservice:V${env.BUILD_NUMBER}
                """
            }
        }

        stage('Build and tag Push productcatalogservice microservice') {
            steps {
                // Use Maven to build your microservices
                sh """
                cd src/productcatalogservice
                docker build -t ghcr.io/sravanre/productcatalogservice:V${env.BUILD_NUMBER} .
                docker push ghcr.io/sravanre/productcatalogservice:V${env.BUILD_NUMBER}
                """
            }
        }

        stage('Build and tag Push recommendationservice microservice') {
            steps {
                // Use Maven to build your microservices
                sh """
                cd src/recommendationservice
                docker build -t ghcr.io/sravanre/recommendationservice:V${env.BUILD_NUMBER} .
                docker push ghcr.io/sravanre/recommendationservice:V${env.BUILD_NUMBER}
                """
            }
        }

        stage('Build and tag Push shippingservice microservice') {
            steps {
                // Use Maven to build your microservices
                sh """
                cd src/shippingservice
                docker build -t ghcr.io/sravanre/shippingservice:V${env.BUILD_NUMBER} .
                docker push ghcr.io/sravanre/shippingservice:V${env.BUILD_NUMBER}
                """
            }
        }

        stage('Sonarqube Analysis for recommendationservice'){
            steps{
                withSonarQubeEnv('sonar-server') {
                sh """ $SCANNER_HOME/bin/sonar-scanner -Dsonar.projectKey=recommendationservice -Dsonar.sources=./src/recommendationservice/.  """

                }
            }
        }

        // FIXME:  change the path for the src , if it fails again
        stage("Sonarqube Analysis for cartservice "){
            steps{
                withSonarQubeEnv('sonar-server') {
                   sh """ $SCANNER_HOME/bin/sonar-scanner -Dsonar.projectKey=loadgenerator -Dsonar.sources=./src/loadgenerator/. """
                }
            }
        }

        stage("Sonarqube Analysis for currencyservice "){
            steps{
                withSonarQubeEnv('sonar-server') {
                    sh """ $SCANNER_HOME/bin/sonar-scanner -Dsonar.projectKey=cartscurrencyserviceervice -Dsonar.sources=./src/currencyservice/.  """
                }
            }
        }

        stage("Sonarqube Analysis for frontend "){
            steps{
                withSonarQubeEnv('sonar-server') {
                    sh """ $SCANNER_HOME/bin/sonar-scanner -Dsonar.projectKey=frontend -Dsonar.sources=./src/frontend/.  """
                }
            }
        }

        stage("Sonarqube Analysis for loadgenerator "){
            steps{
                withSonarQubeEnv('sonar-server') {
                    sh """ $SCANNER_HOME/bin/sonar-scanner -Dsonar.projectKey=loadgenerator -Dsonar.sources=./src/loadgenerator/.  """
                }
            }
        }

        stage("Sonarqube Analysis for paymentservice "){
            steps{
                withSonarQubeEnv('sonar-server') {
                    sh """ $SCANNER_HOME/bin/sonar-scanner -Dsonar.projectKey=paymentservice -Dsonar.sources=./src/paymentservice/.  """
                }
            }
        }

        stage("Sonarqube Analysis for productcatalogservice "){
            steps{
                withSonarQubeEnv('sonar-server') {
                    sh """ $SCANNER_HOME/bin/sonar-scanner -Dsonar.projectKey=productcatalogservice -Dsonar.sources=./src/productcatalogservice/.  """
                }
            }
        }

        stage("Sonarqube Analysis for shippingservice "){
            steps{
                withSonarQubeEnv('sonar-server') {
                    sh """ $SCANNER_HOME/bin/sonar-scanner -Dsonar.projectKey=shippingservice -Dsonar.sources=./src/shippingservice/.  """
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
