import Foundation
import ArgumentParser
import Files
import DeclutterLib
import Chalk

struct Declutter: ParsableCommand {

    private let version = "0.1.0"
    
    @Argument(default: ".", help: "Folder to declutter")
    var path: String

    @Option(help: "Folders to ignore")
    var ignore: [String]
    
    @Flag(name: .customLong("version"), help: .hidden)
    var printVersion: Bool
    
    func run() throws {
        if printVersion {
            print(version)
            return
        }
        
        let sourceFolder = try Folder(path: path)
        let foldersToIgnore = try ignore.map { try Folder(path: $0) }
        
        let result = try findDuplicateFiles(in: sourceFolder, ignoring: foldersToIgnore)
        
        print(result)
    }
}

Declutter.main()
