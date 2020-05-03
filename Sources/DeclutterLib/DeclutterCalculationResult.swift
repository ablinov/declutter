import Foundation
import Files

public struct DeclutterCalculationResult {
    public let duplicateFiles: [[File]]
    public let folderMatches: [(Folder, Folder, FolderComparisonResult)]
}

public enum FolderComparisonResult: Int, Comparable {
    public static func < (lhs: FolderComparisonResult, rhs: FolderComparisonResult) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
    
    case exactMatch
    case firstIsSupersetOfSecond
    case firstIsSubsetOfSecond
}
