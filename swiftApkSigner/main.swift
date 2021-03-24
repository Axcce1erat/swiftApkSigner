//  Created by Axel Schwarz
import Foundation
import AppKit
import SwiftShell

let appt = Preparation().dataFromAndroidManifest()

let (packageName, versionCode, versionName, debug) = Preparation().filterWithRegex(appt: appt)

let debugOption = Preparation().debugRelease(debugOption: debug)

FileHandler().createAssetsDir()
FileHandler().createConfigDir()

let checkJsonResult: String = FileHandler().checkJson()

let jsonFileAt = FileHandler().getScriptDirectory().appendingPathComponent("\(packageName)_Config.json")
let jsonFileTo = FileHandler().getScriptDirectory().appendingPathComponent("configs/\(packageName)_Config.json")
let jsonFileToStrig = "\(jsonFileTo.path)"

let fileManager = FileManager.default

do {
    try fileManager.moveItem(at: jsonFileAt, to: jsonFileTo)
}
catch let error as NSError {
    print("Ooops! Something went wrong with cut and copy the Config.json results: \(error)")
}

if let newJsonData = FileHandler().handleJsonData(jsonPath: jsonFileToStrig){
    
    let apkName = "\(newJsonData.AppName)_\(versionName)_\(versionCode)_\(debugOption).apk"

    FileHandler().reNameApkFile(apkName: apkName)

    let stringScript = FileHandler().dataFromSingingScript()
    let stringSigningScheme: String = String(newJsonData.SigningScheme)
    
    let apkSignerDtagXcode = run(stringScript, "assets/\(newJsonData.KeyStore)", "assets/\(newJsonData.KeyPass)", stringSigningScheme, apkName).stdout
    print(apkSignerDtagXcode)
    
    let apkParameter = FileHandler().getScriptDirectory().appendingPathComponent("\(newJsonData.AppName)_\(versionName)_\(versionCode)_\(debugOption)_log.txt")

    do {
        try apkSignerDtagXcode.write(to: apkParameter, atomically: true, encoding: String.Encoding.utf8)
    } catch {
        print ("failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding")
    }
    
    let apkNameWithoutIndex = "\(newJsonData.AppName)_\(versionName)_\(versionCode)_\(debugOption)"
    let apkParameterName = "\(newJsonData.AppName)_\(versionName)_\(versionCode)_\(debugOption)_log.txt"
    
    func handelSubDir() -> String{
        if(newJsonData.AppName == newJsonData.AppPath){
            let appNameDir = newJsonData.AppName
            return appNameDir
        }
        else{
            let appNameDir = newJsonData.AppPath
            return appNameDir
        }
    }
    
    let apkNameURL: URL = FileHandler().getScriptDirectory().appendingPathComponent(apkName)
    let apkNameAlinged: URL = FileHandler().getScriptDirectory().appendingPathComponent("\(apkNameWithoutIndex)_aligned.apk")
    let apkNameAlingedSigned: URL = FileHandler().getScriptDirectory().appendingPathComponent("\(apkNameWithoutIndex)_aligned_signed.apk")
    let apkParameterToString: URL = apkParameter
    
    let destionationPath = "signedApks/\(handelSubDir())/\(versionName)/\(debugOption)"
    let scriptURLDestionation = FileHandler().getScriptDirectory().appendingPathComponent(destionationPath)
    
    let apkNameUrlDes: URL = FileHandler().getScriptDirectory().appendingPathComponent("\(destionationPath)/\(apkName)")
    let apkNameAlingedDes: URL = FileHandler().getScriptDirectory().appendingPathComponent("\(destionationPath)/\(apkNameWithoutIndex)_aligned.apk")
    let apkNameAlingedSignedDes: URL = FileHandler().getScriptDirectory().appendingPathComponent("\(destionationPath)/\(apkNameWithoutIndex)_aligned_signed.apk")
    let apkParameterToStringDes: URL = FileHandler().getScriptDirectory().appendingPathComponent("\(destionationPath)/\(apkParameterName)")
      
    let fileManager = FileManager.default
    
    do {
        try fileManager.createDirectory(at: scriptURLDestionation, withIntermediateDirectories: true, attributes: nil)
    }
    catch let error as NSError {
        print("Ooops! Something went wrong with creating directorys: \(error)")
    }
    
    do {
        try fileManager.moveItem(at: apkNameURL, to: apkNameUrlDes)
        try fileManager.moveItem(at: apkNameAlinged, to: apkNameAlingedDes)
        try fileManager.moveItem(at: apkNameAlingedSigned, to: apkNameAlingedSignedDes)
        try fileManager.moveItem(at: apkParameterToString, to: apkParameterToStringDes)
    }
    catch let error as NSError {
        print("Ooops! Something went wrong with cut and copy the singing results: \(error)")
    }
}
