//
//  ContactsTableViewModel.swift
//  ej3
//
//  Created by Dana Neyra on 2/3/16.
//  Copyright © 2016 Dana. All rights reserved.
//

import Foundation
import Contacts
import ReactiveCocoa
import Result

enum FilterType {
    
    case All
    case Favorites
    
    init?(index: Int) {
        switch index {
        case 0: self = .All
        case 1: self = .Favorites
        default: return nil
        }
    }
    
}

private let ContactRequest: CNContactFetchRequest = {
    let keysToFetch = [
        CNContactFormatter.descriptorForRequiredKeysForStyle(.FullName),
        CNContactPhoneNumbersKey,
        CNContactEmailAddressesKey,
        CNContactThumbnailImageDataKey]
    return CNContactFetchRequest(keysToFetch: keysToFetch)
}()

struct ContactListViewModel  {
    
    private let _contacts = MutableProperty<[ContactViewModel]>([])
    
    let contacts: AnyProperty<[ContactViewModel]>
    let favorites: AnyProperty<[ContactViewModel]>
    
    let fetchContacts: Action<AnyObject, [ContactViewModel], NSError>
    
    let activeFilter = MutableProperty(FilterType.All)
    
    let reloadContactList: SignalProducer<(), NoError>
    
    var countForActiveFilter: Int {
        switch activeFilter.value {
        case .All: return contacts.value.count
        case .Favorites: return favorites.value.count
        }
    }
    
    init(contactStore: ContactStoreType = ContactStore(), addressBook: PhoneAddressBookServiceType = PhoneAddressBookService()) {
        fetchContacts = Action { _ in
            addressBook.fetchContacts(ContactRequest)
                .flatMap(.Concat) { contactStore.hydrateContacts($0) }
                .map { contacts in contacts.map { ContactViewModel(contact: $0, contactStore: contactStore) } }
        }
        
        contacts = AnyProperty(initialValue: [], producer: _contacts.producer)
        favorites = AnyProperty(initialValue: [], producer: _contacts.producer.map { contacts in
            print("Contacts to filter")
            print(contacts)
            let filtered = contacts.filter { $0.favorited }
            print(filtered)
            return filtered
        })
        
        let reloadContactsTriggers = [
            favorites.producer.map { _ in () },
            activeFilter.producer.map { _ in () }
        ]
        reloadContactList = SignalProducer(values: reloadContactsTriggers)
            .flatten(.Merge)
        
        _contacts <~ fetchContacts.values
        
        let performFech = self.fetchContacts.apply("")
        contactStore.contactFavoriteChanged.observeNext { _ in performFech.start() }
        addressBook.contactsUpdated.observeNext { _ in performFech.start() }
    }

    subscript(index: Int) -> ContactViewModel {
        switch activeFilter.value {
        case .Favorites: return favorites.value[index]
        case .All: return contacts.value[index]
        }
    }

}