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
    
    func testPermutations() {
        XCTAssertEqual(Array(1...3).permutationsOfPairs.count, 3)
        XCTAssertEqual(Array(1...4).permutationsOfPairs.count, 6)
        XCTAssertEqual(Array(1...5).permutationsOfPairs.count, 10)
        
        let testPermutations = Array(1...3).permutationsOfPairs
        XCTAssertTrue(testPermutations.contains(where: { $0.first == 1 && $0.second == 2}))
        XCTAssertTrue(testPermutations.contains(where: { $0.first == 1 && $0.second == 3}))
        XCTAssertTrue(testPermutations.contains(where: { $0.first == 2 && $0.second == 3}))
    }
}
