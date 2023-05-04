pipeline {
    agent any
    stages {
	   stage('App Build') {
			steps{
				script{
					echo "I am building App"
				}
			}
		}
    }
}
