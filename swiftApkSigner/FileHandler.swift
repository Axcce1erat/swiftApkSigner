
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
    
    func writingStartJson (PackageName: String) {
        
        struct Make: Codable {
            var PackageName: String?
            var AppName: String?
            var AppPath: String?
            var KeyStore: String?
            var KeyPass: String?
            var SingingScheme: Int?
        }

        var make = Make()
        make.PackageName = PackageName
        make.AppName = ""
        make.AppPath = ""
        make.KeyStore = ""
        make.KeyPass = ""
        make.SingingScheme = 0

        let initJsonData = try! JSONEncoder().encode(make)
        let initJsonString = String(data: initJsonData, encoding: .utf8)!
        //print(initJsonString)

        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted

        do {
            let initJsonData = try encoder.encode(make)

            if let initJsonString = String(data: initJsonData, encoding: .utf8) {
                print(initJsonString)
            }
        } catch {
            print(error.localizedDescription)
        }

        if let jsonDataFile = initJsonString.data(using: .utf8){
                let pathWithFileName = FileHandler().getScriptDirectory().appendingPathComponent("\(packageName)_Config.json")
            do {
                try jsonDataFile.write(to: pathWithFileName)
            } catch {
                print ("failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding")
            }
        }
    }
}
