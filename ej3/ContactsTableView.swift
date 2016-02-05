//
//  CustomViewController.swift
//  ej3
//
//  Created by Dana Neyra on 2/2/16.
//  Copyright © 2016 Dana. All rights reserved.
//

import UIKit
import Contacts
import RealmSwift

final class CustomViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private var contactListViewModel = ContactListViewModel()
    
    @IBOutlet weak var contactTableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        contactTableView.delegate = self
        contactTableView.dataSource = self
    
        contactListViewModel.reloadContactList.startWithNext { [unowned self]_ in
            print("Reloading contact list table")
            self.contactTableView.reloadData()
        }
        contactListViewModel.fetchContacts.apply("").start()
    }
    
    @IBAction func swapTableView(sender: AnyObject) {
        if let filter = FilterType(index: segmentedControl.selectedSegmentIndex) {
            contactListViewModel.activeFilter.value = filter
        }
    }

    
    // TABLEVIEW METHODS
    
    func tableView (tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        let count = contactListViewModel.countForActiveFilter
        print("Table count \(count)")
        return count
    }

    func tableView (tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let contactCell = tableView.dequeueReusableCellWithIdentifier("ContactCell", forIndexPath: indexPath) as! ContactTableViewCell
        let contact = contactListViewModel[indexPath.row]
        
        contactCell.contactName.text = contact.name
        contactCell.contactPhoneNumber.text = contact.phone
        contactCell.contactEmail.text = contact.email
        contactCell.addFavButton.rex_pressed.value = contact.favorite.unsafeCocoaAction
        
        return contactCell 
    }

}
