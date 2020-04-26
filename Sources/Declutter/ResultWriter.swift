import Foundation
import Files

struct CouldNotEncodeJSONError: Error {
    var localizedDescription: String {
        "Could not encode the results into JSON"
    }
}

func write(duplicateResults duplicates: [[String]], to outputFile: File) throws {
    let jsonEncoder = JSONEncoder()
    jsonEncoder.outputFormatting = .prettyPrinted
    let jsonData = try jsonEncoder.encode(["duplicates": duplicates])
    
    if let jsonString = String(data: jsonData, encoding: .utf8)?.replacingOccurrences(of: "\\/", with: "/") {
        try outputFile.write(string: jsonString)
    } else {
        throw CouldNotEncodeJSONError()
    }
}
