pipeline {
    agent any
    stages {
	   stage('Test Stage') {
			steps{
				script{
					// def changedFiles = []
					// def changeLogSets = currentBuild.changeSets
					// for (entries in changeLogSets) {
					// 	for (entry in entries) {
					// 		for (file in entry.affectedFiles) {
					// 			echo "Found changed file: ${file.path}"
					// 			echo "Found changed file: ${file.src}"
					// 			changedFiles.add("${file.path}")
					// 		}
					// 	}
					// }
					def changeLogSets = currentBuild.changeSets
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
}