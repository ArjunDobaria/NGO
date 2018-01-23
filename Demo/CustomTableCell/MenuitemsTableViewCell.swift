//
//  MenuitemsTableViewCell.swift
//  Demo
//
//  Created by lanet on 18/01/18.
//  Copyright © 2018 lanet. All rights reserved.
//

import UIKit

class MenuitemsTableViewCell: UITableViewCell {

    @IBOutlet weak var itemimg: UIImageView!
    @IBOutlet weak var itemname: UILabel!
    @IBOutlet weak var itemmoney: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
