import Foundation
import AppKit
import SwiftShell

let fileFinderCurrent = FileFinderCurrent()
let fileFinder = FileFinder()

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


let urlStartScript = URL(fileURLWithPath: "/Users/axelschwarz/development/swiftApkSigner/swiftApkSigner/assets/readingAndroidManifest.sh")
let stringStartScript = "\(urlStartScript.path)"

var startApk = "release_unsigned.apk"

let appt = run(stringStartScript, startApk).stdout
print(appt)

/*
let urlScript = URL(fileURLWithPath: "/Users/axelschwarz/development/swiftApkSigner/swiftApkSigner/assets/apkSignerDtagXcode.sh")
let stringScript = "\(urlScript.path)"
 
let keystore = "test.keystore"
let pass = "pass.txt"
let valueSigningScheme = "2"
let apk = "release_unsigned.apk"

try runAndPrint(stringScript, keystore, pass, valueSigningScheme, apk)
*/
