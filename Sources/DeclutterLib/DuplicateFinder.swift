import Foundation
import Files
import Logging

public func findDuplicateFiles(in folder: Folder,
                               ignoring foldersToIgnore: [Folder] = [],
                               withLogger logger: Logger = Logger(label: "DuplicateFileFinder")) throws -> DeclutterCalculationResult {
    logger.info("Gathering files")
    
    let allFiles = recursivelyCollectFiles(in: folder, ignoring: foldersToIgnore)
    
    logger.info("Gathered \(allFiles.count) files")
    
    logger.info("Calculating hashes")
    
    var allFilesWithHash: [FileWithHash] = []
    var anyError: Error? = nil

    let numberOfSlices = allFiles.count.clamped(to: 1...32)
    let fileSlices = allFiles.divided(into: numberOfSlices)
            
    let resultCollationQueue = DispatchQueue(label: "HashCalculation.ResultCollation")
    
    logger.info("Split files into \(fileSlices.count) slices")
    DispatchQueue.concurrentPerform(iterations: fileSlices.count) { i in
        let slice = fileSlices[i]
        var sliceFiles: [FileWithHash] = []
        var sliceError: Error? = nil
        
        for file in slice {
            let fileWithHashResult = Result { try FileWithHash(with: file) }
            
            switch fileWithHashResult {
            case .success(let fileWithHash):
                sliceFiles.append(fileWithHash)
            case .failure(let error):
                sliceError = error
                break
            }
        }
        
        resultCollationQueue.sync {
            if let sliceError = sliceError {
                anyError = sliceError
            } else {
                allFilesWithHash.append(contentsOf: sliceFiles)
            }
        }
    }
    
    if let error = anyError { throw error }
    
    let allFilesByHash = Dictionary.init(grouping: allFilesWithHash) { $0.md5Hash }
    
    logger.info("Finished calculting hashes. Found \(allFilesByHash.count) unique files")
    
    let duplicateFiles = allFilesByHash.values.filter { $0.count > 1 }
    let duplicateFolderCandidates = duplicateFiles.map { $0.map(\.file.parent!) }
    let pairsOfDuplicateFolderCandidates = Set(duplicateFolderCandidates.flatMap { $0.permutationsOfPairs })
    
    logger.info("Duplicate folder candidates:")
    for dup in pairsOfDuplicateFolderCandidates {
        logger.info("\(dup)")
    }
    
    return DeclutterCalculationResult(duplicateFiles: duplicateFiles.map { $0.map(\.file) }, folderMatches: [])
}
