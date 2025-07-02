import Foundation
import SwiftUI
import UniformTypeIdentifiers

struct FileEntryView: View {
    let entry: FileEntry
    @State private var content: String = "Data is loading..."
    @State private var image: Image? = nil

    var body: some View {
        ScrollView {
            if let image = image {
                image
                    .resizable()
                    .scaledToFit()
                    .padding()
            } else {
                Text(content)
                    .padding()
            }
        }
        .navigationTitle(entry.url!.lastPathComponent)
        .onAppear {
            loadFile()
        }
    }

    private func loadFile() {
        do {
            let data = try Data(contentsOf: entry.url!)
            let type = entry.fileType

            if type?.conforms(to: .image) == true {
                if let uiImage = UIImage(data: data) {
                    image = Image(uiImage: uiImage)
                } else {
                    content = "Image could not be decoded."
                }
            } else if type?.conforms(to: .text) == true {
                content = String(data: data, encoding: .utf8) ?? "Text could not be decoded."
            } else {
                content = "Unsupported file type."
            }
        } catch {
            content = "File could not be read."
        }
    }
}
