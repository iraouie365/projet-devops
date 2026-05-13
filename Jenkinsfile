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
                sh 'docker build -t projet-devops-app .'
            }
        }

        stage('Deploy with Docker Compose') {
            steps {
                echo 'Déploiement avec Docker Compose...'
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