import Foundation
import DeclutterLib
import Files

func print(_ result: DeclutterCalculationResult) {
    print("==== 📄 File Results for \(result.sourceFolder.path) ====")
    
    if result.duplicateFiles.count > 0 {
        let setsString = result.duplicateFiles.count == 1 ? "1 set" : "\(result.duplicateFiles.count) sets"
        print("Found \(setsString) of identical files:")
        
        for duplicates in result.duplicateFiles {
            for path in duplicates.map({ $0.path(relativeTo: result.sourceFolder) }).sorted() {
                print("    \(path)")
            }
            print()
        }
    } else {
        print("Did not find any duplicate files in \(result.sourceFolder)")
    }
    
    print("==== 📂 Folder Results for \(result.sourceFolder.path) ====")
    
    var output: [String] = []
    
    if result.folderMatches.count > 0 {
        for folderMatch in result.folderMatches {
            let firstPath = folderMatch.first.path(relativeTo: result.sourceFolder)
            let secondPath = folderMatch.second.path(relativeTo: result.sourceFolder)
            
            switch folderMatch.comparisonResult {
            case .exactMatch:
                output.append("= \(firstPath, style: .bold) contains exactly the same files as \(secondPath, style: .bold)")
            case .firstIsSubsetOfSecond(let diff):
                var outputLine = "< \(firstPath, style: .bold) is a subset of \(secondPath, style: .bold) and is missing following files:\n"
                
                for file in diff {
                    outputLine += "     \(file.name)\n"
                }
                
                output.append(outputLine)
            }
        }
        
        output.sorted().forEach { print($0) }
    } else {
        print("Did not find any duplicate folders in \(result.sourceFolder.path)")
    }
}
