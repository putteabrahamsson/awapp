//
//  ProfileTableViewCell.swift
//  awapp
//
//  Created by Putte on 2019-11-12.
//  Copyright © 2019 Putte. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var buttonName: UILabel!
    @IBOutlet weak var buttonImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
