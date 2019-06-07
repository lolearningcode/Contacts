//
//  ContactController.swift
//  Contacts
//
//  Created by Lo Howard on 6/7/19.
//  Copyright © 2019 Lo Howard. All rights reserved.
//

import Foundation
import CloudKit

class ContactController {
    static let shared = ContactController()
    var contacts: [Contact] = []
    let privateDB = CKContainer.default().publicCloudDatabase
    
    func createContactWith(name: String, phoneNumber: String, emailAddress: String, completion: @escaping (Bool) -> Void) {
        let contact = Contact(name: name, phoneNumber: phoneNumber, emailAddress: emailAddress)
        self.saveContact(contact: contact, completion: completion)
    }
    
    func saveContact(contact: Contact, completion: @escaping (Bool) -> ()) {
        let contactRecord = CKRecord(contact: contact)
        privateDB.save(contactRecord) { (record, error) in
            if let error = error {
                print("Error saving: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            guard let record = record, let contact = Contact(ckRecord: record) else { completion(false); return }
            self.contacts.append(contact)
            completion(true)
        }
    }
    
    func fetchMessages(completion: @escaping (Bool) -> ()) {
        
        let predicate = NSPredicate(value: true)
        
        let query = CKQuery(recordType: Constants.recordKey, predicate: predicate)
        
        privateDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("Error fetching: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            guard let records = records else { completion(false); return }
            let contacts = records.compactMap({ Contact(ckRecord: $0) })
            self.contacts = contacts
            completion(true)
        }
    }
    
    func update(contact: Contact, withName name: String, phoneNumber: String, emailAddress: String, completion: @escaping (Bool) -> Void) {
        contact.name = name
        contact.phoneNumber = phoneNumber
        contact.emailAddress = emailAddress
        
        let record = CKRecord(contact: contact)
        let operation = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: )
    }
}
