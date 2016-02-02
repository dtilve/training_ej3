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

class CustomViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var contacts: [ContactCardModel] = []
    var favorites : [ContactCardModel] = []
    
    @IBOutlet weak var contactTableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        favorites = retrieveFavs(contacts)
        
        contactTableView.delegate = self
        contactTableView.dataSource = self
        
        contacts = getAddressBook().map(ContactCardModel.init)
        contactTableView.reloadData()
        
    }
    
    @IBAction func addToFavs(sender: UIButton) {
        if (!contacts[sender.tag].favorite) {
            contacts[sender.tag].favorite = true
            let newFavorite = contacts[sender.tag]
            favorites.append(newFavorite)
        }
    }
    
    @IBAction func swapTableView(sender: AnyObject) {
        contactTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getAddressBook() -> [CNContact]{
        
        var contacts = [CNContact]()
        let store = CNContactStore()
        let keysToFetch = [CNContactFormatter.descriptorForRequiredKeysForStyle(.FullName),
            CNContactPhoneNumbersKey, CNContactEmailAddressesKey,
            CNContactThumbnailImageDataKey]
        let fetchRequest = CNContactFetchRequest(keysToFetch: keysToFetch)
        do
        {
            try store.enumerateContactsWithFetchRequest(fetchRequest, usingBlock:
                { (let contact, let stop) -> Void in
                    contacts.append(contact)
                })
        }
        catch let error as NSError
        {
            print(error.localizedDescription)
        }
        return contacts
    }
    
    func tableView (tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        var rows : Int = 0
       
        switch (segmentedControl.selectedSegmentIndex){
            case 0 :
            rows = contacts.count
            case 1 :
            rows = favorites.count
            default : break
        }
        return rows
    }

    
    func tableView (tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let contactCell = tableView.dequeueReusableCellWithIdentifier("ContactCell", forIndexPath: indexPath) as! ContactTableViewCell

        switch(segmentedControl.selectedSegmentIndex){
            case 0 :
                let contact = contacts[indexPath.row]
                contactCell.contactName.text = contact.name
                contactCell.contactPhoneNumber.text = contact.phoneNumber
                contactCell.contactEmail.text = contact.email
                contactCell.addFavButton.tag = indexPath.row
            case 1 :
                let favorite = favorites[indexPath.row]
                contactCell.contactName.text = favorite.name
                contactCell.contactPhoneNumber.text = favorite.phoneNumber
                contactCell.contactEmail.text = favorite.email
                contactCell.addFavButton.tag = indexPath.row
            default : break
        }
        return contactCell
    }
    
    func retrieveFavs(contacts: [ContactCardModel]) -> [ContactCardModel]{
        var favorites = [ContactCardModel]()
        for contact in contacts {
            if contact.favorite {
                favorites.append(contact)
            }
        }
        return favorites
    }
    
}


/*  func makeItRealm(addressBook : [CNContact]) -> Results<ContactCardModel> {
let realm = try! Realm()
for contact in addressBook {
let newContact = ContactCardModel()
newContact.name = contact.givenName + " " + contact.familyName
newContact.phoneNumber = (contact.phoneNumbers.first?.valueForKey("value")?.stringValue)!
if (contact.emailAddresses.first != nil){
newContact.email = (contact.emailAddresses.first?.value as! NSString) as String
}
print(newContact.name)
print(newContact.phoneNumber)
print(newContact.email)

try! realm.write() {
realm.add(newContact)
}
}
return realm.objects(ContactCardModel)
}*/
