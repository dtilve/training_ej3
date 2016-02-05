//
//  PhoneAddressBookService.swift
//  ej3
//
//  Created by Dana Neyra on 2/5/16.
//  Copyright © 2016 Dana. All rights reserved.
//

import Foundation
import Contacts
import ReactiveCocoa
import Result

protocol PhoneAddressBookServiceType {
    
    var contactsUpdated: Signal<(), NoError> { get }
    
    func fetchContacts(request: CNContactFetchRequest) -> SignalProducer<[CNContact], NSError>
    
}

final class PhoneAddressBookService: PhoneAddressBookServiceType {
    
    private let (_contactsUpdated, _contactsUpdatedObserver) = Signal<(), NoError>.pipe()
    var contactsUpdated: Signal<(), NoError>  {
        return _contactsUpdated
    }
    
    private let _contactStore = CNContactStore()
    
    init() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("contactChanged:"), name: CNContactStoreDidChangeNotification, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func fetchContacts(request: CNContactFetchRequest) -> SignalProducer<[CNContact], NSError> {
        return SignalProducer.attempt { self._contactStore.fetchContacts(request) }
    }
    
    @objc
    func contactChanged(notification: NSNotification) {
        _contactsUpdatedObserver.sendNext(())
    }
    
}

extension CNContactStore {
    
    func fetchContacts(request: CNContactFetchRequest) -> Result<[CNContact], NSError> {
        let fetch: () throws -> [CNContact] = {
            var contacts: [CNContact] = []
            print("Enumerating contacts")
            try self.enumerateContactsWithFetchRequest(request) { contact, _ in
                print(contact)
                contacts.append(contact)
            }
            print("There are \(contacts.count) in the contact store")
            return contacts
        }
        return Result(attempt: fetch)
    }
    
}