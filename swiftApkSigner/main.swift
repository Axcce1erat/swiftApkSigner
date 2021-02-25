import Foundation
import AppKit
import SwiftShell
//import ArgumentParser 
//import PackageDescription

// xml file vom apk with values

/*
// gets keystore file from extension
let keystore = NSURL(fileURLWithPath: "test.keystore").pathExtension

let utiKeystore = UTTypeCreatePreferredIdentifierForTag(
    kUTTagClassFilenameExtension,
    keystore! as CFString,
    nil)

if UTTypeConformsTo((utiKeystore?.takeRetainedValue())!, kUTTypeImage) {
    print("This is an keystore file!")
}

// shows all existing files in a directory
let fm = FileManager.default
let homepath = NSHomeDirectory()
if let files = try? fm.contents(atPath: homepath){
    for file in files {
        print(file)
    }
}

// prints all files from assets on
let filesInAssets = NSWorkspace.shared.selectFile(nil, inFileViewerRootedAtPath: "axelschwarz/development/swiftApkSigner/swiftApkSigner/assets")
print(filesInAssets)
 
 // function that shows files in directory
 func showInFinder(url: URL?) {
     guard let url = url else { return }
     
     if url.isDirectory {
         NSWorkspace.shared.selectFile(nil, inFileViewerRootedAtPath: url.path)
     }
     else {
         showInFinderAndSelectLastComponent(of: url)
     }
 }

 func showInFinderAndSelectLastComponent(of url: URL) {
     NSWorkspace.shared.activateFileViewerSelecting([url])
 }
*/

let urlScript = URL(fileURLWithPath: "/Users/axelschwarz/development/swiftApkSigner/swiftApkSigner/assets/apkSignerDtagXcode.sh")
let stringScript = "\(urlScript.path)"
 
var keystore = "test.keystore"
var pass = "pass.txt"
var valueSigningScheme = "2"
var apk = "release_unsigned.apk"

try runAndPrint(stringScript, keystore, pass, valueSigningScheme, apk)
