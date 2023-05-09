def build = [
    steps: [
        'Build Pips': {
            stage('Parallel'){
				stage('In Parallel 1') {
					echo "In Parallel App 1"
				}
				stage('In Parallel 2') {
					echo "In Parallel App 2"
				}
			}
        }
    ]
]

pipeline {
    agent any
    options {
        timeout(time: params.TIMEOUT as int, unit: 'MINUTES')
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