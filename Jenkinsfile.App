def build = [
    steps: [
        'Build Pips': {
            stage('Parallel'){
				stage('In Parallel 1') {
					echo "In Parallel App 1 : ${env.DISABLE_AUTH}" 
				}
				stage('In Parallel 2') {
					echo "In Parallel App 2 : ${env.DISABLE_AUTH}"
				}
			}
        }
    ]
]

pipeline {
    agent any
    options {
        parallelsAlwaysFailFast()
    }
    stages {
        stage('App Parallel Stage') {
            steps{
				script{
					parallel (build.steps)
				}
			}
        }
    }
}