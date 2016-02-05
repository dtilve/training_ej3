//
//  ContactStore.swift
//  ej3
//
//  Created by Dana Neyra on 2/5/16.
//  Copyright © 2016 Dana. All rights reserved.
//

import Foundation
import ReactiveCocoa
import Contacts
import Result

protocol ContactStoreType {
    
    var contactFavoriteChanged: Signal<(), NoError> { get }
    
    func updateFavorite(contact: Contact, favorite: Bool) -> SignalProducer<Contact, NSError>
    
    func hydrateContacts(contacts: [CNContact]) -> SignalProducer<[Contact], NSError>
    
}

final class ContactStore: ContactStoreType {
    
    private let (_contactFavoriteChanged, _contactFavoriteChangedObserver) = Signal<(), NoError>.pipe()
    
    private var _database: [String : Bool] = [:]
    
    var contactFavoriteChanged: Signal<(), NoError> {
        return _contactFavoriteChanged
    }
    
    func updateFavorite(contact: Contact, favorite: Bool) -> SignalProducer<Contact, NSError> {
        _database[contact.identifier] = favorite
        let notify = { self._contactFavoriteChangedObserver.sendNext(()) }
        return SignalProducer(value: contact)
            .on(started: notify, failed: { _ in notify() })
    }
        
    func hydrateContacts(contacts: [CNContact]) -> SignalProducer<[Contact], NSError> {
        return SignalProducer(value: contacts.map { contact in
            let isFavorited = self._database[contact.identifier] ?? false
            print("Contact \(contact.givenName) is favorited \(isFavorited)")
            return Contact(contact: contact, favorite: isFavorited)
        })
    }
    
}