import Foundation
import SwiftShell
import Darwin
import AppKit

public class FileHandler{
    
      
    func getScriptDirectory() -> URL {
        let programPath = Bundle.main.bundlePath
        let currentDirectoryURL = URL(fileURLWithPath: programPath)
        return currentDirectoryURL
    }
    
    func dataFromSingingScript () -> String?{
        let pathUrl = Bundle.main.path(forResource: "scripts/apkSignerDtagXcode", ofType: ".sh")
        //let path = URL(fileReferenceLiteralResourceName: "apkSignerDtagXcode.sh")
        //let path = URL(fileURLWithPath: "/Users/axelschwarz/development/swiftApkSigner/swiftApkSigner/apkSignerDtagXcode.sh")
        //let pathUrl = "\(path!.path)"
        return pathUrl
    }

    func createJsonString (PackageName: String) -> String? {
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

        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted

        do {
            let initJsonData = try encoder.encode(make)

            if let initJsonString = String(data: initJsonData, encoding: .utf8) {
                return initJsonString
            }
        } catch {
        }
        return nil
    }

    func writingStartJson (PackageName: String) {
        
        guard let initJsonString = createJsonString(PackageName: PackageName) else {
            print ("Evil error")
            return
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

public struct Config : Codable {

        var PackageName: String
        var AppName: String?
        var AppPath: String?
        var KeyStore: String?
        var KeyPass: String?
        var SigningScheme: Int
    
    }

    func handleJsonData(jsonPath: String) -> Config? {
        
        if let jsonData = try! String(contentsOfFile: jsonPath).data(using: .utf8)
        {
            let decoder = JSONDecoder()
             do {
                let config = try decoder.decode(Config.self, from: jsonData)
                return config
             } catch {
                 print(error.localizedDescription)
             }
        }
        return nil
    }

    func loadJson(fileName: String) -> String{
        
        let urlJsonDir = getScriptDirectory()
        let urlJson = URL(fileURLWithPath: "\(urlJsonDir.path)/\(packageName)_Config.json")
        let jsonString = "\(urlJson.path)"
        return jsonString
    }
    
    func loadJsonInConfigs(fileName: String) -> String{
        
        let urlJsonDir = getScriptDirectory()
        let urlJson = URL(fileURLWithPath: "\(urlJsonDir.path)/configs/\(packageName)_Config.json")
        let jsonString = "\(urlJson.path)"
        return jsonString
    }

    func checkJson() -> String! {
        let check = searchInDir()
        let checkConfigsDir = searchInConfigsDir()
        
        if ((check || checkConfigsDir) == false){
            FileHandler().writingStartJson(PackageName: packageName)
            print("Empty Json generated please insert missung data and start again")
            exit(0)
        }
        else if (check == true){
            let jsonPath = FileHandler().loadJson(fileName: packageName)
            return jsonPath
        }
        else {
            let jsonPath = FileHandler().loadJsonInConfigs(fileName: packageName)
            return jsonPath
        }
    }
    
    func searchInDir () -> Bool {
        
        let urlJson = getScriptDirectory()
        let stringJson = "\(urlJson.path)/\(packageName)_Config.json"
        
        if FileManager.default.isReadableFile(atPath: stringJson) {
                    return true
                }
        else {
                    return false
            }
    }
    
    func searchInConfigsDir () -> Bool {
        
        let urlJson = getScriptDirectory()
        let stringJson = "\(urlJson.path)/configs/\(packageName)_Config.json"
        
        if FileManager.default.isReadableFile(atPath: stringJson) {
                    return true
                }
        else {
                    return false
            }
    }
    
    func reNameApkFile(apkName: String) {
        guard let apkPath = Bundle.main.path(forResource: nil, ofType: "apk")
        else {
            fatalError("apk not found")
        }
        let fileManager = FileManager.default

        do {
            try fileManager.moveItem(atPath: apkPath, toPath: apkName)
        }
        catch let error as NSError {
            print("Ooops! Something went wrong with renaming the apk file for the script: \(error)")
        }
    }
    
    func createAssetsDir() {
        let path = FileHandler().getScriptDirectory()
        let paths = ["\(path.path)"]
        let assetDirectory = paths[0]
        let docURL = URL(string: assetDirectory)!
        let dataPath = docURL.appendingPathComponent("assets")
        if !FileManager.default.fileExists(atPath: dataPath.absoluteString) {
            do {
                try FileManager.default.createDirectory(atPath: dataPath.absoluteString, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func createConfigDir() {
        let path = FileHandler().getScriptDirectory()
        let paths = ["\(path.path)"]
        let assetDirectory = paths[0]
        let docURL = URL(string: assetDirectory)!
        let dataPath = docURL.appendingPathComponent("configs")
        if !FileManager.default.fileExists(atPath: dataPath.absoluteString) {
            do {
                try FileManager.default.createDirectory(atPath: dataPath.absoluteString, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
