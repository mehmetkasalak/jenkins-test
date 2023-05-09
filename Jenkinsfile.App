def build = [
    steps: [
        'Build Pips': {
            stage('Parallel'){
				stage('In Parallel 1') {
					echo "In Parallel App 1 ${env.TIMEOUT}" 
				}
				stage('In Parallel 2') {
					echo "In Parallel App 2 ${env.TIMEOUT}"
				}
			}
        }
    ]
]

pipeline {
    agent any
    options {
        timeout(time: env.TIMEOUT as int, unit: 'MINUTES')
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