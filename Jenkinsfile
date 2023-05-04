pipeline {
	agent any
	stages {
	   stage('Decision Stage') {
			steps{
				script{
					def changeLogSets = currentBuild.changeSets
					echo changeLogSets
					for (int i = 0; i < changeLogSets.size(); i++) {
						def entries = changeLogSets[i].items
						for (int j = 0; j < entries.length; j++) {
							def files = new ArrayList(entry.affectedFiles)
							for (int k = 0; k < files.size(); k++) {
								def file = files[k]
								echo " ${file.editType.name} ${file.path}"
							}
						}
					}
				}
			}
		}
    }

	// stages {
	// 	stage('Decision Stage') {
	// 		steps {
	// 			script {
	// 				boolean hasWebChange = false
	// 				boolean hasAppChange = false
	// 				def changedFiles = []
	// 				def changeLogSets = currentBuild.changeSets
	// 				for (entries in changeLogSets) {
	// 					for (entry in entries) {
	// 						for (file in entry.affectedFiles) {
	// 							changedFiles.add("${file.path}")
	// 						}
	// 					}
	// 				}
	// 				changedFiles.each{file->
	// 					hasAppChange |= file.contains("app/")
	// 					hasWebChange |= file.contains("web/")
	// 				}

	// 				if(hasAppChange){
	// 					load "Jenkinsfile.App"
	// 				}

	// 				if(hasWebChange){
	// 					load "Jenkinsfile.Web"
	// 				}
	// 			}
	// 		}
	// 	}
	// }
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