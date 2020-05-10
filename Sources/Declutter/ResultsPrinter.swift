import Foundation
import DeclutterLib
import Files

func print(_ result: DeclutterCalculationResult) {
    if result.duplicateFiles.count > 0 {
        let totalDuplicateFiles = result.duplicateFiles.reduce(0) { $0 + ($1.count - 1) }
        
        print("Found \(totalDuplicateFiles) files that are duplicates and can be deleted")
    } else {
        print("Did not find any duplicates in \(result.sourceFolder)")
    }
    
    var output: [String] = []
    
    for folderMatch in result.folderMatches {
        let firstPath = folderMatch.first.path(relativeTo: result.sourceFolder)
        let secondPath = folderMatch.second.path(relativeTo: result.sourceFolder)
        
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
}
