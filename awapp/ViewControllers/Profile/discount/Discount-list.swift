//
//  Discount-list.swift
//  awapp
//
//  Created by Putte on 2019-11-13.
//  Copyright © 2019 Putte. All rights reserved.
//

import Foundation
import UIKit

class listTxt{
    var category: String!
    var percent: String!
    var expiring: String!
    var documentId: String
    
    init(category: String, percent: String, expiring: String, documentId: String) {
        self.category = category
        self.percent = percent
        self.expiring = expiring
        self.documentId = documentId
    }
}
