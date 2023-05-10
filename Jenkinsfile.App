def build = [
    steps: [
        'Build Pips': {
            stage('Parallel'){
				stage('In Parallel 1') {
					echo "In Parallel App 1 : ${params.TIMEOUT}" 
				}
				stage('In Parallel 2') {
					echo "SESSION_ID : ${env.SESSION_ID}"
				}
                stage('In Parallel 3') {
					echo "CLOUD_PLATFORM_VERSION : ${env.CLOUD_PLATFORM_VERSION}"
				}
                stage('In Parallel 4') {
					echo "GIT_COMMIT_HASH_PART : ${env.GIT_COMMIT_HASH_PART}"
				}
                stage('In Parallel 5') {
					echo "FULL_VERSION : ${env.FULL_VERSION}"
				}
                stage('In Parallel 5') {
					echo "isCriticalBranch : ${isCriticalBranch()}"
                    def sharedCommonModule = evaluate readTrusted("common.groovy")
                    echo "getRunAsBranch : ${sharedCommonModule.getRunAsBranch()}"
                    def res2 = sharedCommonModule.getRunAsBranch() ==~ 'master|develop|release/.*|hotfix/.*'
                    echo "res2 : ${res2}"
				}
			}
        }
    ]
]

def isCriticalBranch(){
    def sharedCommonModule = evaluate readTrusted("common.groovy")
    return sharedCommonModule.getRunAsBranch() ==~ 'master|develop|release/.*|hotfix/.*'
}

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