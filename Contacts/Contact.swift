//
//  Contact.swift
//  Contacts
//
//  Created by Lo Howard on 6/7/19.
//  Copyright © 2019 Lo Howard. All rights reserved.
//

import Foundation
import CloudKit

struct Constants {
    static let recordKey = "Contact"
    static let nameKey = "name"
    static let phoneNumberKey = "phoneNumber"
    static let emailAddressKey = "emailAddress"
}

class Contact {
    var name: String
    var phoneNumber: String
    var emailAddress: String
    let recordID: CKRecord.ID
    
    
    init(name: String, phoneNumber: String, emailAddress: String, recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.name = name
        self.phoneNumber = phoneNumber
        self.emailAddress = emailAddress
        self.recordID = recordID
    }
    
    convenience init?(ckRecord: CKRecord) {
        guard let name = ckRecord[Constants.nameKey] as? String,
        let phoneNumber = ckRecord[Constants.phoneNumberKey] as? String,
            let emailAddress = ckRecord[Constants.emailAddressKey] as? String else { return nil}
        self.init(name: name, phoneNumber: phoneNumber, emailAddress: emailAddress, recordID: ckRecord.recordID)
    }
}

extension CKRecord {
    convenience init(contact: Contact) {
        self.init(recordType: Constants.recordKey, recordID: contact.recordID)
        setValue(contact.name, forKey: Constants.nameKey)
        setValue(contact.phoneNumber, forKey: Constants.phoneNumberKey)
        setValue(contact.emailAddress, forKey: Constants.emailAddressKey)
    }
}
