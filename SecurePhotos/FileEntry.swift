import Foundation
import SwiftData
import UniformTypeIdentifiers

@Model
final class FileEntry {
    var timeCreated: Date
    var timeModified: Date
    var fileTypeString: String
    var url: URL
    
    var fileType: UTType? {
        UTType(fileTypeString)
    }
    
    init(timeCreated: Date, fileType: UTType, url: URL) {
        self.timeCreated = timeCreated
        self.timeModified = timeCreated
        self.fileTypeString = fileType.identifier
        self.url = url
    }
}
