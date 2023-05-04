pipeline {
	agent any
	stages {
		stage('Even Stage') {
			steps {
				boolean hasWebChange = false
				boolean hasAppChange = false
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

				if(hasAppChange){
					load "Jenkinsfile.App"
				}

				if(hasWebChange){
					load "Jenkinsfile.Web"
				}
			}
		}
	}
}
	
// node {
// 	String jenkinsFile
//    	stage("Determine build file") {
// 		boolean hasWebChange = false
// 		boolean hasAppChange = false
// 		def changedFiles = []
// 		def changeLogSets = currentBuild.changeSets
// 		for (entries in changeLogSets) {
// 			for (entry in entries) {
// 				for (file in entry.affectedFiles) {
// 					echo "${file.path}"
// 					changedFiles.add("${file.path}")
// 				}
// 			}
// 		}
// 		changedFiles.each{file->
// 			hasAppChange |= file.contains("app/")
// 			hasWebChange |= file.contains("web/")
// 		}

// 		if(hasAppChange){
// 			load "Jenkinsfile.App"
// 		}

//       	if(hasWebChange){
// 			load "Jenkinsfile.Web"
// 		}
//    	}
// }