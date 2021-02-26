import Foundation

class FileFinder{
    
    let consoleIO = ConsoleIO()
    
    func searchInSubDir(subDir : String){
        let fileManager = FileManager.default
        
        // Get current directory path
        let path = fileManager.currentDirectoryPath + "/" + subDir
        if let enumerator:FileManager.DirectoryEnumerator = fileManager.enumerator(atPath: path) {
            while let element = enumerator.nextObject() as? String {
                if (element.hasSuffix(".keystore")) {
                    consoleIO.writeMessage(element)
                }
                if (element.hasSuffix(".txt")) {
                    consoleIO.writeMessage(element)
                }
            }
        }
    }
}
