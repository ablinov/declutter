import Foundation
import Files

public struct DeclutterCalculationResult {
    public let duplicateFiles: [[File]]
    public let folderMatches: [(Folder, Folder, FolderComparisonResult)]
}

public enum FolderComparisonResult {
    case exactMatch
    case firstIsSupersetOfSecond
    case secondIsSupersetOfFirst
}
