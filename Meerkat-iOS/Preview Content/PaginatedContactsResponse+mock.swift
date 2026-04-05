//
//  PaginatedResponse+mock.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 29.03.26.
//

import Foundation
import MeerkatAPI

extension PaginatedResponse {
    nonisolated static func getActivitiesMock() -> PaginatedResponse<Activity> {
        return PaginatedResponse<Activity>(
            results: [
                .mock,
                .mock2,
                .mock3
            ],
            limit: 10,
            page: 1,
            total: 3,
            totalPages: 1
        )
    }
    
    nonisolated static func getBirthdaysMock() -> PaginatedResponse<Birthday> {
        return PaginatedResponse<Birthday>(
            results: [
                .mock,
                .mock2,
                .mock3
            ],
            limit: 10,
            page: 1,
            total: 3,
            totalPages: 1
        )
    }
    
    nonisolated static func getContactsMock() -> PaginatedResponse<Contact> {
        return PaginatedResponse<Contact>(
            results: [
                .mock,
                .mock2,
                .mock3
            ],
            limit: 10,
            page: 1,
            total: 3,
            totalPages: 1
        )
    }
    
    nonisolated static func getNotesMock() -> PaginatedResponse<Note> {
        return PaginatedResponse<Note>(
            results: [
                .mock,
                .mock2,
                .mock3
            ],
            limit: 10,
            page: 1,
            total: 3,
            totalPages: 1
        )
    }
    
    nonisolated static func getRelationshipsMock() -> PaginatedResponse<Relationship> {
        return PaginatedResponse<Relationship>(
            results: [
                .mock,
                .mock2,
                .mock3
            ],
            limit: 10,
            page: 1,
            total: 3,
            totalPages: 1
        )
    }
    
    nonisolated static func getUsersMock() -> PaginatedResponse<User> {
        return PaginatedResponse<User>(
            results: [
                .mock,
                .mock2,
                .mock3
            ],
            limit: 10,
            page: 1,
            total: 3,
            totalPages: 1
        )
    }
    
    nonisolated static func getRemindersMock() -> PaginatedResponse<Reminder> {
        return PaginatedResponse<Reminder>(
            results: [
                .mock,
                .mock2,
                .mock3
            ],
            limit: 10,
            page: 1,
            total: 3,
            totalPages: 1
        )
    }
}
