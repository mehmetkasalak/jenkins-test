node {
	def jenkinsFile
	def hasWebChange = false
	def hasAppChange = false
   	stage("Determine build file") {
		// stage("Determine build file") {
		// 	jenkinsFile = "Jenkinsfile.CI"
		// }
		// load jenkinsFile
		
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
		jenkinsFile = "Jenkinsfile.App"
	}
	if(jenkinsFile != null)
		load jenkinsFile
		
	if(hasWebChange){
		echo "Has Web Change"
		jenkinsFile = "Jenkinsfile.Web"
	}

	if(jenkinsFile != null)
		load jenkinsFile
}