import Foundation

public struct OrderedPair<Element: Hashable & Equatable & Comparable> {
    let first: Element
    let second: Element
    
    init(_ first: Element, _ second: Element) {
        if first < second {
            self.first = first
            self.second = second
        } else {
            self.first = second
            self.second = first
        }
    }
}

extension OrderedPair: Equatable { }

extension OrderedPair: Hashable { }

extension OrderedPair: CustomDebugStringConvertible {
    public var debugDescription: String {
        "(\(first), \(second))"
    }
}
