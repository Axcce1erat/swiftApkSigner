import Foundation
import AppKit
import SwiftShell

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

let appt = Preparation().dataFromAndroidManifest()

let (name, versionCode, versionName, debug) = Preparation().filterWithRegex(appt: appt)

let debugOption = Preparation().debugRelease(debugOption: debug)

//concatenate strings for apk name
let apkName = "\(name)_\(versionName)_\(versionCode)_\(debugOption).apk"
print("End APK name is: ",apkName)

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
func getScriptDirectory() -> URL {
    //let paths = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask)
    let paths = URL(fileURLWithPath: "/Users/axelschwarz/Library/Developer/Xcode/DerivedData/swiftApkSigner-gqryovkkaznkrogfwnjulbdgxrqq/Build/Products/Debug")
    return paths
}

let packageNameConfig = getScriptDirectory().appendingPathComponent("PackageNameConfig.txt")

do {
    try appt.write(to: packageNameConfig, atomically: true, encoding: String.Encoding.utf8)
} catch {
    print ("failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding")
}

/*
func getCurrentDirectory (){
    let fileManager = FileManager.default
    
    // Get path where the script is
    let currentDirectory = fileManager.currentDirectoryPath
}
 */

// getting data from singing script
let urlScript = URL(fileURLWithPath: "/Users/axelschwarz/development/swiftApkSigner/swiftApkSigner/assets/apkSignerDtagXcode.sh")
let stringScript = "\(urlScript.path)"
 
let keystore = "test.keystore"
let pass = "pass.txt"
let valueSigningScheme = "2"

// printing script output
//try runAndPrint(stringScript, keystore, pass, valueSigningScheme, apk)

let apkSignerDtagXcode = run(stringScript, keystore,  pass, valueSigningScheme, apkName).stdout
print(apkSignerDtagXcode)


let apkParameter = getScriptDirectory().appendingPathComponent("apk_parameter.txt")

do {
    try apkSignerDtagXcode.write(to: apkParameter, atomically: true, encoding: String.Encoding.utf8)
} catch {
    // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
}

