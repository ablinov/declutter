import Foundation
import Files
import CommonCrypto

extension File {
    public func calculateMD5Hash() throws -> String {
        let bufferSize = 1024 * 1024

        guard let file = FileHandle(forReadingAtPath: path) else { throw FileSystem.Item.PathError.invalid(path) }
        defer { file.closeFile() }

        var context = CC_MD5_CTX()
        CC_MD5_Init(&context)

        // Read up to `bufferSize` bytes, until EOF is reached, and update MD5 context:
        while autoreleasepool(invoking: {
            let data = file.readData(ofLength: bufferSize)
            if data.count > 0 {
                data.withUnsafeBytes {
                    _ = CC_MD5_Update(&context, $0.baseAddress, numericCast(data.count))
                }
                return true
            } else {
                return false
            }
        }) { }

        var digest: [UInt8] = Array(repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        _ = CC_MD5_Final(&digest, &context)

        let data = Data(digest)
        let hashString = data.map { String(format: "%02hhx", $0) }.joined()
        
        return hashString
    }
}

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
