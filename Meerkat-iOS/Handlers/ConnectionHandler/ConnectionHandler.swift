//
//  ConnectionHandler.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 29.03.26.
//

import Foundation
import MeerkatAPI
import EasyErrorHandling

@Observable
class ConnectionHandler {
    
    private var apiHandler: ApiHandler
    
    var contacts: [Contact] = []
    var hasRemainingContacts: Bool = true
    
    var notes: [Note] = []
    var hasRemainingNotes: Bool = true
    
    var activites: [Activity] = []
    var hasRemainingActivities: Bool = true
    
    var circles: [String] = []
    var customFields: [String] = []
    
    var currentInstance: ConnectedInstance
    
    init(serverURL: URL, username: String, token: String) throws {
        let apiHandler = ApiHandler(serverURL: serverURL, token: token)
        
        let instance = ConnectedInstance(serverURL: serverURL, username: username)
        
        try instance.save(token: token)
        
        try instance.markActive()
        
        self.currentInstance = instance
        
        self.apiHandler = apiHandler
    }
    
    init(apiHandler: ApiHandler, instance: ConnectedInstance) {
        self.apiHandler = apiHandler
        self.currentInstance = instance
    }
    
    init(instance: ConnectedInstance) throws {
        let token = try instance.getToken()
        
        self.currentInstance = instance
        self.apiHandler = ApiHandler(serverURL: instance.serverURL, token: token)
    }
    
    convenience init?() {
        do {
            let instance = try ConnectedInstance.getActiveInstance()
            try self.init(instance: instance)
        } catch {
            switch error {
            case ConnectedInstanceError.instanceNotFound:
                return nil
            default:
                ErrorHandler.shared.handle(error, while: "setting up ApiHandler")
                return nil
            }
        }
    }
    
    func switchInstance(to newInstance: ConnectedInstance) throws {
        self.apiHandler = ApiHandler(serverURL: newInstance.serverURL, token: try newInstance.getToken())
        self.currentInstance = newInstance
        
        self.contacts = []
        self.hasRemainingContacts = true
        
        self.notes = []
        self.hasRemainingNotes = true
        
        self.activites = []
        self.hasRemainingActivities = true
        
        try newInstance.markActive()
    }

    
    // MARK: Auth
    /**
     Create a new user account
     - Parameter username:      minimum 1 characters
     - Parameter mailAddress:   Email address of the user
     - Parameter password:      minimum 8 characters, can be tested beforehand using `checkPasswordStrength(String)`
     - Parameter language:      InterfaceLanguage (currently either `en` or `de`)
     */
    public func register(username: String, password: String, mailAddress: String, language: InterfaceLanguage) async throws {
        try await self.apiHandler.register(username: username, password: password, mailAddress: mailAddress, language: language)
    }
    
    /**
     Authenticate and set session cookie
     - Parameter username
     - Parameter password
     
     - Returns: LoginResponse, if authentication was successful
     */
    public func login(username: String, password: String) async throws -> LoginResponse {
        return try await self.apiHandler.login(username: username, password: password)
    }
    
    /**
     Clear current session cookie
     */
    public func logout() async throws {
        try await self.apiHandler.logout()
    }
    
    /**
     Validate a password without registering
     - Parameter password: Password to check
     
     - Returns: PasswordStrengthResponse for the given password
     */
    public func checkPasswordStrength(_ password: String) async throws -> PasswordStrengthResponse {
        return try await self.apiHandler.checkPasswordStrength(password)
    }
    
    /**
     Send a password reset email
     - Parameter mailAddress: Mail address of the user whos password should be reset
     */
    public func requestPasswordReset(mailAddress: String) async throws {
        try await self.apiHandler.requestPasswordReset(mailAddress: mailAddress)
    }
    
    /**
     Apply a password reset token
     - Parameter token: Token from the password reset mail
     - Parameter newPassword: New password for the user
     */
    public func confirmPasswordReset(token: String, newPassword: String) async throws {
        try await self.apiHandler.confirmPasswordReset(token: token, newPassword: newPassword)
    }
    
    
    // MARK: User
    /** Get the current user
     - Returns: The current user
     */
    public func getMe() async throws -> User {
        try await self.apiHandler.getMe()
    }
    /**
     Change password
     - Parameter currentPassword: Current password of the user
     - Parameter newPassword: New password for the user
     */
    public func changePassword(currentPassword: String, newPassword: String) async throws {
        try await self.apiHandler.changePassword(currentPassword: currentPassword, newPassword: newPassword)
    }
    
