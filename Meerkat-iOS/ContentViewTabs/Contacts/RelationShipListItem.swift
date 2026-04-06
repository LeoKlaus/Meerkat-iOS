//
//  RelationShipListItem.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 05.04.26.
//

import SwiftUI
import MeerkatAPI
import EasyErrorHandling

struct RelationShipListItem: View {
    
    @Environment(ConnectionHandler.self) var connectionHandler
    @EnvironmentObject var errorHandler: ErrorHandler
    
    let relationShip: Relationship
    let isIncoming: Bool
    
    @State var relatedContact: Contact?
    
    init(relationShip: Relationship, isIncoming: Bool = false) {
        self.relationShip = relationShip
        self.isIncoming = isIncoming
        
        self.relatedContact = self.isIncoming ? relationShip.sourceContact:  relationShip.relatedContact
    }
    
    var body: some View {
        if let relatedContact {
            NavigationLink(value: relatedContact) {
                VStack(alignment: .leading) {
                    Text(relatedContact.fullName)
                        .bold()
                    Text(relationShip.type)
                }
            }
        } else {
            VStack(alignment: .leading) {
                Text(relationShip.name)
                    .bold()
                Text(relationShip.type)
            }
            .throwingTask(taskDescription: "loading related contact for relationship \(relationShip.name)", self.loadContact)
        }
    }
    
    func loadContact() async throws {
        if self.relatedContact == nil, let contactId = self.isIncoming ? self.relationShip.contactId : self.relationShip.relatedContactId{
            self.relatedContact = try await self.connectionHandler.apiHandler.getContact(id: contactId)
        }
    }
}

#Preview {
    List {
        RelationShipListItem(relationShip: .mock)
    }
    .withErrorHandling()
    .environment(ConnectionHandler.mock)
}
