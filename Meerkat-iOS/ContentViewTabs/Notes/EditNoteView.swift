//
//  EditNoteView.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 16.04.26.
//

import SwiftUI
import MeerkatAPI
import EasyErrorHandling

struct EditNoteView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @Environment(ConnectionHandler.self) var connectionHandler
    @EnvironmentObject var errorHandler: ErrorHandler
    
    @State var note: Note
    let isNewNote: Bool
    
    @State private var isSaving: Bool = false
    
    init(contactId: Int? = nil) {
        self.note = .empty(contactId: contactId)
        self.isNewNote = true
    }
    
    init(note: Note) {
        self.note = note
        self.isNewNote = false
    }
    
    var bindableDate: Binding<Date> {
        Binding {
            self.note.date ?? .now
        } set: { newValue in
            self.note.date = newValue
        }
    }
    
    var body: some View {
        List {
            MultiLineTextField("Content", text: self.$note.content)
            
            DatePicker("Date:", selection: self.bindableDate, displayedComponents: [.date])
            
            Section {
                Button(action: self.save) {
                    if self.isSaving {
                        ProgressView()
                    } else {
                        Text("Save")
                    }
                }
                .disabled(self.note.content.isEmpty || self.isSaving)
                
                Button("Cancel", role: .destructive) {
                    self.dismiss()
                }
            }
        }
    }
    
    private func save() {
        withAnimation {
            self.isSaving = true
        }
        Task {
            do {
                if self.isNewNote {
                    if let contactId = note.contact?.id ?? note.contactId {
                        _ = try await self.connectionHandler.createContactNote(contactId: contactId, note: self.note)
                    } else {
                        _ = try await self.connectionHandler.createUnassignedNote(self.note)
                    }
                } else {
                    _ = try await self.connectionHandler.updateNote(self.note)
                }
                self.errorHandler.showInfo(self.isNewNote ? "Note created!" : "Note saved!")
                
                self.dismiss()
            } catch {
                self.errorHandler.handle(error, while: "saving note")
            }
            
            withAnimation {
                self.isSaving = false
            }
        }
    }
}

#Preview {
    EditNoteView(note: .mock)
        .environment(ConnectionHandler.mock)
        .withErrorHandling()
}
