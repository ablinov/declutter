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
        
        let duplicates = try findDuplicateFiles(in: sourceFolder, ignoring: foldersToIgnore)
        
        if duplicates.count > 0 {
            let totalDuplicateFiles = duplicates.reduce(0) { $0 + ($1.count - 1) }
            
            logger.info("Found \(totalDuplicateFiles) that are duplicates and can be deleted")
        } else {
            logger.info("Did not find any duplicates in \(path)")
        }

        let duplicatePaths = duplicates.map { $0.map(\.path) }

        try write(duplicateResults: duplicatePaths, to: outputFile)
    }
}

Declutter.main()
