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

class ContactCardModel : Object {
    var name : String = ""
    var phoneNumber : String = ""
    var email : String = ""
    var favorite : Bool = false
    var image = NSData()
}

extension ContactCardModel {
    
    convenience init(contact: CNContact) {
        self.init()
        self.name = "\(contact.givenName) \(contact.middleName) \(contact.familyName)"
        self.phoneNumber = extractFirstPhoneNumber(contact) ?? ""
        self.email = extractFirstEmail(contact) ?? ""
        self.favorite = false
    }
    
}

private func extractFirstPhoneNumber(contact: CNContact) -> String? {
    return (contact.phoneNumbers.first?.value as? CNPhoneNumber)?.stringValue
}

private func extractFirstEmail(contact: CNContact) -> String? {
    return (contact.emailAddresses.first?.value as? String)
}