@testable import DeclutterLib
import XCTest

class TestArrayExtensions: XCTestCase {
    func testChunking() {
        let testArrays = [Array(1...51),
                          Array(4...568),
                          Array(-1...104578),
        ]
        
        let chunks = [2, 3, 10, 11]
        
        for array in testArrays {
            for chunkSize in chunks {
                let result = array.divided(into: chunkSize)
                
                XCTAssertEqual(result.count, chunkSize)
                XCTAssertEqual(result.reduce(0, { $0 + $1.count }), array.count)
            }
        }
        
        XCTAssertEqual(Array(1...51).divided(into: 52).count, 51)
    }
}
