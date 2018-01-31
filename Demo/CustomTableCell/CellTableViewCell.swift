//
//  CellTableViewCell.swift
//  Demo
//
//  Created by lanet on 31/01/18.
//  Copyright © 2018 lanet. All rights reserved.
//

import UIKit

class CellTableViewCell: UITableViewCell {

    @IBOutlet weak var textlabel1: UILabel!
    @IBOutlet weak var textlabel2: UILabel!
    @IBOutlet weak var textlabel3: UILabel!
    @IBOutlet weak var textlabel4: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
