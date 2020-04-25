import Foundation
import ArgumentParser
import Files

struct Declutter: ParsableCommand {
    
    @Argument(help: "Specify directory to declutter")
    var path: String
    
    @Flag(name: .shortAndLong, default: false, inversion: .prefixedNo)
    var dryRun: Bool
    
    func run() throws {
        let sourceFolder = try Folder(path: path)
        let subfolders = sourceFolder.makeSubfolderSequence(recursive: true, includeHidden: false)
        
        subfolders.forEach { folder in
            let parent = folder.parent?.name ?? ""
            print("Name: \(folder.path(relativeTo: sourceFolder)), parent: \(parent)")
        }
    }
}

Declutter.main()
