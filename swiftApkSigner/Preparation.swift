import Foundation
import SwiftShell

class Preparation{
    
    func dataFromAndroidManifest() -> String{
        
        let stringStartScript = Bundle.main.path(forResource: "scripts/readingAndroidManifest", ofType: ".sh")
        print(stringStartScript)
        //let path = URL(fileReferenceLiteralResourceName: "readingAndroidManifest.sh")
        //let path = URL(fileURLWithPath: "/Users/axelschwarz/development/swiftApkSigner/swiftApkSigner/readingAndroidManifest.sh")
        //let stringStartScript = "\(path!.path)"
        
        guard let startApk = Bundle.main.path(forResource: nil, ofType: "apk")
        else {
            fatalError("apk not found")
        }

        let appt = run(stringStartScript!, startApk).stdout
        
        return appt
    }
    
    func filterWithRegex(appt: String) -> (String, String, String, String?){
        
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
        if result.contains(["application-debuggable"]) {
            let packageName = result[0].reduce("", +)
            let versionCode = result[1].reduce("", +)
            let versionName = result[2].reduce("", +)
            let debug = result[5].reduce("", +)
            return (packageName, versionCode, versionName, debug)
        }
        else{
            let packageName = result[0].reduce("", +)
            let versionCode = result[1].reduce("", +)
            let versionName = result[2].reduce("", +)
            return (packageName, versionCode, versionName, debug)
        }
    }
    
    func debugRelease(debugOption: String?) -> String {
        if (debugOption == "application-debuggable"){
            let debugOption = "debug"
            return debugOption
        }
        else{
            let release = "release"
            return release
        }
    }
    
    
}
