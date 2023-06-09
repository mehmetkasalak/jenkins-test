// Linux Agent Label
def linuxAgentLabel = 'linux-burst'

//  Version
def getVersion(){
    return '1.0.0'
}

// Set Parameters of Build Pipeline
def setProperties(){
    properties([
        parameters([
            string(name: 'TIMEOUT', defaultValue: '270', description: 'Build timeout in minutes'),
            choice(name: 'DEPLOYTO', choices: ['none', 'develop', 'qa', 'staging', 'production'], description: 'Which environment to deploy to after building'),
            booleanParam(name: 'CLEAN_WORKSPACE', defaultValue: true, description: 'Clean Workspace when build finishes? (Uncheck just for testing purposes)'),
		])
    ])
}

// returns true if the branch is master, develop, release or hotfix, false otherwise
def isCriticalBranch(){
    // Shared common module has to be injected in this method for default parameter values
    def sharedCommonModule = evaluate readTrusted("common.groovy")
    return sharedCommonModule.getRunAsBranch() ==~ 'master|develop|release/.*|hotfix/.*'
}

// default boolean value indicating whether or not cloud-platform.licensing.api docker image should be published
def defaultShouldPublishLicensingApi() {
    return isCriticalBranch()
}

// set Environment variables
def setEnvironments(commonModule){
	scmVars = checkout scm
	env.GIT_COMMIT = scmVars.GIT_COMMIT
	env.BRANCH_NAME = scmVars.GIT_BRANCH
	env.CLOUD_PLATFORM_VERSION = getVersion()
	env.GIT_COMMIT_HASH_PART = "h${commonModule.getCommitHashPart()}"
	env.SUFFIX_WITH_BRANCH = "${commonModule.getSuffix(commonModule.getRunAsBranch())}"
    env.VERSION_REVISION = "${env.GIT_COMMIT_HASH_PART}${env.SUFFIX_WITH_BRANCH}"
    env.FULL_VERSION = "${env.CLOUD_PLATFORM_VERSION}.${env.GIT_COMMIT_HASH_PART}${env.SUFFIX_WITH_BRANCH}"
    env.SESSION_ID = "${env.CLOUD_PLATFORM_VERSION}.${env.GIT_COMMIT_HASH_PART}${env.SUFFIX_WITH_BRANCH}--${env.BUILD_ID}"
}

node(linuxAgentLabel) {
	def commonModule = evaluate readTrusted("common.groovy")
    def hasFrontendChange = true
    def hasBackendChange = true
    def hasAppChange = false
    def hasOnlyAutomationChange = false
    try{
		setProperties()
		setEnvironments(commonModule)

        timeout(time: params.TIMEOUT as int, unit: 'MINUTES'){
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
                for(file in changedFiles){
                    hasBackendChange |= file.contains("src/dotnet") || file.contains("src/apis")
                    hasFrontendChange |= file.contains("src/web") || file.contains("src/apis") || file.startsWith("resources") 
                    //Check for application code changes for both backend and frontend
                    hasAppChange |= file.contains("src/dotnet") || file.contains("src/apis") || file.contains("src/web") || file.startsWith("resources") 
                    hasOnlyAutomationChange |= file.contains("Ranorex") || file.contains("Selenium") || file.contains("e2e")
                    // break if any change detected in backend/frontend/assets
                    if(hasAppChange){
                        echo file
                        break
                    }
                }
                if(hasAppChange){
                    hasOnlyAutomationChange = false
                }
            }
            stage('Run Steps'){
                if(!hasOnlyAutomationChange){
                   parallel([
                    'Run Frontend Jenkins' : {
                        if(hasFrontendChange){
                            echo "Has Web Change"
                            load "Jenkinsfile.Web"
                        }           
                    },
                    'Run Backend Jenkins' : {
                       if(hasBackendChange){
                            echo "Has App Change"
                            load "Jenkinsfile.App"
                        }            
                    }
                   ])
                }
                else{
                    echo 'Bypassed build & publish steps since there is no change or forced to'
                }
            } 
        }
    }
    finally {
        commonModule.cleanupWorkspace()
    }
}