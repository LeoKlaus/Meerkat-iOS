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
    
    let note: Note
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(note.content)
                if let date = note.date {
                    Text(date, style: .date)
                        .foregroundStyle(.secondary)
                        .font(.caption)
                }
            }
        }
    }
}

#Preview {
    List {
        NoteListItem(note: .mock)
            .frame(maxHeight: 50)
    }
    .withErrorHandling()
    .environment(ConnectionHandler.mock)
}