    /**
     Update UI language preference (WebUI only!)
     - Parameter newLanguage: New language to use
     */
    public func changeLanguage(_ newLanguage: InterfaceLanguage) async throws {
        try await self.apiHandler.changeLanguage(newLanguage)
    }
    
    /**
     Update date format preference (WebUI only!)
     - Parameter newFormat: New date format to use
     */
    public func changeDateFormat(_ newFormat: DateFormat) async throws {
        try await self.apiHandler.changeDateFormat(newFormat)
    }
    
    /**
     Get custom field names
     - Returns: CustomFields object containing all custom field names
     */
    public func getCustomFields() async throws {
        self.customFields = try await self.apiHandler.getCustomFields().customFieldNames
    }
    
    /**
     Update custom field names
     - Parameter newFields: CustomFields object with the names of **all custom fields**, including those to be created
     
     - Returns: CustomFields object containing all custom field names
     */
    public func updateCustomFields(_ newFields: CustomFields) async throws {
        self.customFields = try await self.apiHandler.updateCustomFields(newFields).customFieldNames
    }
    
    
    // MARK: Contacts
    /**
     List contacts
     - Parameter fields: Fields to include with the response (defaults are sensible)
     - Parameter limit: Maximum number of contacts per page
     - Parameter page: Which page to load (starts at 1!)
     - Parameter sort: Which attribute to sort contacts by (defaults to `ID`)
     - Parameter order: Sort order, either `asc` or `desc`
     
     - Returns: List of contacts
     */
    func getContacts(limit: Int = 50, page: Int = 1, searchText: String? = nil, sortBy: Contact.CodingKeys = .id, sortOrder: SortOrder = .reverse, includeArchived: Bool = false, circleFilter: String? = nil) async throws {
        if page == 1 {
            self.hasRemainingContacts = true
            self.contacts = []
        }
        
        
        let contactResponse = try await self.apiHandler.getContacts(limit: limit, page: page, search: searchText, sort: sortBy, order: sortOrder, includeArchived: includeArchived, circleFilter: circleFilter)
        
        self.contacts += contactResponse.results
        
        if let total = contactResponse.total {
            self.hasRemainingContacts = self.contacts.count < total
        }
    }
    
    /**
     Create new contact
     - Parameter newContact: Contact object for the new contact
     
     - Returns: The newly created contact
     */
    public func createContact(_ newContact: Contact) async throws -> Contact {
        let createdContact = try await self.apiHandler.createContact(newContact)
        
        self.contacts.insert(createdContact, at: 0)
        
        return createdContact
    }
    
    /**
     Get a contact
     - Returns: The contact with the given id
     */
    public func getContact(id: Int) async throws -> Contact {
        return try await self.apiHandler.getContact(id: id)
    }
    
    /**
     Update an existing contact
     - Parameter contact: Contact object for the contact
     
     - Returns: The updated contact
     */
    public func updateContact(_ contact: Contact) async throws -> Contact {
        let updatedContact = try await self.apiHandler.updateContact(contact)
        
        if let index = self.contacts.firstIndex(where: {$0.id == updatedContact.id}) {
            self.contacts[index] = updatedContact
        }
        
        return updatedContact
    }
    
    /**
     Delete an existing contact
     - Parameter contact: Contact to delete
     */
    public func deleteContact(_ contact: Contact) async throws {
        try await self.apiHandler.deleteContact(contact)
    }
    
    /**
     Archive a contact
     - Parameter contact: Contact to archive
     
     - Returns: The archived contact
     */
    public func archiveContact(_ contact: Contact) async throws -> Contact {
        try await self.apiHandler.archiveContact(contact)
    }
    /**
     Unarchive a contact
     - Parameter contact: Contact to unarchive
     
     - Returns: The unarchived contact
     */
    public func unarchiveContact(_ contact: Contact) async throws -> Contact {
        return try await self.apiHandler.unarchiveContact(contact)
    }
    
    /**
     Load all circles in use
     */
    public func getCircles() async throws {
        self.circles = try await self.apiHandler.getCircles()
    }
    
    /**
     Get five random contacts
     - Returns: Up to five random contacts
     */
    public func getRandomContacts() async throws -> [Contact] {
        return try await self.apiHandler.getRandomContacts()
    }
    
    /**
     Get upcoming birthdays
     - Returns: List of upcoming birthdays
     */
    public func getUpcomingBirthdays() async throws -> [Birthday] {
        return try await self.apiHandler.getUpcomingBirthdays()
    }
    
