import Foundation
import SwiftData
import UniformTypeIdentifiers

@Model
final class FileEntry {
    var timeCreated: Date
    var timeModified: Date
    var fileTypeString: String
    var relativeFilePath: String
    
    var fileType: UTType? {
        UTType(fileTypeString)
    }
    
    var url: URL? {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let url = documents.appendingPathComponent(relativeFilePath)
        return url
    }
    
    init(timeCreated: Date, fileType: UTType, relativeFilePath: String) {
        self.timeCreated = timeCreated
        self.timeModified = timeCreated
        self.fileTypeString = fileType.identifier
        self.relativeFilePath = relativeFilePath
    }
}
