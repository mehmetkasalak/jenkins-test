//
// Reusable Steps
//

def echoTest(){
    echo "Test shared method"
}

// get commit hash part
def getCommitHashPart(){
	echo "${env.GIT_COMMIT}"
	return env.GIT_COMMIT.substring(0,6)
}

// Only when true we should run clean the Jenkins workspace in the agents
def shouldCleanWorkspace(){
    return params.CLEAN_WORKSPACE
}

// cleans up the workspace
def cleanupWorkspace(){
    if(shouldCleanWorkspace()){
        cleanWs()
        echo "cleanupDockerImages()"
    }
}

//
// Branch methods
//

// Run as branch as defined in the Jenkins buidl parameter
def getRunAsBranch(){
    def runAsBranch=env.BRANCH_NAME
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

return this