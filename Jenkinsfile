def setProperties(){
    properties([
        parameters([
             // Main pipeline parameters
            string(name: 'TIMEOUT', defaultValue: '270', description: 'Build timeout in minutes'),
            choice(name: 'DEPLOYTO', choices: ['none', 'develop&qa', 'develop', 'qa', 'staging', 'production'], description: 'Which environment to deploy to after building'),
            booleanParam(name: 'CLEAN_WORKSPACE', defaultValue: true, description: 'Clean Workspace when build finishes? (Uncheck just for testing purposes)')
		])
    ])
}

node {
	setProperties()
	def hasWebChange = false
	def hasAppChange = false
	timeout(time: params.TIMEOUT as int, unit: 'MINUTES'){
		withEnv(["DISABLE_AUTH=true",
				 "TIMEOUT=${params.TIMEOUT}"]) {
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
					hasAppChange |= file.contains("app/")
					hasWebChange |= file.contains("web/")
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