    /** Get a contact’s profile picture
     - Parameter contact: The contact whose profile should be loaded
     */
    public func getContactImage(_ contact: Contact) async throws -> Data {
        return try await self.apiHandler.getContactImage(contact)
    }
    
    /**
     Upload an image for a contact
     - Parameter contact: The contact this image sohuld be assigned to
     - Parameter imageURL: URL to the image file
     
     - Returns: The updated contact
     */
    public func uploadContactImage(contact: Contact, imageURL: URL) async throws -> Contact {
        return try await self.apiHandler.uploadContactImage(contact: contact, imageURL: imageURL)
    }
    
    
    // MARK: Relationship Endpoints
    /**
     List outgoing relationships
     - Parameter contact: Contact whose relationships should be loaded
     
     - Returns: List of outgoing relationships for that contact
     */
    public func getOutgoingRelationships(_ contact: Contact) async throws -> [Relationship] {
        return try await self.apiHandler.getOutgoingRelationships(contact)
    }
    
    /**
     Create outgoing relationships
     - Parameter contact: Contact to which the relationship should be added
     - Parameter relationship: The new relationship
     
     - Returns: The newly created relationship
     */
    public func createRelationship(contact: Contact, relationShip: Relationship) async throws -> Relationship {
        return try await self.apiHandler.createRelationship(contact: contact, relationShip: relationShip)
    }
    
    /**
     List incoming relationships
     - Parameter contact: Contact whose relationships should be loaded
     
     - Returns: List of incoming relationships for that contact
     */
    public func getIncomingRelationships(_ contact: Contact) async throws -> [Relationship] {
        return try await self.apiHandler.getIncomingRelationships(contact)
    }
    
    /**
     Update a relationship
     - Parameter contact: Contact whose relationship should be updated
     - Parameter relationship: The relationship to be updated
     
     - Returns: The updated relationship
     */
    public func updateRelationship(contact: Contact, relationship: Relationship) async throws -> Relationship {
        return try await self.apiHandler.updateRelationship(contact: contact, relationship: relationship)
    }
    
    /**
     Delete a relationship
     - Parameter contact: Contact whose relationship should be deleted
     - Parameter relationship: The relationship to be deleted
     */
    public func deleteRelationship(contact: Contact, relationship: Relationship) async throws {
        return try await self.apiHandler.deleteRelationship(contact: contact, relationship: relationship)
    }
    
    
    // MARK: Note Endpoints
    /**
     Get all notes for a contact
     - Parameter contact: Contact whose notes should be shown
     
     - Returns: List of notes for the given contact
     */
    public func getContactNotes(_ contact: Contact) async throws -> [Note] {
        return try await self.apiHandler.getContactNotes(contact)
    }
    
    /**
     Create a note for a contact
     - Parameter contactId: ID of the contact to create a note for
     - Parameter note: Note to create
     
     - Returns: The newly created note
     */
    public func createContactNote(contactId: Int, note: Note) async throws -> Note {
        return try await self.apiHandler.createContactNote(contactId: contactId, note: note)
    }
    
    /**
     Get all unassigned notes
     - Parameter limit: Maximum number of contacts per page
     - Parameter page: Which page to load (starts at 1!)
     
     - Returns: List of unassigned notes
     */
    public func getUnassignedNotes(limit: Int = 50, page: Int = 1) async throws {
        if page == 1 {
            self.hasRemainingNotes = true
            self.notes = []
        }
        
        let noteResponse = try await self.apiHandler.getUnassignedNotes(limit: limit, page: page)
        
        self.notes += noteResponse.results
        
        if let total = noteResponse.total {
            self.hasRemainingNotes = self.notes.count < total
        }
    }
    
    /**
     Create an unassigned note
     - Parameter note: The note to create
     
     - Returns: The newly created note
     */
    public func createUnassignedNote(_ note: Note) async throws -> Note {
        return try await self.apiHandler.createUnassignedNote(note)
    }
    
    
    /**
     Get a note
     - Returns: Note with the given id
     */
    public func getNote(_ id: Int) async throws -> Note {
        return try await self.apiHandler.getNote(id)
    }
    
    /**
     Update a note
     - Parameter note: Note to update
     
     - Returns: The updated note
     */
    public func updateNote(_ note: Note) async throws -> Note {
        return try await self.apiHandler.updateNote(note)
    }
    
