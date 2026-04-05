//
//  Contact+mock.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 29.03.26.
//

import Foundation
import MeerkatAPI

extension Contact {
    nonisolated static let mock = Contact(
        id: 1,
        createdAt: Date(), // Current date/time
        updatedAt: Calendar.current.date(byAdding: .day, value: -7, to: Date()), // 7 days ago
        deletedAt: nil,  // Not deleted
        firstname: "Alice",
        lastname: "Smith",
        nickname: "Ali",
        gender: .female,
        email: "alice.smith@example.com",
        phone: "+15551234567",
        birthday: "1985-03-15",
        photo: "alice_profile.jpg",
        relationships: [],
        address: "123 Main St, Anytown",
        howWeMet: "Online Dating",
        foodPreference: "Italian",
        workInformation: "Software Engineer at TechCorp",
        contactInformation: "Preferred contact via email",
        circles: ["Friends", "Family"],
        customFields: ["favoriteColor": "blue", "interests": "reading, hiking"],
        archived: false,
        photoThumbnail: "alice_thumbnail.jpg"
    )
    
    nonisolated static let mock2 = Contact(
        id: 2,
        createdAt: Calendar.current.date(byAdding: .month, value: -3, to: Date()), // 3 months ago
        updatedAt: Calendar.current.date(byAdding: .day, value: -10, to: Date()), // 10 days ago
        deletedAt: Calendar.current.date(byAdding: .year, value: -1, to: Date()), // Deleted a year ago
        firstname: "Bob",
        lastname: nil,  // No last name provided
        nickname: nil, // No nickname
        gender: .male,
        email: "bob@example.com",
        phone: nil, // No phone number
        birthday: "1992-08-20",
        photo: nil, // No photo
        relationships: [],
        address: "456 Oak Ave, Somecity",
        howWeMet: nil, // How we met unknown
        foodPreference: "Mexican",
        workInformation: "Teacher",
        contactInformation: "Preferred contact via phone",
        circles: ["Coworkers"],
        customFields: nil, // No custom fields
        archived: true,
        photoThumbnail: "bob_thumbnail.jpg"
    )
    
    nonisolated static let mock3 = Contact(
        id: 3,
        createdAt: Date(),
        updatedAt: Calendar.current.date(byAdding: .hour, value: -1, to: Date()), // 1 hour ago
        deletedAt: nil,
        firstname: "Charlie",
        lastname: "Brown",
        nickname: "Chuck",
        gender: .other,
        email: "charlie.brown@example.com",
        phone: "+447700900123",
        birthday: nil, // Birthday unknown
        photo: "",
        relationships: [],
        address: nil, // No address
        howWeMet: "Mutual Friend",
        foodPreference: "Japanese",
        workInformation: nil, // No work information
        contactInformation: "Preferred contact via text",
        circles: ["Acquaintances"],
        customFields: ["petName": "Snoopy"],
        archived: false,
        photoThumbnail: nil // No thumbnail
    )
    
    nonisolated static let placeholder = Contact(
        id: 4,
        createdAt: Date(),
        updatedAt: Calendar.current.date(byAdding: .hour, value: -1, to: Date()), // 1 hour ago
        deletedAt: nil,
        firstname: "Charlie",
        lastname: "Brown",
        nickname: "Chuck",
        gender: .other,
        email: "charlie.brown@example.com",
        phone: "+447700900123",
        birthday: nil, // Birthday unknown
        photo: "",
        relationships: [],
        address: nil, // No address
        howWeMet: "Mutual Friend",
        foodPreference: "Japanese",
        workInformation: nil, // No work information
        contactInformation: "Preferred contact via text",
        circles: ["Acquaintances"],
        customFields: ["petName": "Snoopy"],
        archived: false,
        photoThumbnail: nil // No thumbnail
    )
}
