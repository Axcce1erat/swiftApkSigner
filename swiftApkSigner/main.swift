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

// getting data fromm Android Manifest
let urlStartScript = URL(fileURLWithPath: "/Users/axelschwarz/development/swiftApkSigner/swiftApkSigner/assets/readingAndroidManifest.sh")
let stringStartScript = "\(urlStartScript.path)"

var startApk = "AppStarter_T30-12.0.0-001-build_4616-Debug-aligned-signed.apk"

let appt = run(stringStartScript, startApk).stdout
print(appt)

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
let apk = "AppStarter_T30-12.0.0-001-build_4616-Debug-aligned-signed.apk"

// printing script output
//try runAndPrint(stringScript, keystore, pass, valueSigningScheme, apk)

let apkSignerDtagXcode = run(stringScript, keystore,  pass, valueSigningScheme, apk).stdout
print(apkSignerDtagXcode)

//
let apkParameter = getScriptDirectory().appendingPathComponent("apk_parameter.txt")

do {
    try apkSignerDtagXcode.write(to: apkParameter, atomically: true, encoding: String.Encoding.utf8)
} catch {
    // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
}

