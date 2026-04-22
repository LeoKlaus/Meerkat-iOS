//
//  ConnectionHandler+mock.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 07.04.26.
//

import Foundation
import MeerkatAPI
import UIKit

@Observable
class MockConnectionHandler: ConnectionHandler {
    convenience init() {
        self.init(
            apiHandler: ApiHandler(
                serverURL: URL(string: "https://example.com")!,
                token: "abc123"
            ),
            instance: ConnectedInstance(
                serverURL: URL(string: "https://example.com")!,
                username: "demo"
            )
        )
    }
    
    private func delayResponse() async throws {
        try await Task.sleep(for: .milliseconds(Int.random(in: 200...1000)))
    }
    
    override func register(username: String, password: String, mailAddress: String, language: InterfaceLanguage) async throws {
        throw ApiError.forbidden
    }
    
    override func login(username: String, password: String) async throws -> LoginResponse {
        throw ApiError.forbidden
    }
    
    override func logout() async throws {
        throw ApiError.forbidden
    }
    
    override func checkPasswordStrength(_ password: String) async throws -> PasswordStrengthResponse {
        throw ApiError.forbidden
    }
    
    override func requestPasswordReset(mailAddress: String) async throws {
        throw ApiError.forbidden
    }
    
    override func confirmPasswordReset(token: String, newPassword: String) async throws {
        throw ApiError.forbidden
    }
    
    override func getMe() async throws -> User {
        try await Task.sleep(for: .milliseconds(Int.random(in: 200...1000)))
        return User.mock
    }
    
    override func changePassword(currentPassword: String, newPassword: String) async throws {
        throw ApiError.forbidden
    }
    
    override func changeLanguage(_ newLanguage: InterfaceLanguage) async throws {
        throw ApiError.forbidden
    }
    
    override func changeDateFormat(_ newFormat: DateFormat) async throws {
        throw ApiError.forbidden
    }
    
    override func getCustomFields() async throws {
        try await self.delayResponse()
        self.customFields = [
            "Favorite Color",
            "Interests",
            "Discord-ID",
            "Signal-ID",
            "WhatsApp-ID"
        ]
    }
    
    override func updateCustomFields(_ newFields: CustomFields) async throws {
        try await self.delayResponse()
        self.customFields = newFields.customFieldNames
    }
    
    override func getContacts(limit: Int = 50, page: Int = 1, searchText: String? = nil, sortBy: Contact.CodingKeys = .id, sortOrder: SortOrder, includeArchived: Bool = false, circleFilter: String? = nil) async throws {
        if page == 1 {
            self.hasRemainingContacts = true
            self.contacts = []
        }
        
        try await self.delayResponse()
        
        self.contacts = [
            .mock,
            .mock2,
            .mock3
        ]
        self.hasRemainingContacts = false
    }
    
    override func createContact(_ newContact: Contact) async throws -> Contact {
        try await self.delayResponse()
        return newContact
    }
    
    override func getContact(id: Int) async throws -> Contact {
        try await self.delayResponse()
        
        switch id {
        case 1: return .mock
        case 2: return .mock2
        case 3: return .mock3
        default: throw ApiError.notFound
        }
    }
    
    override func updateContact(_ contact: Contact) async throws -> Contact {
        try await self.delayResponse()
        return contact
    }
    
    override func deleteContact(_ contact: Contact) async throws {
        try await self.delayResponse()
    }
    
    override func archiveContact(_ contact: Contact) async throws -> Contact {
        try await self.delayResponse()
        return Contact(
            id: contact.id,
            createdAt: contact.createdAt,
            updatedAt: contact.updatedAt,
            deletedAt: contact.deletedAt,
            firstname: contact.firstname,
            lastname: contact.lastname,
            nickname: contact.nickname,
            gender: contact.gender,
            email: contact.email,
            phone: contact.phone,
            birthday: contact.birthday,
            photo: contact.photo,
            relationships: contact.relationships,
            address: contact.address,
            howWeMet: contact.howWeMet,
            foodPreference: contact.foodPreference,
            workInformation: contact.workInformation,
            contactInformation: contact.contactInformation,
            circles: contact.circles,
            customFields: contact.customFields,
            archived: true,
            photoThumbnail: contact.photoThumbnail
        )
    }
    
