//
//  EditContactCircleSection.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 12.04.26.
//

import SwiftUI
import MeerkatAPI
import EasyErrorHandling
import Flow

struct EditContactCircleSection: View {
    
    @Environment(ConnectionHandler.self) var connectionHandler
    @EnvironmentObject var errorHandler: ErrorHandler
    
    @Binding var contact: Contact
    
    @State private var showAddCircleAlert: Bool = false
    @State private var newCircleName: String = ""
    
    var body: some View {
        Section("Circles") {
            Menu {
                ForEach(self.connectionHandler.circles, id: \.self) { circle in
                    if self.contact.circles?.contains(circle) ?? false {
                        Button(circle, systemImage: "checkmark") {
                            withAnimation {
                                self.contact.circles?.removeAll(where: {
                                    $0 == circle
                                })
                            }
                        }
                    } else {
                        Button(circle) {
                            if self.contact.circles == nil {
                                self.contact.circles = []
                            }
                            withAnimation {
                                self.contact.circles?.append(circle)
                            }
                        }
                    }
                }
                Divider()
                Button("Create Circle", systemImage: "plus") {
                    self.showAddCircleAlert = true
                }
            } label: {
                HFlow {
                    ForEach(self.contact.circles ?? [], id: \.self) { circle in
                        CircleItem(circle: circle)
                    }
                    if self.contact.circles?.isEmpty ?? true {
                        Text("No Circles")
                            .foregroundStyle(.secondary)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .foregroundStyle(.primary)
        }
        .throwingTask(taskDescription: "loading circles", self.connectionHandler.getCircles)
        .alert("Create a Circle", isPresented: self.$showAddCircleAlert) {
            TextField("Circle Name", text: self.$newCircleName)
                .onSubmit {
                    if !self.newCircleName.isEmpty {
                        self.addCircle()
                    }
                }
            Button("Cancel", role: .cancel) {
                self.showAddCircleAlert = false
                self.newCircleName = ""
            }
            Button("OK", action: self.addCircle)
                .disabled(self.newCircleName.isEmpty)
        }
    }
    
    func addCircle() {
        if self.contact.circles == nil {
            self.contact.circles = []
        }
        withAnimation {
            self.contact.circles?.append(self.newCircleName)
            self.showAddCircleAlert = false
            self.newCircleName = ""
        }
    }
}

#Preview {
    @Previewable @State var contact: Contact = .mock
    List {
        EditContactCircleSection(contact: $contact)
    }
    .environment(ConnectionHandler.mock)
    .withErrorHandling()
}
