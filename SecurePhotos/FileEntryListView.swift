import Foundation
import UniformTypeIdentifiers
import SwiftUI

struct FileEntryListView: View {
    @Environment(\.modelContext) private var modelContext
    var entries: [FileEntry]
    
    var body: some View {
        NavigationSplitView {
            List {
                ForEach(entries) { entry in
                    NavigationLink {
                        FileEntryView(url: entry.url)
                    } label: {
                        Text(entry.url.lastPathComponent)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select an item")
        }
    }
    
    private func addItem() {
        withAnimation {
            let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let url = documents.appendingPathComponent(
                UUID().uuidString.prefix(23) + ".txt")
            
            do {
                try "Hello World".data(using: .utf8)?.write(to: url)
                print("File created")
            } catch {
                print("Error")
            }

            let entry = FileEntry(timeCreated: Date(), fileType: UTType.text, url: url)
            
            modelContext.insert(entry)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                do {
                    try FileManager.default.removeItem(at: entries[index].url)
                    print("File deleted")
                } catch {
                    print("Error")
                }
            
                modelContext.delete(entries[index])
            }
        }
    }
}
