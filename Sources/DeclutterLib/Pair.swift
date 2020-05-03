import Foundation

public struct Pair<Element: Hashable & Equatable> {
    let first: Element
    let second: Element
}

extension Pair: Equatable {
    public static func == (lhs: Pair, rhs: Pair) -> Bool {
        (lhs.first == rhs.first && lhs.second == rhs.second) || (lhs.first == rhs.second && lhs.second == rhs.first)
    }
}

extension Pair: Hashable { }

extension Pair: CustomDebugStringConvertible {
    public var debugDescription: String {
        "(\(first), \(second))"
    }
}