    override func unarchiveContact(_ contact: Contact) async throws -> Contact {
        try await self.delayResponse()
        return Contact(
            id: contact.id,
            createdAt: contact.createdAt,
            updatedAt: contact.updatedAt,
            deletedAt: contact.deletedAt,
            firstname: contact.firstname,
            lastname: contact.lastname,
            nickname: contact.nickname,
            gender: contact.gender,
            email: contact.email,
            phone: contact.phone,
            birthday: contact.birthday,
            photo: contact.photo,
            relationships: contact.relationships,
            address: contact.address,
            howWeMet: contact.howWeMet,
            foodPreference: contact.foodPreference,
            workInformation: contact.workInformation,
            contactInformation: contact.contactInformation,
            circles: contact.circles,
            customFields: contact.customFields,
            archived: false,
            photoThumbnail: contact.photoThumbnail
        )
    }
    
    override func getCircles() async throws {
        try await self.delayResponse()
        self.circles = [
            "Friends",
            "Family",
            "Coworkers",
            "Acquaintances"
        ]
    }
    
    override func getRandomContacts() async throws -> [Contact] {
        try await self.delayResponse()
        
        return [
            .mock,
            .mock2,
            .mock3
        ].shuffled()
    }
    
    override func getUpcomingBirthdays() async throws -> [Birthday] {
        try await self.delayResponse()
        return [
            .mock,
            .mock2,
            .mock3
        ]
    }
    
    override func getContactImage(_ contact: Contact) async throws -> Data {
        try await self.delayResponse()
        return UIImage(resource: .mockUser).jpegData(compressionQuality: 80)!
    }
    
    override func uploadContactImage(contact: Contact, imageURL: URL) async throws -> Contact {
        throw ApiError.forbidden
    }
    
    
    override func getOutgoingRelationships(_ contact: Contact) async throws -> [Relationship] {
        try await self.delayResponse()
        return [
            .mock,
            .mock2
        ]
    }
    
    override func createRelationship(contact: Contact, relationShip: Relationship) async throws -> Relationship {
        try await self.delayResponse()
        return relationShip
    }
    
    override func getIncomingRelationships(_ contact: Contact) async throws -> [Relationship] {
        try await self.delayResponse()
        return [
            .mock3
        ]
    }
    
    override func updateRelationship(contact: Contact, relationship: Relationship) async throws -> Relationship {
        try await self.delayResponse()
        return relationship
    }
    
    override func deleteRelationship(contact: Contact, relationship: Relationship) async throws {
        try await self.delayResponse()
    }
    
    
    override func getContactNotes(_ contact: Contact) async throws -> [Note] {
        try await self.delayResponse()
        return [
            .mock,
            .mock2,
            .mock3
        ]
    }
    
    override func createContactNote(contactId: Int, note: Note) async throws -> Note {
        try await self.delayResponse()
        return note
    }
    
    override func getUnassignedNotes(limit: Int = 50, page: Int = 1) async throws {
        try await self.delayResponse()
        
        if page == 1 {
            self.hasRemainingNotes = true
            self.notes = []
        }
        
        self.notes = [
            .mock,
            .mock2,
            .mock3
        ]
        
        self.hasRemainingNotes = false
    }
    
    override func createUnassignedNote(_ note: Note) async throws -> Note {
        try await self.delayResponse()
        return note
    }
    
    
    override func getNote(_ id: Int) async throws -> Note {
        try await self.delayResponse()
        switch id {
        case 1: return .mock
        case 2: return .mock2
        case 3: return .mock3
        default: throw ApiError.notFound
        }
    }
    
    override func updateNote(_ note: Note) async throws -> Note {
        try await self.delayResponse()
        return note
    }
    
    override func deleteNote(_ note: Note) async throws {
        try await self.delayResponse()
    }
    
    
    override func getActivities(limit: Int = 50, page: Int = 1) async throws {
        try await self.delayResponse()
        
        if page == 1 {
            self.hasRemainingActivities = true
            self.activites = []
        }
        
        self.activites = [
            .mock,
            .mock2,
            .mock3
        ]
        
        self.hasRemainingActivities = false
    }
    
    override func createActivity(_ activity: Activity) async throws -> Activity {
        try await self.delayResponse()
        return activity
    }
    
    override func getActivity(_ id: Int) async throws -> Activity {
        try await self.delayResponse()
        
        switch id {
        case 1: return .mock
        case 2: return .mock2
        case 3: return .mock3
        default: throw ApiError.notFound
        }
    }
    
