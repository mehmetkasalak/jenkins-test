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
				}
                stage('In Parallel 5') {
					echo "shouldCleanWorkspace : ${env.SHOULD_CLEAN_WORKSPACE}"
				}
			}
        }
    ]
]

def sharedCommonModule(){
     def sharedModule = evaluate readTrusted("common.groovy")
     return sharedModule
}

def isCriticalBranch(){
    return sharedCommonModule().getRunAsBranch() ==~ 'master|develop|release/.*|hotfix/.*'
}

pipeline {
    agent any
    options {
		timeout(time: params.TIMEOUT as int, unit: 'MINUTES')
        buildBlocker (useBuildBlocker: true, blockLevel: 'GLOBAL', scanQueueFor: 'ALL', blockingJobs: 'hello-w*')
        parallelsAlwaysFailFast()
    }
    environment{
        SHOULD_CLEAN_WORKSPACE = sharedCommonModule().shouldCleanWorkspace()
    }
    stages {
        stage('App Parallel Stage') {
            steps{
				script{
                    sleep time: 15, unit: 'SECONDS'
                    env.SHARED_MODULE = sharedCommonModule()
					parallel (build.steps)
				}
			}
        }
    }
}