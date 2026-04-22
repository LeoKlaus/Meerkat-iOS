//
//  ReleaseNotes.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 22.09.25.
//

import SwiftUI

extension PatchNote {
    static let latestPatchNote = Self.patchNotes.first?.version ?? "0.1.0"
    
    static let patchNotes: [PatchNote] = [
        PatchNote(
            version: "0.1.0",
            categories: [
                PatchNoteCategory(
                    name: "Beta Release",
                    changes: [
                        "During the pre-release TestFlight beta, not all changes will be documented here. TestFlight will inform you on any changes whenever you open the app after an update."
                    ]
                )
            ]
        )
    ]
}
