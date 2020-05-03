@testable import DeclutterLib
import XCTest

class TestPair: XCTestCase {
    func testEquality() {
        XCTAssertEqual(Pair(first: 1, second: 2), Pair(first: 1, second: 2))
        XCTAssertEqual(Pair(first: 1, second: 2), Pair(first: 2, second: 1))
    }
}
