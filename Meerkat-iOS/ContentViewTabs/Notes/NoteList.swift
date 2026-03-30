//
//  NoteList.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 30.03.26.
//

import SwiftUI
import EasyErrorHandling

struct NoteList: View {
    var body: some View {
        ContentUnavailableView("Not implemented yet", systemImage: "list.clipboard")
    }
}

#Preview {
    NoteList()
        .withErrorHandling()
        .environment(ConnectionHandler.mock)
}
