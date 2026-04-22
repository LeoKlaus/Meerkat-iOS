//
//  PatchNote.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 22.04.26.
//


import SwiftUI

struct PatchNote: Identifiable {
    let id = UUID()
    let version: String
    let categories: [PatchNoteCategory]
}

struct PatchNoteCategory: Identifiable {
    let id = UUID()
    let name: LocalizedStringKey
    let changes: [PatchNoteChange]
    
    struct PatchNoteChange: Identifiable {
        let id = UUID()
        let content: LocalizedStringKey
    }
    
    init(name: LocalizedStringKey, changes: [LocalizedStringKey]) {
        self.name = name
        self.changes = changes.map { change in
            PatchNoteChange(content: change)
        }
    }
}