    /**
     Delete a note
     - Parameter note: Note to delete
     */
    public func deleteNote(_ note: Note) async throws {
        return try await self.apiHandler.deleteNote(note)
    }
    
    
    // MARK: Activity Endpoints
    /**
     Get all activities
     - Parameter limit: Maximum number of contacts per page
     - Parameter page: Which page to load (starts at 1!)
     
     - Returns: List of activities
     */
    public func getActivities(limit: Int = 50, page: Int = 1) async throws {
        if page == 1 {
            self.hasRemainingActivities = true
            self.activites = []
        }
        
        let response = try await self.apiHandler.getActivities(limit: limit, page: page)
        
        self.activites += response.results
        
        if let total = response.total {
            self.hasRemainingActivities = self.activites.count < total
        }
    }
    
    /**
     Create an activity
     - Parameter activity: The activity to create
     
     - Returns: The newly created note
     */
    public func createActivity(_ activity: Activity) async throws -> Activity {
        return try await self.apiHandler.createActivity(activity)
    }
    
    /**
     Get an activity
     - Returns: Activity with the given id
     */
    public func getActivity(_ id: Int) async throws -> Activity {
        return try await self.apiHandler.getActivity(id)
    }
    
    /**
     Update an activity
     - Parameter activity: Activity to update
     
     - Returns: The updated activity
     */
    public func updateActivity(_ activity: Activity) async throws -> Activity {
        return try await self.apiHandler.updateActivity(activity)
    }
    
    /**
     Delete an activity
     - Parameter activity: Activity to delete
     */
    public func deleteActivity(_ activity: Activity) async throws {
        return try await self.apiHandler.deleteActivity(activity)
    }
    
    /**
     Get activities for a contact
     - Parameter contact: Contact whose activities to load
     
     - Returns: All activities for that contact
     */
    public func getContactActivities(_ contact: Contact) async throws -> [Activity] {
        return try await self.apiHandler.getContactActivities(contact)
    }
    
    
    // MARK: Reminder Endpoints
    /**
     Get all reminders
     - Returns: List of reminders
     */
    public func getReminders() async throws -> [Reminder] {
        return try await self.apiHandler.getReminders()
    }
    
    /**
     Get all upcoming reminders
     - Returns: List of reminders
     */
    public func getUpcomingReminders() async throws -> [Reminder] {
        return try await self.apiHandler.getUpcomingReminders()
    }
    
    /**
     Get a reminder
     - Returns: Reminder with the given id
     */
    public func getReminder(_ id: Int) async throws -> Reminder {
        return try await self.apiHandler.getReminder(id)
    }
    
    /**
     Update a reminder
     - Parameter reminder: Reminder to update
     
     - Returns: The updated reminder
     */
    public func updateReminder(_ reminder: Reminder) async throws -> Reminder {
        return try await self.apiHandler.updateReminder(reminder)
    }
    
    /**
     Delete a reminder
     - Parameter reminder: Reminder to delete
     */
    public func deleteReminder(_ reminder: Reminder) async throws {
        return try await self.apiHandler.deleteReminder(reminder)
    }
    
    /**
     Mark a reminder complete (creates timeline entry)
     - Parameter reminder: Reminder to mark completed
     - Parameter skip: Whether to skip the reminder
     */
    public func completeReminder(_ reminder: Reminder, skip: Bool = false) async throws {
        return try await self.apiHandler.completeReminder(reminder)
    }
    
    /**
     Get reminders for a contact
     - Parameter contact: Contact to get reminders for
     
     - Returns: Reminders for that contact
     */
    public func getContactReminders(_ contact: Contact) async throws -> [Reminder] {
        return try await self.apiHandler.getContactReminders(contact)
    }
    
    /**
     Create a reminder for a contact
     - Parameter contact: Contact to get create a reminder for
     - Parameter reminder: Reminder to create
     
     - Returns: Newly created reminder
     */
    public func createContactReminder(contactId: Int, reminder: Reminder) async throws -> Reminder {
        return try await self.apiHandler.createContactReminder(contactId: contactId, reminder: reminder)
    }
    
    /**
     List completion history for a contact (timeline entries)
     - Parameter contact: Contact whose timeline to get
     
     - Returns: List of completed reminders for that contact
     */
    public func getCompletedReminders(for contact: Contact) async throws -> [ReminderCompletion] {
        return try await self.apiHandler.getCompletedReminders(for: contact)
    }
    
