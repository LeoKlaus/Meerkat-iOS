
//
//  Contact+empty.swift
//  Meerkat-iOS
//
//  Created by Leo Wehrfritz on 08.04.26.
//

import MeerkatAPI

extension Contact {
    static let empty = Contact(
        id: 0,
        createdAt: nil,
        updatedAt: nil,
        deletedAt: nil,
        firstname: "",
        lastname: nil,
        nickname: nil,
        gender: .unknown,
        email: nil,
        phone: nil,
        birthday: nil,
        photo: nil,
        relationships: nil,
        address: nil,
        howWeMet: nil,
        foodPreference: nil,
        workInformation: nil,
        contactInformation: nil,
        circles: nil,
        customFields: nil,
        archived: false,
        photoThumbnail: nil
    )
}
