
import Foundation
import SwiftShell
import Darwin

class FileHandler{
    
      
    func getScriptDirectory() -> URL {
        let paths = URL(fileURLWithPath: "/Users/axelschwarz/Library/Developer/Xcode/DerivedData/swiftApkSigner-gqryovkkaznkrogfwnjulbdgxrqq/Build/Products/Debug")
        return paths
    }

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
            var SigningScheme: Int?
        }

        var make = Make()
        make.PackageName = PackageName
        make.AppName = ""
        make.AppPath = ""
        make.KeyStore = ""
        make.KeyPass = ""
        make.SigningScheme = 0

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
    
struct Config : Codable{
        var PackageName: String
        var AppName: String
        var AppPath: String
        var KeyStore: String
        var KeyPass: String
        var SigningScheme: Int
    }

    func handleJsonData(jsonPath: String) -> Config? {
        
        let jsonDataRaw = try! String(contentsOfFile: jsonPath)
        print("jsonDataRaw: ", jsonDataRaw)
        
        if let jsonData = try! String(contentsOfFile: jsonPath).data(using: .utf8)
        {
            print("jsonData: ", jsonData)
            let decoder = JSONDecoder()
            print("decoder: ", decoder)

             do {
                let config = try decoder.decode(Config.self, from: jsonData)
                print(config.AppPath)
                return config
             } catch {
                 print(error.localizedDescription)
             }
        }
        return nil
    }

    func loadJson(fileName: String) -> String{
        
        let urlJson = URL(fileURLWithPath: "/Users/axelschwarz/Library/Developer/Xcode/DerivedData/swiftApkSigner-gqryovkkaznkrogfwnjulbdgxrqq/Build/Products/Debug/\(packageName)_Config.json")
        let jsonString = "\(urlJson.path)"
        return jsonString
    }

    func checkJson() -> String! {
        let check = searchInDir()
        print("var check: ", check)
        
        if (check == false){
            FileHandler().writingStartJson(PackageName: packageName)
            print("Empty Json generated please insert missung data and start again")
            exit(0)
        }
        else if (check == true){
            let jsonPath = FileHandler().loadJson(fileName: packageName)
            print("jsonPath=", jsonPath)
            return jsonPath
        }
        return nil
    }
    
    func searchInDir () -> Bool {
        
        let urlJson = getScriptDirectory()
        let stringJson = "\(urlJson.path)/\(packageName)_Config.json"
        print("stringJson: ", stringJson)
        
        if FileManager.default.isReadableFile(atPath: stringJson) {
                    return true
                }
        else {
                    return false
            }
    }
}
