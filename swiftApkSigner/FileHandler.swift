
import Foundation
import SwiftShell

class FileHandler{
    
    func getScriptDirectory() -> URL {
        //let paths = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask)
        let paths = URL(fileURLWithPath: "/Users/axelschwarz/Library/Developer/Xcode/DerivedData/swiftApkSigner-gqryovkkaznkrogfwnjulbdgxrqq/Build/Products/Debug")
        return paths
    }
    /*
    func getCurrentDirectory (){
        let fileManager = FileManager.default
        
        // Get path where the script is
        let currentDirectory = fileManager.currentDirectoryPath
    }
    */
    func dataFromSingingScript () -> String{
        let urlScript = URL(fileURLWithPath: "/Users/axelschwarz/development/swiftApkSigner/swiftApkSigner/assets/apkSignerDtagXcode.sh")
        let stringScript = "\(urlScript.path)"
        return stringScript
    }
}
