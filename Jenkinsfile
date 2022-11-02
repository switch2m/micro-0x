pipeline {
    agent any
    stages {
        stage('Test environnement stage') {
            steps {
                echo 'test the first mvn package'
                sh '''
                    terraform version
                    mvn -version
                    kubectl version --client
                '''
            }
        }
        stage('build jar files for all microservices') {
            steps {
                echo 'mvn package for microservice-produits'
                sh '''
                    cd microservice-produits
                    mvn clean package
                '''
                echo 'mvn package for microservice-paiement'
                sh '''
                    cd microservice-paiement
                    mvn clean package
                '''
                echo 'mvn package for microservice-commandes'
                sh '''
                    cd microservice-commandes
                    mvn clean package
                '''
                echo 'mvn package for clientui'
                sh '''
                    cd clientui
                    mvn clean package
                '''
            }
        }
    }
}