pipeline {
    agent any

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
                bat 'docker build -t projet-devops-app .'
            }
        }

        stage('Run Docker Compose') {
            steps {
                echo 'Déploiement local avec Docker Compose...'
                bat 'docker compose down'
                bat 'docker compose up -d --build'
            }
        }

        stage('Test Containers') {
            steps {
                echo 'Vérification des conteneurs...'
                bat 'docker ps'
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