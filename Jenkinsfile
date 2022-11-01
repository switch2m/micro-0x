pipeline {
    agent any
    stages {
        stage('this is  test stage') {
            steps {
                echo 'test the first mvn package'
                sh '''
                    cd microservice-commandes
                    /opt/apache-maven-3.6.3/bin clean package
                    terraform version
                '''
            }
        }
    }
}