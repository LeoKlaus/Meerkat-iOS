//
//  NoteList.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 30.03.26.
//

import SwiftUI
import EasyErrorHandling
import MeerkatAPI

struct NoteList: View {
    
    @EnvironmentObject var errorHandler: ErrorHandler
    @Environment(ConnectionHandler.self) var connectionHandler
    
    @State private var page: Int = 1
    
    @State private var showAddNoteSheet: Bool = false
    
    var placeholder: some View {
        Group {
            NoteListItem(note: .mock, isPlaceholder: true)
                .frame(maxHeight: 50)
            NoteListItem(note: .mock2, isPlaceholder: true)
                .frame(maxHeight: 50)
            NoteListItem(note: .mock3, isPlaceholder: true)
                .frame(maxHeight: 50)
        }
        .shimmerEffect()
        .redacted(reason: .placeholder)
        .throwingTask(id: self.page, taskDescription: "loading notes") {
            try await self.connectionHandler.getUnassignedNotes(limit: 50, page: self.page)
            self.page += 1
        }
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if !self.connectionHandler.hasRemainingNotes && self.connectionHandler.notes.isEmpty {
                    ContentUnavailableView {
                        Label("You don't have any notes", systemImage: "list.clipboard")
                    } actions: {
                        Button {
                            self.showAddNoteSheet = true
                        } label: {
                            Label("Create a Note", systemImage: "plus")
                        }
                        .glassProminentButtonStyleIfAvailable()
                    }
                } else {
                    List {
                        ForEach(self.connectionHandler.notes) { note in
                            NoteListItem(note: note) {
                                self.page = 1
                                try await self.connectionHandler.getUnassignedNotes()
                            }
                        }
                        
                        if self.connectionHandler.hasRemainingNotes {
                            self.placeholder
                        }
                    }
                    .throwingRefreshable(taskDescription: "reloading notes") {
                        self.page = 1
                        try await self.connectionHandler.getUnassignedNotes()
                    }
                }
            }
            .navigationTitle("Notes")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Add Note", systemImage: "plus") {
                        self.showAddNoteSheet = true
                    }
                }
            }
            .sheet(isPresented: self.$showAddNoteSheet) {
                Task {
                    do {
                        try await self.connectionHandler.getUnassignedNotes()
                        self.page = 1
                    } catch {
                        self.errorHandler.handle(error, while: "reloading notes")
                    }
                }
            } content: {
                EditNoteView()
            }
        }
    }
}

#Preview {
    NoteList()
        .withErrorHandling()
        .environment(ConnectionHandler.mock)
}
