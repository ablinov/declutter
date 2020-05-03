import Foundation
import Files

func recursivelyCollectFiles(in folder: Folder, ignoring foldersToIgnore: [Folder] = []) -> [File] {
    guard !foldersToIgnore.contains(folder) else { return [] }
    
    return Array(folder.files) + folder.subfolders.flatMap { recursivelyCollectFiles(in: $0, ignoring: foldersToIgnore) }
}

extension Folder {
    public func isWithin(_ anotherFolder: Folder) -> Bool {
        var currentParent = parent
        
        while currentParent != nil {
            if currentParent == anotherFolder {
                return true
            }
            
            currentParent = currentParent?.parent
        }
        
        return false
    }
}

extension Folder: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(path)
    }
}

extension Folder: Comparable {
    public static func < (lhs: Folder, rhs: Folder) -> Bool {
        lhs.path < rhs.path
    }
}

extension FileSystem.Item {
    enum FileError: Error {
        case folderContentsChanged
    }
}
