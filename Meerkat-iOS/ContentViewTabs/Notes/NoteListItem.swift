//
//  NoteListItem.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 03.04.26.
//

import SwiftUI
import MeerkatAPI
import EasyErrorHandling

struct NoteListItem: View {
    
    @EnvironmentObject var errorHandler: ErrorHandler
    @Environment(ConnectionHandler.self) var connectionHandler
    
    @State var note: Note
    @State private var associatedContact: Contact?
    
    var isPlaceholder: Bool = false
    
    @State private var showEditNoteSheet: Bool = false
    
    var refreshParent: () async throws -> Void
    
    init(note: Note, isPlaceholder: Bool) {
        self.note = note
        self.isPlaceholder = isPlaceholder
        self.refreshParent = { }
    }
    
    init(note: Note, refreshParent: @escaping () async throws -> Void) {
        self.note = note
        self.isPlaceholder = false
        self.refreshParent = refreshParent
    }
    
    var body: some View {
        Menu {
            if let contact = self.associatedContact {
                NavigationLink(value: contact) {
                    Label("View \(contact.firstname)",systemImage: "person")
                }
            }
            
            Divider()
            
            Button("Edit", systemImage: "pencil") {
                self.showEditNoteSheet = true
            }
            
            Button("Delete", systemImage: "trash", role: .destructive, action: self.deleteNote)
                .tint(.red)
            
        } label: {
            HStack {
                VStack(alignment: .leading) {
                    Text(note.content)
                        .multilineTextAlignment(.leading)
                    if let date = note.date {
                        Text(date, style: .date)
                            .foregroundStyle(.secondary)
                            .font(.caption)
                    }
                }
                Spacer()
            }
        }
        .contentShape(.rect)
        .foregroundStyle(.primary)
        .sheet(isPresented: self.$showEditNoteSheet) {
            Task {
                do {
                    try await self.reloadNote()
                } catch {
                    self.errorHandler.handle(error, while: "reloading note \(self.note.id)")
                }
            }
        } content: {
            EditNoteView(note: self.note)
            .presentationDetents([.medium, .large])
        }
        .throwingTask(taskDescription: "loading associated contact for note \(self.note.content)", self.loadAssociatedContact)
    }
    
    private func loadAssociatedContact() async throws {
        if self.isPlaceholder {
            return
        }
        if let contactId = self.note.contactId {
            let contact = try await self.connectionHandler.getContact(id: contactId)
            withAnimation {
                self.associatedContact = contact
            }
        }
    }
    
    private func reloadNote() async throws {
        let note = try await self.connectionHandler.getNote(self.note.id)
        withAnimation {
            self.note = note
        }
    }
    
    private func deleteNote() {
        Task {
            do {
                try await self.connectionHandler.deleteNote(self.note)
                try await self.refreshParent()
            } catch {
                self.errorHandler.handle(error, while: "deleting note \(self.note.id)")
            }
        }
    }
}

#Preview {
    List {
        NoteListItem(note: .mock) { }
            .frame(maxHeight: 50)
    }
    .withErrorHandling()
    .environment(ConnectionHandler.mock)
}