    override func updateActivity(_ activity: Activity) async throws -> Activity {
        try await self.delayResponse()
        return activity
    }
    
    override func deleteActivity(_ activity: Activity) async throws {
        try await self.delayResponse()
    }
    
    override func getContactActivities(_ contact: Contact) async throws -> [Activity] {
        try await self.delayResponse()
        return [
            .mock,
            .mock2,
            .mock3
        ]
    }
    
    
    override func getReminders() async throws -> [Reminder] {
        try await self.delayResponse()
        return [
            .mock,
            .mock2,
            .mock3
        ]
    }
    
    override func getUpcomingReminders() async throws -> [Reminder] {
        try await self.delayResponse()
        return [
            .mock,
            .mock2,
            .mock3
        ]
    }
    
    override func getReminder(_ id: Int) async throws -> Reminder {
        try await self.delayResponse()
        switch id {
        case 1: return .mock
        case 2: return .mock2
        case 3: return .mock3
        default: throw ApiError.notFound
        }
    }
    
    override func updateReminder(_ reminder: Reminder) async throws -> Reminder {
        try await self.delayResponse()
        return reminder
    }
    
    override func deleteReminder(_ reminder: Reminder) async throws {
        try await self.delayResponse()
    }
    
    override func completeReminder(_ reminder: Reminder, skip: Bool = false) async throws {
        try await self.delayResponse()
    }
    
    override func getContactReminders(_ contact: Contact) async throws -> [Reminder] {
        try await self.delayResponse()
        return [
            .mock,
            .mock2,
            .mock3
        ]
    }
    
    override func createContactReminder(contactId: Int, reminder: Reminder) async throws -> Reminder {
        try await self.delayResponse()
        return reminder
    }
    
    override func getCompletedReminders(for contact: Contact) async throws -> [ReminderCompletion] {
        try await self.delayResponse()
        return [
            .mock,
            .mock2,
            .mock3
        ]
    }
    
    override func deleteCompletedReminder(_ reminder: Reminder) async throws {
        try await self.delayResponse()
    }
    
    
    override func uploadCsvImport(_ csvData: Data) async throws -> ImportUploadResponse {
        throw ApiError.forbidden
    }
    
    override func uploadCsvImport(_ csvURL: URL) async throws -> ImportUploadResponse {
        throw ApiError.forbidden
    }
    
    override func previewCsvUpload(_ request: ImportPreviewRequest) async throws -> ImportPreviewResponse {
        throw ApiError.forbidden
    }
    
    override func confirmCsvUpload(_ request: ImportConfirmRequest) async throws -> ImportResult {
        throw ApiError.forbidden
    }
    
    override func uploadVcfImport(_ vcfData: Data) async throws -> ImportUploadResponse {
        throw ApiError.forbidden
    }
    
    override func uploadVcfImport(_ vcfURL: URL) async throws -> ImportUploadResponse {
        throw ApiError.forbidden
    }
    
    override func confirmVcfUpload(_ request: ImportConfirmRequest) async throws -> ImportResult {
        throw ApiError.forbidden
    }
    
    
    override func exportCSV() async throws -> Data {
        throw ApiError.forbidden
    }
    
    override func exportVCF() async throws -> Data {
        throw ApiError.forbidden
    }
    
    
    override func getNetworkGraph() async throws -> Graph {
        // TODO: Generate mock
        throw ApiError.forbidden
    }
    
    
    override func getUsers(limit: Int = 50, page: Int = 1) async throws -> [User] {
        try await self.delayResponse()
        return [
            .mock,
            .mock2,
            .mock3
        ]
    }
    
    override func getUser(_ id: Int) async throws -> User {
        try await self.delayResponse()
        switch id {
        case 1: return .mock
        case 2: return .mock2
        case 3: return .mock3
        default: throw ApiError.notFound
        }
    }
    
    override func updateUser(_ user: User) async throws -> User {
        try await self.delayResponse()
        return user
    }
    
    override func deleteUser(_ user: User) async throws {
        try await self.delayResponse()
    }
    
    override func checkHealth() async throws -> HealthStatus {
        try await self.delayResponse()
        return .mock
    }
}

extension ConnectionHandler {
    static let mock: ConnectionHandler = MockConnectionHandler()
}
