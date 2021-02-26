import Foundation

class FileFinderCurrent {
    
    let consoleIO = ConsoleIO()
    
    func searchInDir (){
        let fileManager = FileManager.default
        
        let currentDirectory = fileManager.currentDirectoryPath
        if let enumerator:FileManager.DirectoryEnumerator = fileManager.enumerator(atPath: currentDirectory) {
            while let currentDirectoryElement = enumerator.nextObject() as? String {
                if (currentDirectoryElement.hasSuffix(".apk")) {
                    consoleIO.writeMessage(currentDirectoryElement)
                }
            }
        }
    }
}
