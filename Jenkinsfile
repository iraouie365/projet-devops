pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'iraoui9/projet-devops:latest'
        AWS_SERVER = '51.21.180.168'
        AWS_USER = 'ec2-user'
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Récupération du code depuis GitHub...'
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                echo 'Construction de l image Docker...'
                sh 'docker build --no-cache -t $DOCKER_IMAGE .'
            }
        }

        stage('Login to Docker Hub') {
            steps {
                echo 'Connexion à Docker Hub...'
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'DOCKERHUB_USERNAME',
                    passwordVariable: 'DOCKERHUB_TOKEN'
                )]) {
                    sh 'echo $DOCKERHUB_TOKEN | docker login -u $DOCKERHUB_USERNAME --password-stdin'
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                echo 'Push de l image vers Docker Hub...'
                sh 'docker push $DOCKER_IMAGE'
            }
        }

        stage('Deploy to Kubernetes on AWS EC2') {
            steps {
                echo 'Déploiement Kubernetes sur AWS EC2...'

                sshagent(credentials: ['aws-ec2-ssh']) {
                    sh '''
                        ssh -o StrictHostKeyChecking=no $AWS_USER@$AWS_SERVER "
                            cd ~/projet-devops &&
                            git pull origin main &&
                            export KUBECONFIG=/home/ec2-user/.kube/config &&

                            kubectl apply -f k8s/mysql-secret.yaml &&

                            if kubectl get pvc mysql-pvc; then
                                echo 'PVC mysql-pvc existe déjà, on ne le modifie pas.'
                            else
                                kubectl apply -f k8s/mysql-pvc.yaml
                            fi &&

                            kubectl apply -f k8s/mysql-deployment.yaml &&
                            kubectl apply -f k8s/mysql-service.yaml &&
                            kubectl apply -f k8s/app-deployment.yaml &&
                            kubectl apply -f k8s/app-service.yaml &&

                            kubectl rollout restart deployment/projet-devops-app &&
                            kubectl rollout status deployment/projet-devops-app &&
                            kubectl get pods &&
                            kubectl get svc
                        "
                    '''
                }
            }
        }

        stage('Check Kubernetes Resources') {
            steps {
                echo 'Vérification des ressources Kubernetes...'

                sshagent(credentials: ['aws-ec2-ssh']) {
                    sh '''
                        ssh -o StrictHostKeyChecking=no $AWS_USER@$AWS_SERVER "
                            export KUBECONFIG=/home/ec2-user/.kube/config &&
                            kubectl get nodes &&
                            kubectl get pods &&
                            kubectl get svc
                        "
                    '''
                }
            }
        }
    }

    post {
        success {
            echo 'Pipeline terminé avec succès. Application déployée sur Kubernetes.'
        }

        failure {
            echo 'Pipeline échoué.'
        }
    }
}