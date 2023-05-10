// Linux Agent Label
def linuxAgentLabel = 'linux-burst'

// Set Parameters of Build Pipeline
def setProperties(){
    properties([
        parameters([
            string(name: 'TIMEOUT', defaultValue: '270', description: 'Build timeout in minutes'),
            choice(name: 'DEPLOYTO', choices: ['none', 'develop', 'qa', 'staging', 'production'], description: 'Which environment to deploy to after building'),
            booleanParam(name: 'CLEAN_WORKSPACE', defaultValue: true, description: 'Clean Workspace when build finishes? (Uncheck just for testing purposes)')
		])
    ])
}

// set Environment variables
def setEnvironments(commonModule){
	scmVars = checkout scm
	env.GIT_COMMIT = scmVars.GIT_COMMIT
	env.BRANCH_NAME = scmVars.GIT_BRANCH
	env.CLOUD_PLATFORM_VERSION = commonModule.cloudPlatformVersion()
	env.GIT_COMMIT_HASH_PART = "h${getCommitHashPart()}"
	env.SUFFIX_WITH_BRANCH = "${commonModule.getSuffix(commonModule.getRunAsBranch())}"
}


node(linuxAgentLabel) {
	def commonModule = evaluate readTrusted("common.groovy")
    try{
		def hasWebChange = false
        def hasAppChange = false
		setProperties()
		setEnvironments(commonModule)

        timeout(time: params.TIMEOUT as int, unit: 'MINUTES'){
            withEnv(["VERSION_REVISION=${env.GIT_COMMIT_HASH_PART}${env.SUFFIX_WITH_BRANCH}",
                     "FULL_VERSION=${env.CLOUD_PLATFORM_VERSION}.${env.GIT_COMMIT_HASH_PART}${env.SUFFIX_WITH_BRANCH}",
                     "SESSION_ID=${env.CLOUD_PLATFORM_VERSION}.${env.GIT_COMMIT_HASH_PART}${env.SUFFIX_WITH_BRANCH}--${env.BUILD_ID}"
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
        commonModule.cleanupWorkspace()
    }
}