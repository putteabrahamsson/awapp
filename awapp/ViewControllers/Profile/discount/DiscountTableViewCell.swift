//
//  DiscountTableViewCell.swift
//  awapp
//
//  Created by Putte on 2019-11-13.
//  Copyright © 2019 Putte. All rights reserved.
//

import UIKit

class DiscountTableViewCell: UITableViewCell {

    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var percent: UILabel!
    @IBOutlet weak var expiring: UILabel!
    @IBOutlet weak var documentId: UILabel!
    
    func setCell(list: listTxt){
        category.text = list.category
        percent.text = list.percent
        expiring.text = list.expiring
        documentId.text = list.documentId
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))

        contentView.layer.cornerRadius = 10
    }

}
