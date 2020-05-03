import Foundation
import ArgumentParser
import Files
import DeclutterLib
import Chalk

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
            
            print("Found \(totalDuplicateFiles) files that are duplicates and can be deleted")
        } else {
            print("Did not find any duplicates in \(path)")
        }
        
        var output: [String] = []
        
        for folderMatch in result.folderMatches {
            let firstPath = folderMatch.first.path(relativeTo: sourceFolder)
            let secondPath = folderMatch.second.path(relativeTo: sourceFolder)
            
            switch folderMatch.comparisonResult {
            case .exactMatch:
                output.append("= \(firstPath, style: .bold) contains exactly the same files as \(secondPath, style: .bold)")
            case .firstIsSupersetOfSecond(let diff):
                var outputLine = "📂 > \(firstPath, style: .bold) contains all files from \(secondPath, style: .bold) and following files:\n"
                
                for file in diff {
                    outputLine += "     \(file.name)\n"
                }
                
                output.append(outputLine)
            case .firstIsSubsetOfSecond(let diff):
                var outputLine = "📂 < \(firstPath, style: .bold) is a subset of \(secondPath, style: .bold) and is missing following files:\n"
                
                for file in diff {
                    outputLine += "     \(file.name)\n"
                }
                
                output.append(outputLine)
            }
        }
        
        output.sorted().forEach { print($0) }

        let duplicatePaths = result.duplicateFiles.map { $0.map(\.path) }

        try write(duplicateResults: duplicatePaths, to: outputFile)
    }
}

Declutter.main()
