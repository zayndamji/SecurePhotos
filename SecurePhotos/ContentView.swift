import SwiftUI
import SwiftData
import UniformTypeIdentifiers

struct ContentView: View {
    @Query private var entries: [FileEntry]

    var body: some View {
        FileEntryListView(entries: entries)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: FileEntry.self, inMemory: true)
}
