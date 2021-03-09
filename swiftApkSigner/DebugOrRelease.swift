//
//  DebugOrRelease.swift
//  swiftApkSigner
//
//  Created by Axel Schwarz on 05.03.21.
//
import Foundation

class DebugOrRelease{
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
}

