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
    
    var placeholder: some View {
        Group {
            NoteListItem(note: .mock)
                .frame(maxHeight: 50)
            NoteListItem(note: .mock2)
                .frame(maxHeight: 50)
            NoteListItem(note: .mock3)
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
                            
                        } label: {
                            Label("Create a Note", systemImage: "plus")
                        }
                        .glassProminentButtonStyleIfAvailable()
                    }
                } else {
                    List {
                        ForEach(self.connectionHandler.notes) { note in
                            NavigationLink(value: note) {
                                NoteListItem(note: note)
                            }
                            .frame(maxHeight: 50)
                        }
                        
                        if self.connectionHandler.hasRemainingNotes {
                            self.placeholder
                        }
                    }
                    .throwingRefreshable(taskDescription: "reloading notes") {
                        try await self.connectionHandler.getUnassignedNotes()
                        self.page = 1
                    }
                }
            }
            .navigationTitle("Notes")
            .navigationDestination(for: Note.self) { note in
                NoteDetailView(note: note)
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Add Note", systemImage: "plus") {
                        
                    }
                }
            }
        }
    }
}

#Preview {
    NoteList()
        .withErrorHandling()
        .environment(ConnectionHandler.mock)
}
