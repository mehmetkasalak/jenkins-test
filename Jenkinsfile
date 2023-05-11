// Linux Agent Label
def linuxAgentLabel = 'linux-burst'

// Set Parameters of Build Pipeline
def setProperties(){
    properties([
        parameters([
            string(name: 'TIMEOUT', defaultValue: '270', description: 'Build timeout in minutes'),
            choice(name: 'DEPLOYTO', choices: ['none', 'develop', 'qa', 'staging', 'production'], description: 'Which environment to deploy to after building'),
            booleanParam(name: 'CLEAN_WORKSPACE', defaultValue: true, description: 'Clean Workspace when build finishes? (Uncheck just for testing purposes)'),
            booleanParam(name: 'PUBLISH_BACKEND_APIS_DOCKER_IMAGES', defaultValue: defaultShouldPublishLicensingApi(), description: 'Publish Backend APIs docker images?'),
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
	env.CLOUD_PLATFORM_VERSION = commonModule.cloudPlatformVersion()
	env.GIT_COMMIT_HASH_PART = "h${commonModule.getCommitHashPart()}"
	env.SUFFIX_WITH_BRANCH = "${commonModule.getSuffix(commonModule.getRunAsBranch())}"
    env.VERSION_REVISION = "${env.GIT_COMMIT_HASH_PART}${env.SUFFIX_WITH_BRANCH}"
    env.FULL_VERSION = "${env.CLOUD_PLATFORM_VERSION}.${env.GIT_COMMIT_HASH_PART}${env.SUFFIX_WITH_BRANCH}"
    env.SESSION_ID = "${env.CLOUD_PLATFORM_VERSION}.${env.GIT_COMMIT_HASH_PART}${env.SUFFIX_WITH_BRANCH}--${env.BUILD_ID}"
}

node(linuxAgentLabel) {
	def commonModule = evaluate readTrusted("common.groovy")
    def hasWebChange = false
    def hasAppChange = false
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
    finally {
        commonModule.cleanupWorkspace()
    }
}