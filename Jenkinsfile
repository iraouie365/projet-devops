pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'iraoui9/projet-devops:latest'
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
                sh 'docker build -t $DOCKER_IMAGE .'
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

        stage('Deploy with Docker Compose') {
            steps {
                echo 'Déploiement local avec Docker Compose...'
                sh 'docker compose -p projet-devops down --remove-orphans'
                sh 'docker compose -p projet-devops up -d --build'
            }
        }

        stage('Check Containers') {
            steps {
                echo 'Vérification des conteneurs...'
                sh 'docker ps'
            }
        }
    }

    post {
        success {
            echo 'Pipeline terminé avec succès.'
        }

        failure {
            echo 'Pipeline échoué.'
        }
    }
}