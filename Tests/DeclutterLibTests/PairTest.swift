@testable import DeclutterLib
import XCTest

class TestPair: XCTestCase {
    func testEquality() {
        XCTAssertEqual(OrderedPair(1, 2), OrderedPair(1, 2))
        XCTAssertEqual(OrderedPair(1, 2), OrderedPair(2, 1))
        
        let testSet = Set([OrderedPair(1, 2),
                           OrderedPair(2, 1),])
        XCTAssertEqual(testSet.count, 1)
    }
}
