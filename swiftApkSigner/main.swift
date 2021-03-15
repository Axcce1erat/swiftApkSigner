//  Created by Axel Schwarz
import Foundation
import AppKit
import SwiftShell
/*
let fileFinderCurrent = FileFinderCurrent()
let fileFinder = FileFinder()

// console output
if CommandLine.argc < 1 {
    let consoleIO = ConsoleIO()
    consoleIO.printUsage()
} else {
   //let fileFinder = FileFinder()
   //let apkName = CommandLine.arguments[1]
   //let argument = "keystore"
   //fileFinder.searchInSubDir(subDir: argument)
   let fileFinderCurrent = FileFinderCurrent()
   fileFinderCurrent.searchInDir()
}
*/
let appt = Preparation().dataFromAndroidManifest()

let (packageName, versionCode, versionName, debug) = Preparation().filterWithRegex(appt: appt)

let debugOption = Preparation().debugRelease(debugOption: debug)

//concatenate strings for apk name
let apkName = "\(packageName)_\(versionName)_\(versionCode)_\(debugOption).apk"

// rename apk file inScript
let apk = "de.telekom.appstarter_12.0.0-001_120000000_debug.apk"
let fileManager = FileManager.default

do {
    try fileManager.moveItem(atPath: apk, toPath: apkName)
}
catch let error as NSError {
    print("Ooops! Something went wrong with renaming the apk file for the script: \(error)")
}

// writing to text file androidManifest filtered output
let packageNameConfig = FileHandler().getScriptDirectory().appendingPathComponent("PackageNameConfig.txt")

do {
    try appt.write(to: packageNameConfig, atomically: true, encoding: String.Encoding.utf8)
} catch {
    print ("failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding")
}

let stringScript = FileHandler().dataFromSingingScript()

let keystore = "test.keystore"
let pass = "pass.txt"
let valueSigningScheme = "2"

let apkSignerDtagXcode = run(stringScript, keystore,  pass, valueSigningScheme, apkName).stdout
print(apkSignerDtagXcode)

let apkParameter = FileHandler().getScriptDirectory().appendingPathComponent("apk_parameter.txt")

do {
    try apkSignerDtagXcode.write(to: apkParameter, atomically: true, encoding: String.Encoding.utf8)
} catch {
    print ("failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding")
}

//let jsonFile = FileHandler().getScriptDirectory().appendingPathComponent("")

func checkJson() -> String! {
    let check = FileFinderCurrent().searchInDir()
    print("var check: ", check)
    
    if (check == true){
        //json hanling writing start json
        FileHandler().writingStartJson(PackageName: packageName)
        
        return nil
    }
    else if (check == false){
        let jsonPath = loadJson(fileName: packageName)
        print("jsonPath=",jsonPath)
        return jsonPath
    }
    return nil
}

let checkJsonResult: String! = checkJson()
print("checkJsonResult: ", checkJsonResult!)
if let newJsonData = handleJsonData(jsonPath: checkJsonResult){
    print("newJsonData: ", newJsonData.PackageName)
    print("SigningScheme: ", newJsonData.SigningScheme)
}


func loadJson(fileName: String) -> String{
    
    let urlJson = URL(fileURLWithPath: "/Users/axelschwarz/Library/Developer/Xcode/DerivedData/swiftApkSigner-gqryovkkaznkrogfwnjulbdgxrqq/Build/Products/Debug/\(packageName)_Config.json")
    let jsonString = "\(urlJson.path)"
    return jsonString
}

private func readLocalFile(forName name: String) -> Data? {
    do {
        if let bundlePath = Bundle.main.path(forResource: name,
                                             ofType: "json"),
            let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
            return jsonData
        }
    } catch {
        print(error)
    }
    return nil
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
    print(jsonDataRaw)
    
    if let jsonData = try! String(contentsOfFile: jsonPath).data(using: .utf8)
    {
        print("jsonData: ", jsonData)
        let decoder = JSONDecoder()
        print("decoder: ", decoder)

         do {
            let config = try decoder.decode(Config.self, from: jsonData)
            print("config: ", config)
            print(config.AppName)
            print(config.PackageName)
            print(config.AppPath)
            print(config.KeyStore)
            print(config.KeyPass)
            print(config.SigningScheme)
            return config
         } catch {
             print(error.localizedDescription)
         }
    }
    return nil
}
