//
//  ActivityList.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 30.03.26.
//


import SwiftUI
import EasyErrorHandling
import MeerkatAPI

struct ActivityList: View {
    
    @EnvironmentObject var errorHandler: ErrorHandler
    @Environment(ConnectionHandler.self) var connectionHandler
    
    @State private var page: Int = 1
    
    var placeholder: some View {
        Group {
            ActivityListItem(activity: .mock)
                .frame(maxHeight: 50)
            ActivityListItem(activity: .mock2)
                .frame(maxHeight: 50)
            ActivityListItem(activity: .mock3)
                .frame(maxHeight: 50)
        }
        .shimmerEffect()
        .redacted(reason: .placeholder)
        .throwingTask(id: self.page, taskDescription: "loading activities") {
            try await self.connectionHandler.getActivities(page: self.page)
            self.page += 1
        }
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if !self.connectionHandler.hasRemainingActivities && self.connectionHandler.activites.isEmpty {
                    ContentUnavailableView {
                        Label("You don't have any activities", systemImage: "calendar")
                    } actions: {
                        Button {
                            
                        } label: {
                            Label("Create an Activity", systemImage: "plus")
                        }
                        .glassProminentButtonStyleIfAvailable()
                    }
                } else {
                    List {
                        ForEach(self.connectionHandler.activites) { activity in
                            NavigationLink(value: activity) {
                                ActivityListItem(activity: activity)
                            }
                            .frame(maxHeight: 50)
                        }
                        
                        if self.connectionHandler.hasRemainingActivities {
                            self.placeholder
                        }
                    }
                    .throwingRefreshable(taskDescription: "reloading activities") {
                        try await self.connectionHandler.getActivities()
                        self.page = 1
                    }
                }
            }
            .navigationTitle("Activities")
            .navigationDestination(for: Activity.self) { activity in
                ActivityDetailView(activity: activity)
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Add Activity", systemImage: "plus") {
                        
                    }
                }
            }
        }
    }
}

#Preview {
    ActivityList()
        .withErrorHandling()
        .environment(ConnectionHandler.mock)
}
