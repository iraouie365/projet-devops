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
                echo 'Construction de l image Docker sans cache...'
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

        stage('Deploy to AWS EC2') {
            steps {
                echo 'Déploiement sur le serveur AWS EC2...'

                sshagent(credentials: ['aws-ec2-ssh']) {
                    sh '''
                        ssh -o StrictHostKeyChecking=no $AWS_USER@$AWS_SERVER "
                            cd ~/projet-devops &&
                            git pull origin main &&
                            sudo docker compose -f docker-compose.prod.yml down &&
                            sudo docker pull iraoui9/projet-devops:latest &&
                            sudo docker compose -f docker-compose.prod.yml up -d --force-recreate &&
                            sudo docker ps
                        "
                    '''
                }
            }
        }

        stage('Check App Files') {
            steps {
                echo 'Vérification des fichiers dans le conteneur app...'

                sshagent(credentials: ['aws-ec2-ssh']) {
                    sh '''
                        ssh -o StrictHostKeyChecking=no $AWS_USER@$AWS_SERVER "
                            sudo docker exec projet-devops-app ls -la /var/www/html
                        "
                    '''
                }
            }
        }
    }

    post {
        success {
            echo 'Pipeline terminé avec succès. Application déployée sur AWS.'
        }

        failure {
            echo 'Pipeline échoué.'
        }
    }
}