import XCTest
//@testable import Declutter
import class Foundation.Bundle

final class DeclutterTests: XCTestCase {
    func testNotProvidingInputFilePrintsError() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.

        // Some of the APIs that we use below are available in macOS 10.13 and above.
        guard #available(macOS 10.13, *) else {
            return
        }

        let fooBinary = productsDirectory.appendingPathComponent("Declutter")

        let process = Process()
        process.executableURL = fooBinary

        let stdOut = Pipe()
        let stdErr = Pipe()
        process.standardOutput = stdOut
        process.standardError = stdErr

        try process.run()
        process.waitUntilExit()

        let output = String(data: stdOut.fileHandleForReading.readDataToEndOfFile(), encoding: .utf8)
        let errorOutput = String(data: stdErr.fileHandleForReading.readDataToEndOfFile(), encoding: .utf8)

        XCTAssertEqual(output, "")
        XCTAssertTrue(errorOutput!.contains("Error: Missing expected argument '<path>'"), "Error output did not contain required text")
    }

    /// Returns path to the built products directory.
    var productsDirectory: URL {
      #if os(macOS)
        for bundle in Bundle.allBundles where bundle.bundlePath.hasSuffix(".xctest") {
            return bundle.bundleURL.deletingLastPathComponent()
        }
        fatalError("couldn't find the products directory")
      #else
        return Bundle.main.bundleURL
      #endif
    }

    static var allTests = [
        ("testExample", testNotProvidingInputFilePrintsError),
    ]
}
