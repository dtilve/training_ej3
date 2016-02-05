//
//  ContactCardViewModel.swift
//  ej3
//
//  Created by Dana Neyra on 2/3/16.
//  Copyright © 2016 Dana. All rights reserved.
//

import Foundation
import ReactiveCocoa
import Contacts
import Rex
import Result

struct ContactViewModel {
    
    private let _contact: Contact
    
    let favorite: Action<AnyObject, Bool, NSError>
    
    var name: String {
        return _contact.name
    }
    
    var email: String {
        return _contact.email
    }
    
    var phone: String {
        return _contact.phoneNumber
    }
    
    var favorited: Bool {
        return _contact.favorite
    }
    
    init(contact: Contact, contactStore: ContactStoreType) {
        _contact = contact
        favorite = Action { _ in contactStore.updateFavorite(contact, favorite: !contact.favorite).map { $0.favorite } }
    }

}
