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

let checkJsonResult: String = FileHandler().checkJson()

if let newJsonData = FileHandler().handleJsonData(jsonPath: checkJsonResult){
    
    //concatenate strings for apk name
    let apkName = "\(newJsonData.AppName)_\(versionName)_\(versionCode)_\(debugOption).apk"

    // rename apk file inScript
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
    
    let stringScript = FileHandler().dataFromSingingScript()
    let stringSigningScheme: String = String(newJsonData.SigningScheme)
    
    let apkSignerDtagXcode = run(stringScript, newJsonData.KeyStore, newJsonData.KeyPass, stringSigningScheme, apkName).stdout
    print(apkSignerDtagXcode)
    
    let apkParameter = FileHandler().getScriptDirectory().appendingPathComponent("\(newJsonData.AppName)_\(versionName)_\(versionCode)_\(debugOption)_log.txt")

    do {
        try apkSignerDtagXcode.write(to: apkParameter, atomically: true, encoding: String.Encoding.utf8)
    } catch {
        print ("failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding")
    }
}
