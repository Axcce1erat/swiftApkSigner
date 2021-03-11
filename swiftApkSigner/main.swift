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

//json hanling
FileHandler().writingStartJson(PackageName: packageName)

let jsonString = """
{
       "PackageName": "de.telekom.appstarter",
       "AppName": "appstarter",
       "AppPath": "User/axelscwharz/Desktop",
       "KeyStore": "test.keystore",
       "KeyPass": "pass.txt",
       "SigningScheme": 2
}
"""

struct Config: Codable
{
    var PackageName: String
    var AppName: String
    var AppPath: String
    var KeyStore: String
    var KeyPass: String
    var SigningScheme: Int
}

if let jsonData = jsonString.data(using: .utf8)
{
    let decoder = JSONDecoder()

    do {
        let config = try decoder.decode(Config.self, from: jsonData)
        print(config.AppName)
        print(config.AppPath)
        print(config.PackageName)
        print(config.KeyStore)
        print(config.KeyPass)
        print(config.SigningScheme)
        /*
        let appName:String = config.AppName
        let appPath:String = config.AppPath
        let packageName:String = config.PackageName
        let keyStore:String = config.KeyStore
        let keyPass:String = config.KeyPass
        let signingScheme:Int = config.SigningScheme
        */
    } catch {
        print(error.localizedDescription)
    }
}
