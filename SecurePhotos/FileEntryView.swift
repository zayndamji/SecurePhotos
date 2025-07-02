import Foundation
import SwiftUI

struct FileEntryView: View {
    let url: URL
    @State private var content: String = "Data is loading..."

    var body: some View {
        ScrollView {
            Text(content)
                .padding()
        }
        .navigationTitle(url.lastPathComponent)
        .onAppear {
            loadFile()
        }
    }

    private func loadFile() {
        do {
            let data = try Data(contentsOf: url)
            content = String(data: data, encoding: .utf8) ?? "Text could not be decoded."
        } catch {
            content = "File could not be read."
        }
    }
}
