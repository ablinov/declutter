import Foundation
import ArgumentParser
import Files
import Logging

let logger = Logger(label: "main")

struct Declutter: ParsableCommand {
    
    @Argument(help: "Specify directory to declutter")
    var path: String
    
    @Flag(name: .shortAndLong, default: false, inversion: .prefixedNo)
    var dryRun: Bool
    
    func run() throws {
        logger.info("Gathering files")
        
        let sourceFolder = try Folder(path: path)
        var allFiles = Array(sourceFolder.files)
        
        sourceFolder.makeSubfolderSequence(recursive: true, includeHidden: false).forEach { subfolder in
            allFiles.append(contentsOf: subfolder.files)
        }
        
        logger.info("Gathered \(allFiles.count) files")
        
        var filesByHash: [String: [File]] = [:]
        var anyError: Error? = nil

        let numberOfSlices = allFiles.count.clamped(to: 1...32)
        let slices = Array(allFiles).divided(into: numberOfSlices)
        
        logger.info("Calculating hashes for \(slices.count) slices")
        
        let resultCollationQueue = DispatchQueue(label: "HashCalculation.ResultCollation")
        
        DispatchQueue.concurrentPerform(iterations: slices.count) { i in
            let slice = slices[i]
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
                    filesByHash.merge(sliceHashes) { $0 + $1 }
                }
            }
        }
        
        guard anyError == nil else { throw anyError! }

        logger.info("Finished calculting hashes. Found \(filesByHash.count) unique files")
        
        let duplicates = filesByHash.values.filter { $0.count > 1 }

        if duplicates.count > 0 {
            let totalDuplicateFiles = duplicates.reduce(0) { $0 + ($1.count - 1) }
            logger.info("Found \(totalDuplicateFiles) that are duplicates and can be deleted")

//            duplicates.forEach { duplicateFiles in
//                duplicateFiles.forEach { print($0.path) }
//            }
        } else {
            logger.info("Did not find any duplicates in \(path)")
        }
    }
}

Declutter.main()
