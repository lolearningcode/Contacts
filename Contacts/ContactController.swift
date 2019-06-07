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
    let publicDB = CKContainer.default().publicCloudDatabase
    
    func createContactWith(name: String, phoneNumber: String, emailAddress: String, completion: @escaping (Bool) -> Void) {
        let contact = Contact(name: name, phoneNumber: phoneNumber, emailAddress: emailAddress)
        self.saveContact(contact: contact, completion: completion)
    }
    
    func saveContact(contact: Contact, completion: @escaping (Bool) -> ()) {
        let contactRecord = CKRecord(contact: contact)
        publicDB.save(contactRecord) { (record, error) in
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
        
        publicDB.perform(query, inZoneWith: nil) { (records, error) in
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
        let operation = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
        operation.savePolicy = .changedKeys
        operation.queuePriority = .high
        operation.qualityOfService = .userInitiated
        operation.completionBlock = {
            completion(true)
        }
        publicDB.add(operation)
    }
    
    func delete(contact: Contact, completion: @escaping (Bool) -> Void) {
        publicDB.delete(withRecordID: contact.recordID) { (_, error) in
            if let error = error {
                print("Error deleting record: \(error.localizedDescription)")
                completion(false)
                return
            }
            completion(true)
        }
    }
}

