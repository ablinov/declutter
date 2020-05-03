import Foundation
import ArgumentParser
import Files
import Logging
import DeclutterLib

let logger = Logger(label: "main")

struct Declutter: ParsableCommand {
    
    @Argument(help: "Specify folder to declutter")
    var path: String
    
    @Argument(default: "results.json", help: "Specify output file")
    var outputFileName: String
    
    @Option(help: "Folders to ignore")
    var ignore: [String]
    
    @Flag(name: .shortAndLong, default: false, inversion: .prefixedNo)
    var dryRun: Bool
    
    func run() throws {
        let sourceFolder = try Folder(path: path)
        let outputFile = try Folder.current.createFileIfNeeded(withName: outputFileName)
        let foldersToIgnore = try ignore.map { try Folder(path: $0) }
        
        let result = try findDuplicateFiles(in: sourceFolder, ignoring: foldersToIgnore)
        
        if result.duplicateFiles.count > 0 {
            let totalDuplicateFiles = result.duplicateFiles.reduce(0) { $0 + ($1.count - 1) }
            
            logger.info("Found \(totalDuplicateFiles) files that are duplicates and can be deleted")
        } else {
            logger.info("Did not find any duplicates in \(path)")
        }
        
        for folderMatch in result.folderMatches {
            let firstPath = folderMatch.0.path(relativeTo: sourceFolder)
            let secondPath = folderMatch.1.path(relativeTo: sourceFolder)
            
            switch folderMatch.2 {
            case .exactMatch:
                logger.info("✅ = \(firstPath) contains exactly the same files as \(secondPath)")
            case .firstIsSupersetOfSecond:
                logger.info("✅ > \(firstPath) contains all files from \(secondPath) and some more files")
            case .secondIsSupersetOfFirst:
                logger.info("✅ > \(secondPath) contains all files from \(firstPath) and some more files")
            }
        }

        let duplicatePaths = result.duplicateFiles.map { $0.map(\.path) }

        try write(duplicateResults: duplicatePaths, to: outputFile)
    }
}

Declutter.main()
