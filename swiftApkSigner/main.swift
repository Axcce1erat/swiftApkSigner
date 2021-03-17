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

let checkJsonResult: String = FileHandler().checkJson()
print("checkJsonResult: ", checkJsonResult)
if let newJsonData = FileHandler().handleJsonData(jsonPath: checkJsonResult){
    print("newJsonData: ", newJsonData)
    print("newJsonData.PackageName: ", newJsonData.PackageName)
    print("newJsonData.AppName: ", newJsonData.AppName)
    print("newJsonData.AppPath: ", newJsonData.AppPath)
    print("newJsonData.KeyStore: ", newJsonData.KeyStore)
    print("newJsonData.KeyPass: ", newJsonData.KeyPass)
    print("newJsonData.SigningScheme: ", newJsonData.SigningScheme)
    
    let stringScript = FileHandler().dataFromSingingScript()
    let stringSigningScheme: String = String(newJsonData.SigningScheme)
    
    let apkSignerDtagXcode = run(stringScript, newJsonData.KeyStore, newJsonData.KeyPass, stringSigningScheme, apkName).stdout
    print(apkSignerDtagXcode)
    
    let apkParameter = FileHandler().getScriptDirectory().appendingPathComponent("apk_parameter.txt")

    do {
        try apkSignerDtagXcode.write(to: apkParameter, atomically: true, encoding: String.Encoding.utf8)
    } catch {
        print ("failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding")
    }
}
else{
    
}
