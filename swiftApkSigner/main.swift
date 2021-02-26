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
   let fileFinder = FileFinder()
   //let apkName = CommandLine.arguments[1]
   let argument = "keystore"
   fileFinder.searchInSubDir(subDir: argument)
   let fileFinderCurrent = FileFinderCurrent()
   fileFinderCurrent.searchInDir()
}

// getting data fromm Android Manifest
let urlStartScript = URL(fileURLWithPath: "/Users/axelschwarz/development/swiftApkSigner/swiftApkSigner/assets/readingAndroidManifest.sh")
let stringStartScript = "\(urlStartScript.path)"

var startApk = "release_unsigned.apk"

let appt = run(stringStartScript, startApk).stdout
print(appt)

// writing to text file
let filename = getDesktopDirectory().appendingPathComponent("PackageNameConfig.txt")

do {
    try appt.write(to: filename, atomically: true, encoding: String.Encoding.utf8)
} catch {
    // failed to write file – bad permissions, bad filename, missing permissions, or more likely it can't be converted to the encoding
}
/*
func getCurrentDirectory (){
    let fileManager = FileManager.default
    
    // Get path where the script is
    let currentDirectory = fileManager.currentDirectoryPath
 */
func getDesktopDirectory() -> URL {
    let paths = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask)
    return paths[0]
}

/*
 
// getting data from singing script
let urlScript = URL(fileURLWithPath: "/Users/axelschwarz/development/swiftApkSigner/swiftApkSigner/assets/apkSignerDtagXcode.sh")
let stringScript = "\(urlScript.path)"
 
let keystore = "test.keystore"
let pass = "pass.txt"
let valueSigningScheme = "2"
let apk = "release_unsigned.apk"

// printing script output
try runAndPrint(stringScript, keystore, pass, valueSigningScheme, apk)
*/
