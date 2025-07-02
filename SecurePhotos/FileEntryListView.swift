import Foundation
import UniformTypeIdentifiers
import SwiftUI
import PhotosUI

struct FileEntryListView: View {
    @Environment(\.modelContext) private var modelContext
    var entries: [FileEntry]
    
    @State private var selectedItem: PhotosPickerItem? = nil
    
    var body: some View {
        NavigationSplitView {
            List {
                ForEach(entries) { entry in
                    NavigationLink {
                        FileEntryView(entry: entry)
                    } label: {
                        Text(entry.relativeFilePath)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    PhotosPicker(
                        selection: $selectedItem,
                        matching: .images,
                        photoLibrary: .shared()
                    ) {
                        Label("Add Image", systemImage: "photo.on.rectangle")
                    }
                }
                ToolbarItem {
                    Button(action: addTextFile) {
                        Label("Add Text File", systemImage: "plus")
                    }
                }
            }
            .onChange(of: selectedItem) { newItem in
                if let item = newItem {
                    addImage(from: item)
                }
            }
        } detail: {
            Text("Select an item")
        }
    }
    
    private func addImage(from item: PhotosPickerItem) {
        item.loadTransferable(type: Data.self) { result in
            switch result {
            case .success(let data?):
                let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let filename = String(UUID().uuidString.prefix(23)) + ".jpg"
                let url = documents.appendingPathComponent(filename)
                
                do {
                    try data.write(to: url)
                    print("Image file saved")
                    
                    let entry = FileEntry(timeCreated: Date(), fileType: UTType.jpeg, relativeFilePath: filename)
                    
                    DispatchQueue.main.async {
                        withAnimation {
                            modelContext.insert(entry)
                            selectedItem = nil
                        }
                    }
                } catch {
                    print("Error saving image file")
                }
            case .success(nil):
                print("No data found")
            case .failure(let error):
                print("Error with image data")
            }
        }
    }
    
    private func addTextFile() {
        withAnimation {
            let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileName = String(UUID().uuidString.prefix(23) + ".txt")
            
            do {
                try "Hello World".data(using: .utf8)?.write(to: documents.appendingPathComponent(fileName))
                print("File created")
            } catch {
                print("Error \(error)")
            }

            let entry = FileEntry(timeCreated: Date(), fileType: UTType.text, relativeFilePath: fileName)
            
            DispatchQueue.main.async {
                withAnimation {
                    modelContext.insert(entry)
                    selectedItem = nil
                }
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                do {
                    try FileManager.default.removeItem(at: entries[index].url!)
                    print("File deleted")
                } catch {
                    print("Error \(error)")
                }
            
                modelContext.delete(entries[index])
            }
        }
    }
}
