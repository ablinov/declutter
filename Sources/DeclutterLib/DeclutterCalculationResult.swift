import Foundation
import Files

public struct DeclutterCalculationResult {
    public let duplicateFiles: [[File]]
    public let folderMatches: [(first: Folder, second: Folder, comparisonResult: FolderComparisonResult)]
}

public enum FolderComparisonResult {
    case exactMatch
    case firstIsSupersetOfSecond([File])
    case firstIsSubsetOfSecond([File])
}
