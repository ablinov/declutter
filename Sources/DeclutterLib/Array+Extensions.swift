import Foundation

extension Array {
    public func chunked(by chunkSize: Int) -> [ArraySlice<Element>] {
        stride(from: 0, to: self.count, by: chunkSize).map {
            self[$0..<Swift.min($0 + chunkSize, self.count)]
        }
    }
    
    public func divided(into numberOfChunks: Int) -> [ArraySlice<Element>] {
        let chunkSize = Int((Double(count) / Double(numberOfChunks)).rounded(.down)).clamped(to: 1...count)
        
        // Get all "whole" chunks first
        var result = stride(from: 0, to: chunkSize * (numberOfChunks - 1), by: chunkSize).map {
            self[$0..<($0 + chunkSize)]
        }
        
        // Add the last chunk which could be larger than chunkSize
        let leftOver = count - (chunkSize * (numberOfChunks - 1))
        
        if leftOver > 0 {
            result.append(self[(count - leftOver)..<count])
        }
        
        return result
    }
}

extension Array where Element: Hashable {
    public var permutationsOfPairs: [Pair<Element>] {
        guard let (element, rest) = chopped() else { return [] }
        
        let pairingsWithFirst = rest.map { Pair(first: element, second: $0) }
        
        return pairingsWithFirst + rest.permutationsOfPairs
    }
    
    func chopped() -> (Element, [Element])? {
        guard let x = self.first else { return nil }
        
        return (x, Array(self.suffix(from: 1)))
    }
}

extension Comparable {
    public func clamped(to limits: ClosedRange<Self>) -> Self {
        min(max(self, limits.lowerBound), limits.upperBound)
    }
}
