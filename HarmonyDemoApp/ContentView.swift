//
//  ContentView.swift
//  HarmonyDemoApp
//
//  Created by Aaron Pearce on 14/02/24.
//

import GRDBQuery
import Harmony
import SwiftUI

struct ContentView: View {
    @Query<AllListItemsRequest> var items: [ListItem]

    @State var showTextEntryField = false
    @Harmony var harmony

    @State var newEntryText: String = ""
    @FocusState var isTextFieldFocused: Bool

    init() {
        _items = Query(AllListItemsRequest())
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(items) { item in
                    HStack {
                        Button {
                            Task {
                                try await toggleCompleted(for: item)
                            }
                        } label: {
                            item.isCompleted ? Image(systemName: "checkmark.circle.fill") : Image(systemName: "circle")
                        }
                        .animation(.easeInOut(duration: 0.1), value: item.isCompleted)

                        Text(item.text)
                            .foregroundStyle(item.isCompleted ? .secondary : .primary)
                    }
                }
                .onDelete(perform: delete)
                
                if showTextEntryField {
                    HStack {
                        Image(systemName: "circle")
                            .foregroundStyle(.secondary)

                        TextField("", text: $newEntryText)
                            .labelsHidden()
                            .focused($isTextFieldFocused)
                            .onSubmit {
                                Task {
                                    try await createItem()
                                }
                            }
                    }
                }
            }
            .fontDesign(.serif)
            .listStyle(.insetGrouped)
            .navigationTitle("List")
            .overlay {
                if items.isEmpty && !showTextEntryField {
                    ContentUnavailableView {
                        Label("No items", systemImage: "square.grid.3x3.fill")
                    } description: {
                        Text("Try adding some.")
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        setTextField(visible: true)
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }

    private func createItem() async throws {
        guard !newEntryText.isEmpty else {
            return
        }

        let item = ListItem(
            text: newEntryText,
            isCompleted: false
        )

        try await harmony.create(record: item)
        newEntryText = ""
        setTextField(visible: false)
    }

    public func toggleCompleted(for item: ListItem) async throws {
        var localItem = item
        withAnimation {
            localItem.isCompleted.toggle()
        }
        try await harmony.save(record: localItem)
    }

    private func delete(at offsets: IndexSet) {
        // delete the objects here
        let itemsToDelete = offsets.map { self.items[$0] }
        Task {
            try await harmony.delete(records: itemsToDelete)
        }
    }

    private func setTextField(visible: Bool) {
        self.isTextFieldFocused = visible
        self.showTextEntryField = visible
    }
}

#Preview {
    ContentView()
}
