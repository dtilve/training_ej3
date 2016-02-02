//
//  ContactTableViewCell.swift
//  ej3
//
//  Created by Dana Neyra on 2/2/16.
//  Copyright © 2016 Dana. All rights reserved.
//

import Foundation
import UIKit

class ContactTableViewCell : UITableViewCell {
    
    @IBOutlet weak var contactName: UILabel!
    @IBOutlet weak var contactPhoneNumber: UILabel!
    @IBOutlet weak var contactImage: UIImageView!
    @IBOutlet weak var contactEmail: UILabel!
    
    @IBOutlet weak var addFavButton: UIButton!

}