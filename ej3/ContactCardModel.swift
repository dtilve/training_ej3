//
//  ContactCardModel.swift
//  ej3
//
//  Created by Dana Neyra on 2/2/16.
//  Copyright © 2016 Dana. All rights reserved.
//

import Foundation
import RealmSwift
import Contacts

struct Contact {
    
    let identifier: String
    let name : String
    let phoneNumber : String
    let email : String
    let favorite : Bool
    let image = NSData()

}

extension Contact {
    
    init(contact: CNContact, favorite : Bool = false) {
        self.identifier = contact.identifier
        self.name = "\(contact.givenName) \(contact.middleName) \(contact.familyName)"
        self.phoneNumber = extractFirstPhoneNumber(contact) ?? ""
        self.email = extractFirstEmail(contact) ?? ""
        self.favorite = favorite
    }
    
}

private func extractFirstPhoneNumber(contact: CNContact) -> String? {
    return (contact.phoneNumbers.first?.value as? CNPhoneNumber)?.stringValue
}

private func extractFirstEmail(contact: CNContact) -> String? {
    return (contact.emailAddresses.first?.value as? String)
}