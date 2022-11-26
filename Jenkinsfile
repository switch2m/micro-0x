pipeline {
    agent any
    // for the installation of brew in jenkins docker conatainer us have first to install it the root user in the docekr container using the following commanf
    // /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    // after that changing the owner ship of the binary file of home brew to the jenkins user using this s
    // chown -R jenkins:jenkins /home/linuxbrew/.linuxbrew/bin
    // after that going to the jenkins user and adding the homebrew binary path to the PATH jenkins env variables using the following s
    // export PATH=$PATH:/home/linuxbrew/.linuxbrew/bin
    // or if we want to install helm directly without using brew
    // we could install it directly using the following commands
    // $ curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
    // $ chmod 700 get_helm.sh
    // $ ./get_helm.sh
    stages {
        stage('Test environnement stage') {
            steps {
                echo 'test the first mvn package'
                sh '''
                    terraform version
                    mvn -version
                    kubectl version --client
                    az --version
                    brew --version
                    brew install helm
                '''
            }
        }
        // stage('Test with trufflehog') {
        //     steps {
        //         echo 'testing for exposed token, secret, keys, hardcoded password'
        //         sh 'rm trufflehog || true'
        //         sh 'docker run dxa4481/trufflehog  https://github.com/switch2m/micro-0x.git || true'
        //     }
        // }
        
        // stage('SAST Stage') {
        // we run the sonarqube in a docker container using this s
        // docker run -d -p 9000:9000 sonarqube
        // then we install sonar scanner plugin in jenkins
        // after that we configure(in configure system) sonarqube server by
        // specifying the server url and a name and a user token(which we generate in the sonarqube server under the account/security setting section) this user token should added as a credentials with a type of secret text
        // and finaly goto global tool configuration and configure sonarqube scanner by just adding the name of the sonarqube server and marking the box enabling adding sonar to env variables
        //     steps {
        //         echo 'SAST test using Sonarqube'
        //         withSonarQubeEnv('sonar') {
        //             sh '''
        //                 cd clientui
        //                 mvn sonar:sonar
        //                 cat target/sonar/report-task.txt
        //             '''
        //             sh '''
        //                 cd microservice-paiement
        //                 mvn sonar:sonar
        //                 cat target/sonar/report-task.txt
        //             '''
        //             sh '''
        //                 cd microservice-commandes
        //                 mvn sonar:sonar
        //                 cat target/sonar/report-task.txt
        //             '''
        //             sh '''
        //                 cd microservice-produits
        //                 mvn sonar:sonar
        //                 cat target/sonar/report-task.txt
        //             '''
        //         }
        //     }
        // }
        // stage('exexuting SCA test') {
        //     checking third party library used in the code that whether
        //     have vulnerability and check for deprecated dependencies
        //     use this http://jenkins-ip:8080/pipeline-syntax/ to generate pipeline script of plugins
        //     steps {
        //         dependencyCheck additionalArguments: 
        //         '''
        //             scan="/var/jenkins_home/workspace/mine/clientui" 
        //             --format HTML
        //             --format XML  
        //         ''', odcInstallation: 'sca'

        //         dependencyCheckPublisher pattern: 'dependency-check-report.xml'
        //      }
        // }
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
        stage('Create AKS kubenetes cluster') {
            steps {
                echo 'creating AKS'
                sh 'terraform init'
                sh 'terraform apply --auto-approve'
                echo 'connecting to the cluster'
                sh 'az account set --subscription 7fd37297-df8e-43f0-8679-865285ff7951'
                sh 'az aks get-credentials --resource-group rg-aks --name stage-aks-cluster'
            }
        }
        stage('deployment with kubernetes') {
            steps {
                echo 'testing kubernetes cluster connection'
                sh 'kubectl get node'
                echo 'setting up  promotheus commands'
                sh '''
                    helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
                    kubectl create namespace prometheus
                    helm install stable prometheus-community/kube-prometheus-stack -n prometheus
                '''
                //sh 'kubectl edit svc stable-kube-prometheus-sta-prometheus -n prometheus'//edit the type of the service to loadbalancer
                // or u can use this s directly kubectl patch svc stable-kube-prometheus-sta-prometheus -n prometheus -p '{"spec": {"type": "LoadBalancer"}}'
                //sh 'kubectl edit svc stable-grafana -n prometheus' //edit the type of the service to loadbalancer
                echo 'running kubectl commands'
                sh 'kubectl delete all --all'
                sh 'kubectl apply -f deployement.yaml'
            }
        }
        // stage('DAST test on application') {
        //     steps {
        //         echo 'testing application using owasp zap'
        //         sshagent(['owasp']) {
        //             sh 'ssh —o StrictHostKeyChecking=no "docker run -t owasp/zap2docker-stable \ zap-baseline.py -t http://20.187.161.229/"'
        //         }
        //     }
        // }
    }
}