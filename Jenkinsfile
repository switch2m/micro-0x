pipeline {
    agent any
    stages {
        stage('this is  test stage') {
            steps {
                echo 'test the first mvn package'
                sh '''
                    
                    terraform version
                    mvn -version
                    cd microservice-commandes
                    mvn clean package
                    kubectl version
                    
                '''
            }
        }
    }
}