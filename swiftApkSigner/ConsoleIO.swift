import Foundation

enum OutputType {
  case error
  case standard
}

class ConsoleIO {
    func writeMessage(_ message: String, to: OutputType = .standard) {
      switch to {
      case .standard:
        print("\(message)")
      case .error:
        fputs("Error: \(message)\n", stderr)
      }
    }

    func printUsage() {

      let executableName = (CommandLine.arguments[0] as NSString).lastPathComponent
            
      writeMessage("usage:")
      writeMessage("To show all apk files in the folder: \(executableName)")
      writeMessage("And to show all text/keystore files in the subfolder: \(executableName) subfolder")
    }
}

