def build = [
    steps: [
        'Build Pips': {
            stage('Parallel'){
				stage('In Parallel 1') {
					echo "In Parallel 1"
				}
				stage('In Parallel 2') {
					echo "In Parallel 2"
				}
			}
        }
    ]
]

pipeline {
    agent any
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