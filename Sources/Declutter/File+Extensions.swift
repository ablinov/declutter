import Foundation
import Files
import CommonCrypto

extension File {
    func calculateMD5Hash() throws -> String {
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

extension Array {
    func chunked(by chunkSize: Int) -> [ArraySlice<Element>] {
        stride(from: 0, to: self.count, by: chunkSize).map {
            self[$0..<Swift.min($0 + chunkSize, self.count)]
        }
    }
    
    func divided(into numberOfChunks: Int) -> [ArraySlice<Element>] {
        let chunkSize = Int(count / numberOfChunks).clamped(to: 1...count)
        
        return self.chunked(by: chunkSize)
    }
}

extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        min(max(self, limits.lowerBound), limits.upperBound)
    }
}
