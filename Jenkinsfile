//
// Utils
//

def cloudPlatformVersion(){
    return '23.2.2.0'
}

def getCommitHashPart(){
	def scmVars = checkout scm
	return scmVars.GIT_COMMIT.substring(0,6)
}

//
// Reusable Steps
//

// Only when true we should run clean the Jenkins workspace in the agents
def shouldCleanWorkspace(){
    return params.CLEAN_WORKSPACE
}

// cleans up the workspace
def cleanupWorkspace(){
    if(shouldCleanWorkspace()){
		echo "cleanWs()"
        cleanWs()
    }
}

//
// Branch methods
//

// Run as branch as defined in the Jenkins buidl parameter
def getRunAsBranch(){
	def scmVars = checkout scm
    def runAsBranch=scmVars.GIT_BRANCH
    if(params.RUN_AS_BRANCH != null && params.RUN_AS_BRANCH.trim().length() != 0){
        runAsBranch=params.RUN_AS_BRANCH
    }
    return runAsBranch
}

// Get the branch suffix,
// ex: develop -> '-dev'
// release -> '-rc'
// hotfix -> '-hotfix'
// PR -> '-pr'
// feature/CP-123 -> '-cp-123'
// master -> '' 
def getSuffix(branchName) {
    def suffix = ''
    switch(branchName.split('/')[0]) {
        case 'master':
            break
        case 'develop':
            suffix = '-dev'
            break
        case 'release':
            suffix = '-rc'
            break
        case 'hotfix':
            suffix = '-hotfix'
            break
        default:
            if (branchName.startsWith('PR-')) {
                suffix = "-${branchName.toLowerCase()}"
            } else {
                suffix = branchName.contains('/') ? "-${branchName.split('/')[1]}" : "-${branchName}"
            }
    }
    return suffix.toLowerCase()
}

def setProperties(){
    properties([
        parameters([
             // Main pipeline parameters
            string(name: 'TIMEOUT', defaultValue: '270', description: 'Build timeout in minutes'),
            choice(name: 'DEPLOYTO', choices: ['none', 'develop', 'qa', 'staging', 'production'], description: 'Which environment to deploy to after building'),
            booleanParam(name: 'CLEAN_WORKSPACE', defaultValue: true, description: 'Clean Workspace when build finishes? (Uncheck just for testing purposes)')
		])
    ])
}

node {
    try{
        setProperties()
        def hasWebChange = false
        def hasAppChange = false
        timeout(time: params.TIMEOUT as int, unit: 'MINUTES'){
            withEnv(["CLOUD_PLATFORM_VERSION=${cloudPlatformVersion()}",
                     "GIT_COMMIT_HASH_PART=h${getCommitHashPart()}",
                    "VERSION_REVISION=${getCommitHashPart()}${getSuffix(getRunAsBranch())}",
                    "FULL_VERSION=${cloudPlatformVersion()}.${getCommitHashPart()}${getSuffix(getRunAsBranch())}",
                    "SESSION_ID=${env.FULL_VERSION}--${env.BUILD_ID}"
                    ]) {
                stage("Determine build file") {
                    def changedFiles = []
                    def changeLogSets = currentBuild.changeSets
                    for (entries in changeLogSets) {
                        for (entry in entries) {
                            for (file in entry.affectedFiles) {
                                changedFiles.add("${file.path}")
                            }
                        }
                    }
                    changedFiles.each{file->
                        hasAppChange |= file.contains("src/dotnet") || file.contains("src/apis")
                        hasWebChange |= file.contains("src/web")
                    }
                }
                if(hasAppChange){
                    echo "Has App Change"
                    load "Jenkinsfile.App"
                }

                if(hasWebChange){
                    echo "Has Web Change"
                    load "Jenkinsfile.Web"
                }
            }
        }
    }
    finally {
        cleanupWorkspace()
    }
}