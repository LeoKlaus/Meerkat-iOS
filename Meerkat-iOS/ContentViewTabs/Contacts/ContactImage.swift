//
//  ContactImage.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 29.03.26.
//

import SwiftUI
import MeerkatAPI
import EasyErrorHandling

struct ContactImage: View {
    
    @Environment(ConnectionHandler.self) var connectionHandler
    @EnvironmentObject var errorHandler: ErrorHandler
    
    let contact: Contact
    
    @State private var imageData: Data?
    
    var body: some View {
        if let imageData, let image = Image(data: imageData) {
                image
                .resizable()
                .scaledToFit()
        } else {
            ZStack {
                Circle()
                    .fill(.tint)
                Text(self.contact.firstname.prefix(1))
                    .foregroundStyle(.white)
                    .font(.system(size: 100))
                    .minimumScaleFactor(0.1)
                    .scaledToFit()
                    .padding()
            }
            .throwingTask(taskDescription: "loading contact image for \(contact.fullName)", self.getContactImage)
        }
    }
    
    private func getContactImage() async throws {
        if let photo = self.contact.photo, !photo.isEmpty {
            self.imageData = try await self.connectionHandler.getContactImage(self.contact)
        } else if let photoThumbnail = contact.photoThumbnail, !photoThumbnail.isEmpty {
            // TODO: Check why this doesn't work
            // self.imageData = Data(base64Encoded: photoThumbnail, options: .ignoreUnknownCharacters)
            self.imageData = try await self.connectionHandler.getContactImage(self.contact)
        }
    }
}

#Preview {
    ContactImage(contact: .mock)
        .frame(width: 50)
        .withErrorHandling()
        .environment(ConnectionHandler.mock)
}
