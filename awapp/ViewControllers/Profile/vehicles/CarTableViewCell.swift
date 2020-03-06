//
//  CarTableViewCell.swift
//  awapp
//
//  Created by Putte on 2019-11-12.
//  Copyright © 2019 Putte. All rights reserved.
//

import UIKit

class CarTableViewCell: UITableViewCell {

    @IBOutlet weak var registrationPlate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
