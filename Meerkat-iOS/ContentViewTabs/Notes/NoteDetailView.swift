//
//  NoteDetailView.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 03.04.26.
//

import SwiftUI
import MeerkatAPI
import EasyErrorHandling

struct NoteDetailView: View {
    
    let note: Note
    
    var body: some View {
        List {
            Text(note.content)
        }
    }
}

#Preview {
    NavigationStack {
        NoteDetailView(note: .mock)
    }
    .withErrorHandling()
    .environment(ConnectionHandler.mock)
}
