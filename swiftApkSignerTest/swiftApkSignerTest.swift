//
//  swiftApkSignerTest.swift
//  swiftApkSignerTest
//
//  Created by Axel Schwarz on 05.03.21.
//

import XCTest
@testable import swiftApkSigner

extension String {
    var removingWhitespace: String {
        let result = self.unicodeScalars.filter {
            false == NSCharacterSet.whitespacesAndNewlines.contains($0)
        }.map(Character.init)
        return String(result)
    }
}

class swiftApkSignerTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testRemovingWhitespace() {
        let input = "foo \n bar!"

        let output = input.removingWhitespace

        XCTAssertEqual(output, "foobar!", "Strings not equal")
    }


    func testCreatingJsonConfig() {

        let jsonInput = """
        {
            "AppPath":"",
            "SigningScheme":0,
            "KeyStore":"",
            "KeyPass":"",
            "AppName":"",
            "PackageName":"de.telekom.appstarter"
        }
        """

        let sut = FileHandler()
        let output = sut.createJsonString(PackageName: "de.telekom.appstarter")

        XCTAssertEqual(output?.removingWhitespace, jsonInput.removingWhitespace, "Output and Input did not match")

    }

    func testConfigDecoding() throws {

        let jsonInput = """
        {
            "AppPath":"/Users/axelschwarz/Library/Developer/Xcode/DerivedData/swiftApkSigner-gqryovkkaznkrogfwnjulbdgxrqq/Build/Products/Debug/",
            "KeyStore":"test.keystore",
            "KeyPass":"pass.txt",
            "AppName":"appstarter",
            "PackageName":"de.telekom.appstarter",
            "SigningScheme":2
        }
        """

        guard let data = jsonInput.data(using: .utf8) else {
            XCTFail("Unable to create data")
            return
        }
        let decoder = JSONDecoder()

        XCTAssertNoThrow(try decoder.decode(FileHandler.Config.self, from: data), "Decoding did not work")

    }
}
