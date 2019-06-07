//
//  ContactsTableViewController.swift
//  Contacts
//
//  Created by Lo Howard on 6/7/19.
//  Copyright © 2019 Lo Howard. All rights reserved.
//

import UIKit

class ContactsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        ContactController.shared.fetchMessages { (success) in
            if success {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ContactController.shared.contacts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath)

        let contacts = ContactController.shared.contacts[indexPath.row]
        cell.textLabel?.text = contacts.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let contact = ContactController.shared.contacts[indexPath.row]
            ContactController.shared.delete(contact: contact) { (success) in
                if success {
                    DispatchQueue.main.async {
                        ContactController.shared.contacts.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .automatic)
                    }
                }
            }
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "toDetailVC" {
            guard let destinationVC = segue.destination as? ContactDetailViewController, let indexPath = tableView.indexPathForSelectedRow else { return }
            let contact = ContactController.shared.contacts[indexPath.row]
            destinationVC.contact = contact
        }
    }

}
