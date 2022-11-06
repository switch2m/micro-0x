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
                    az --version
                '''
            }
        }
        stage('exexuting SCA test') {
            //checking third party library used in the code that whether
            //have vulnerability and check for deprecated dependencies
            steps {
                echo 'Software Composition Analysis test'
                sh '''
                    cd microservice-produits
                    rm owsap* || true
                    wget "https://raw.githubusercontent.com/switch2m/micro-0x/master/owsap-sca.sh"
                    chmod +x owsap-sca.sh
                    bash owsap-sca.sh
                '''
            }
        }
        // stage('build jar files for all microservices') {
        //     steps {
        //         echo 'mvn package for microservice-produits'
        //         sh '''
        //             cd microservice-produits
        //             mvn clean package
        //         '''
        //         echo 'mvn package for microservice-paiement'
        //         sh '''
        //             cd microservice-paiement
        //             mvn clean package
        //         '''
        //         echo 'mvn package for microservice-commandes'
        //         sh '''
        //             cd microservice-commandes
        //             mvn clean package
        //         '''
        //         echo 'mvn package for clientui'
        //         sh '''
        //             cd clientui
        //             mvn clean package
        //         '''
        //     }
        // }
        
        // stage('buid and push docker images') {
        //     steps {
        //         echo 'build and push docker images'
        //         withCredentials([usernamePassword(credentialsId: 'docker-credentials', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
        //             sh '''
        //                 cd microservice-produits
        //                 docker build -t switch2mdock/micro-app:produits .
        //                 docker push switch2mdock/micro-app:produits
        //             '''
        //             sh '''
        //                 cd microservice-paiement
        //                 docker build -t switch2mdock/micro-app:paiement .
        //                 docker push switch2mdock/micro-app:paiement
        //             '''
        //             sh '''
        //                 cd microservice-commandes
        //                 docker build -t switch2mdock/micro-app:commandes .
        //                 docker push switch2mdock/micro-app:commandes
        //             '''
        //             sh '''
        //                 cd clientui
        //                 docker build -t switch2mdock/micro-app:cilent .
        //                 docker push switch2mdock/micro-app:cilent
        //             '''
        //         }
        //     }
        // }
        // stage('Create AKS kubenetes cluster') {
        //     steps {
        //         echo 'creating AKS'
        //         sh 'terraform init'
        //         sh 'terraform apply --auto-approve'
        //         echo 'connecting to the cluster'
        //         sh 'az account set --subscription 7fd37297-df8e-43f0-8679-865285ff7951'
        //         sh 'az aks get-credentials --resource-group rg-aks --name stage-aks-cluster'
        //     }
        // }
        // stage('deployment with kubernetes') {
        //     steps {
        //         echo 'testing kubernetes cluster connection'
        //         sh 'kubectl get node'
        //         echo 'running kubectl commands'
        //         sh 'kubectl delete all --all'
        //         sh 'kubectl apply -f deployement.yaml'
        //     }
        // }
    }
}