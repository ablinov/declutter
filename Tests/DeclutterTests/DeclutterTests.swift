import XCTest
import Files
import class Foundation.Bundle

@available(OSX 10.13, *)
final class DeclutterTests: XCTestCase {
    override func setUpWithError() throws {
        let testDataDirectory = try createTestDataDirectoryIfNeeded()
        
        let A = try testDataDirectory.createSubfolderIfNeeded(withName: "A")
        try A.createFile(named: "a.txt", contents: "a")
        try A.createFile(named: "b.txt", contents: "b")
        
        let CopyOfA = try testDataDirectory.createSubfolderIfNeeded(withName: "exact_copy_of_A")
        try CopyOfA.createFile(named: "w.txt", contents: "a")
        try CopyOfA.createFile(named: "z.txt", contents: "b")
        
        let SubSetOfA = try testDataDirectory.createSubfolderIfNeeded(withName: "subset_of_A")
        try SubSetOfA.createFile(named: "a.txt", contents: "a")
        
        let SuperSetofA = try testDataDirectory.createSubfolderIfNeeded(withName: "superset_of_A")
        try SuperSetofA.createFile(named: "a.txt", contents: "a")
        try SuperSetofA.createFile(named: "bee.txt", contents: "b")
        try SuperSetofA.createFile(named: "c.txt", contents: "c")
    }

    override func tearDownWithError() throws {
        try Folder(path: testDataDirectoryPath).delete()
    }
    
    func testWithTestData() throws {

        let (output, errorOutput) = try getOutputForRunningBinary(with: testDataDirectoryPath)
        
        let firstDuplicateSet = """
    A/b.txt
    exact_copy_of_A/z.txt
    superset_of_A/bee.txt
"""
        let secondDuplicateSet = """
    A/a.txt
    exact_copy_of_A/w.txt
    subset_of_A/a.txt
    superset_of_A/a.txt
"""        
        XCTAssertTrue(output.contains("Found 2 sets of identical files"), "Did not find correct number of sets of duplicates")
        XCTAssertTrue(output.contains(firstDuplicateSet))
        XCTAssertTrue(output.contains(secondDuplicateSet))
        XCTAssertTrue(errorOutput.isEmpty)
    }
    
    private func getOutputForRunningBinary(with arguments: String...) throws -> (output: String, errorOutput: String) {
        let binary = productsDirectory.appendingPathComponent("Declutter")

        let process = Process()
        process.executableURL = binary

        let stdOut = Pipe()
        let stdErr = Pipe()
        process.standardOutput = stdOut
        process.standardError = stdErr
        process.arguments = arguments

        try process.run()
        process.waitUntilExit()

        let output = String(data: stdOut.fileHandleForReading.readDataToEndOfFile(), encoding: .utf8)!
        let errorOutput = String(data: stdErr.fileHandleForReading.readDataToEndOfFile(), encoding: .utf8)!

        return (output, errorOutput)
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
    
    var testDataDirectoryPath: String {
        productsDirectory.appendingPathComponent("test_data").path
    }
    
    func createTestDataDirectoryIfNeeded() throws -> Folder {
        let p = try Folder(path: productsDirectory.path)
        
        return try p.createSubfolderIfNeeded(withName: "test_data")
    }

    static var allTests = [
        ("testWithTestData", testWithTestData),
    ]
}