    /** Delete a completion entry
     - Parameter reminder: Reminder to delete
     */
    public func deleteCompletedReminder(_ reminder: Reminder) async throws {
        return try await self.apiHandler.deleteCompletedReminder(reminder)
    }
    
    
    // MARK: Import
    /**
     Upload a CSV file, returns parsed preview data
     - Parameter csvData: Data representation of the CSV file to upload
     
     - Returns: UploadPreviewResponse
     */
    public func uploadCsvImport(_ csvData: Data) async throws -> ImportUploadResponse {
        return try await self.apiHandler.uploadCsvImport(csvData)
    }
    
    /**
     Upload a CSV file, returns parsed preview data
     - Parameter csvURL: URL of the CSV file to upload
     
     - Returns: UploadPreviewResponse
     */
    public func uploadCsvImport(_ csvURL: URL) async throws -> ImportUploadResponse {
        return try await self.apiHandler.uploadCsvImport(csvURL)
    }
    
    /**
     Apply column mapping, returns contacts with duplicate detection (POST)
     - Parameter request: ImportPreviewRequest for the import
     
     - Returns: ImportPreviewResponse
     */
    public func previewCsvUpload(_ request: ImportPreviewRequest) async throws -> ImportPreviewResponse {
        return try await self.apiHandler.previewCsvUpload(request)
    }
    
    /**
     Execute the import with per-row decisions (POST)
     - Parameter request: ImportConfirmRequest
     
     - Returns: ImportResult
     */
    public func confirmCsvUpload(_ request: ImportConfirmRequest) async throws -> ImportResult {
        return try await self.apiHandler.confirmCsvUpload(request)
    }
    
    /**
     Upload a VCF file, returns contacts with duplicate detection (POST/Multipart form)
     - Parameter vcfData: Data representation of the VCF file to upload
     
     - Returns: UploadPreviewResponse
     */
    public func uploadVcfImport(_ vcfData: Data) async throws -> ImportUploadResponse {
        return try await self.apiHandler.uploadVcfImport(vcfData)
    }
    
    /**
     Upload a VCF file, returns contacts with duplicate detection (POST/Multipart form)
     - Parameter vcfURL: Data representation of the VCF file to upload
     
     - Returns: UploadPreviewResponse
     */
    public func uploadVcfImport(_ vcfURL: URL) async throws -> ImportUploadResponse {
        return try await self.apiHandler.uploadVcfImport(vcfURL)
    }
    
    /**
     Execute the VCF import (POST)
     - Parameter request: ImportConfirmRequest
     
     - Returns: ImportResult
     */
    public func confirmVcfUpload(_ request: ImportConfirmRequest) async throws -> ImportResult {
        return try await self.apiHandler.confirmVcfUpload(request)
    }
    
    
    // MARK: Export
    /**
     Download all data as CSV
     - Returns: Data of the CSV file
     */
    public func exportCSV() async throws -> Data {
        return try await self.apiHandler.exportCSV()
    }
    
    /**
     Download all contacts as VCF (includes photos)
     - Returns: Data of the VCF file
     */
    public func exportVCF() async throws -> Data {
        return try await self.apiHandler.exportVCF()
    }
    
    
    // MARK: Graph
    
    /** Get contact network graph data
     - Returns: Graph object containing all nodes and edges of the graph
     */
    public func getNetworkGraph() async throws -> Graph {
        return try await self.apiHandler.getNetworkGraph()
    }
    
    
    // MARK: Admin
    /**
     Get all users
     - Parameter limit: Maximum number of users per page
     - Parameter page: Which page to load (starts at 1!)
     
     - Returns: List of users
     */
    public func getUsers(limit: Int = 50, page: Int = 1) async throws -> [User] {
        return try await self.apiHandler.getUsers(limit: limit, page: page)
    }
    
    /**
     Get a user
     - Returns: User with the given id
     */
    public func getUser(_ id: Int) async throws -> User {
        return try await self.apiHandler.getUser(id)
    }
    
    /**
     Update a user
     - Parameter user: User to update
     
     - Returns: The updated user
     */
    public func updateUser(_ user: User) async throws -> User {
        return try await self.apiHandler.updateUser(user)
    }
    
    /**
     Delete a user
     - Parameter user: User to delete
     */
    public func deleteUser(_ user: User) async throws {
        return try await self.apiHandler.deleteUser(user)
    }
    
    
    // MARK: Health
    /**
     Health check
     - Returns: Health status for the server
     */
    public func checkHealth() async throws -> HealthStatus {
        return try await self.apiHandler.checkHealth()
    }
}
