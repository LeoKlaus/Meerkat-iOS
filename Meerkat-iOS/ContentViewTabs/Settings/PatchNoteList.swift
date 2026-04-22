//
//  PatchNoteList.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 22.04.26.
//


import SwiftUI

struct PatchNoteList: View {

    @AppStorage(.userDefaults(.lastSeenPatchNote), store: .meerkat)
    
    var lastSeenPatchNote: String = ""
    
    @AppStorage(.userDefaults(.showPatchNotes), store: .meerkat)
    
    var showPatchNotes: Bool = true
    
    var body: some View {
        List {
            Section {
                Toggle("Show notes for new versions", isOn: self.$showPatchNotes)
                    .toggleStyle(.switch)
            } footer: {
                Text("Show this for every new version of \(Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String ?? "Meerkat-iOS"). You can always view release notes in the about section in settings.")
            }
            
            ForEach(PatchNote.patchNotes) { note in
                Section(note.version) {
                    ForEach(note.categories) { category in
                        VStack(alignment: .leading) {
                            Text(category.name)
                                .font(.headline)
                            ForEach(category.changes) { change in
                                HStack(alignment: .firstTextBaseline) {
                                    Text("•")
                                    Text(change.content)
                                }.padding(.top, 1)
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            self.lastSeenPatchNote = PatchNote.latestPatchNote
        }
    }
}

#Preview {
    PatchNoteList()
}
