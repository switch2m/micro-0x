pipeline {
    agent any
    stages {
        stage('this is  test stage') {
            steps {
                echo 'test the first mvn package'
                sh '''
                    cd microservice-commandes
                    mvn clean package
                    terraform version
                '''
            }
        }
    }
}