import Files
import Foundation
import CommonCrypto

public struct FileWithHash {
    public let file: File
    public let md5Hash: String
    
    init(with file: File) throws {
        self.file = file
        self.md5Hash = try calculateMD5Hash(forFileAt: file.path)
    }
}

extension FileWithHash: Equatable {
    public static func == (lhs: FileWithHash, rhs: FileWithHash) -> Bool {
        lhs.md5Hash == rhs.md5Hash
    }
}

extension FileWithHash: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(md5Hash)
    }
}

private func calculateMD5Hash(forFileAt path: String) throws -> String {
    let bufferSize = 1024 * 1024

    guard let fileHandle = FileHandle(forReadingAtPath: path) else { throw FileSystem.Item.PathError.invalid(path) }
    defer { fileHandle.closeFile() }

    var context = CC_MD5_CTX()
    CC_MD5_Init(&context)

    // Read up to `bufferSize` bytes, until EOF is reached, and update MD5 context:
    while autoreleasepool(invoking: {
        let data = fileHandle.readData(ofLength: bufferSize)
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
