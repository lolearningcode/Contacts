//
//  ContactDetailViewController.swift
//  Contacts
//
//  Created by Lo Howard on 6/7/19.
//  Copyright © 2019 Lo Howard. All rights reserved.
//

import UIKit

class ContactDetailViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var emailAddressTextField: UITextField!
    
    var contact: Contact? {
        didSet {
            loadViewIfNeeded()
            updateViews()
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let name = nameTextField.text, !name.isEmpty, let phoneNumber = phoneNumberTextField.text, let emailAddress = emailAddressTextField.text else { return }
        
        if let contact = contact {
            ContactController.shared.update(contact: contact, withName: name, phoneNumber: phoneNumber, emailAddress: emailAddress) { (success) in
                if success {
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        } else {
            let newContact = Contact(name: name, phoneNumber: phoneNumber, emailAddress: emailAddress)
            ContactController.shared.createContactWith(name: name, phoneNumber: phoneNumber, emailAddress: emailAddress) { (success) in
                if success {
                    DispatchQueue.main.async {
                        self.contact = newContact
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
    
    func updateViews() {
        guard let contact = contact else { return }
        nameTextField.text = contact.name
        phoneNumberTextField.text = contact.phoneNumber
        emailAddressTextField.text = contact.emailAddress
        
    }
}
