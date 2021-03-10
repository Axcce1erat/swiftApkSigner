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

// getting data fromm Android Manifest in one string
let urlStartScript = URL(fileURLWithPath: "/Users/axelschwarz/development/swiftApkSigner/swiftApkSigner/assets/readingAndroidManifest.sh")
let stringStartScript = "\(urlStartScript.path)"

var startApk = "de.telekom.appstarter_12.0.0-001_120000000_debug.apk"

let appt = run(stringStartScript, startApk).stdout
print(appt)

let pattern = #"'(.*?)\'|W*(application-debuggable)\W*"#
let regex = try! NSRegularExpression(pattern: pattern)
let testString = appt
let stringRange = NSRange(location: 0, length: testString.utf16.count)
let matches = regex.matches(in: testString, range: stringRange)
var result: [[String]] = []
for match in matches {
  var groups: [String] = []
  for rangeIndex in 1 ..< match.numberOfRanges {
    let range: NSRange = match.range(at: rangeIndex)
    guard range.location != NSNotFound, range.length != 0 else {
        continue
    }
    groups.append((testString as NSString).substring(with: match.range(at: rangeIndex)))
  }
  if !groups.isEmpty {
    result.append(groups)
  }
}
print(result)

let name = result[0].reduce("", +)
print(name)
let versionCode = result[1].reduce("", +)
print(versionCode)
let versionName = result[2].reduce("", +)
print(versionName)
let compileSdkVersion = result[3].reduce("", +)
print(compileSdkVersion)
let compileSdkVersionCodename = result[4].reduce("", +)
print(compileSdkVersionCodename)
let debug = result[5].reduce("", +)
print(debug)

func debugRelease(debugOption: String) -> String {
    if (debugOption == "application-debuggable"){
        let debugOption = "debug"
        return debugOption
    }
    else{
        let release = "release"
        return release
    }
}

//let debugOption = DebugOrRelease()
let debugOption = debugRelease(debugOption: debug)

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

/*
let sepparated = appt.components(separatedBy: CharacterSet(charactersIn: " ='"))
//let sepparatedNextLine = appt.components(separatedBy: CharacterSet(charactersIn: "\n"))
let keys = sepparated.enumerated().filter{$0.0 % 4 == 3}
let debugKey = sepparated.enumerated().filter{$0.0 % 21 == 20}
print (keys)
print (debugKey)

let name = keys[0]
print(name)
let versionCode = keys[1]
print(versionCode)
let versionName = keys[2]
print(versionName)
let compileSdkVersion = keys[3]
print(compileSdkVersion)
let compileSdkVersionCodename = keys[4]
print(compileSdkVersionCodename)
let debug = debugKey[0]
print(debug)
*/

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

