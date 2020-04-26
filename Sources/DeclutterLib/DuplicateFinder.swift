import Foundation
import Files
import Logging

public func findDuplicateFiles(in folder: Folder,
                               ignoring foldersToIgnore: [Folder] = [],
                               withLogger logger: Logger = Logger(label: "DuplicateFileFinder")) throws -> [[File]] {
    logger.info("Gathering files")
    
    let allFiles = recursivelyCollectFiles(in: folder, ignoring: foldersToIgnore)
    
    logger.info("Gathered \(allFiles.count) files")
    
    logger.info("Calculating hashes")
    
    var allFilesByHash: [String: [File]] = [:]
    var anyError: Error? = nil

    let numberOfSlices = allFiles.count.clamped(to: 1...32)
    let fileSlices = allFiles.divided(into: numberOfSlices)
            
    let resultCollationQueue = DispatchQueue(label: "HashCalculation.ResultCollation")
    
    logger.info("Split files into \(fileSlices.count) slices")
    DispatchQueue.concurrentPerform(iterations: fileSlices.count) { i in
        let slice = fileSlices[i]
        var sliceHashes: [String: [File]] = [:]
        var sliceError: Error? = nil
        
        for file in slice {
            let hashCalculation = Result { try file.calculateMD5Hash() }
            
            switch hashCalculation {
            case .success(let hash):
                sliceHashes[hash, default: []].append(file)
            case .failure(let error):
                sliceError = error
                break
            }
        }
        
        resultCollationQueue.sync {
            if let sliceError = sliceError {
                anyError = sliceError
            } else {
                allFilesByHash.merge(sliceHashes) { $0 + $1 }
            }
        }
    }
    
    if let error = anyError { throw error }
    
    logger.info("Finished calculting hashes. Found \(allFilesByHash.count) unique files")
    
    let duplicates = allFilesByHash.values.filter { $0.count > 1 }
    
    return duplicates
}
