import Foundation

class FileFinderCurrent {
    
    func searchInDir () -> Bool {
        let fileManager = FileManager.default
        
        // Get path where the script is
        if fileManager.currentDirectoryPath.hasSuffix(".json") {
            return true
        }
        else{
            return false
        }
    }
}
