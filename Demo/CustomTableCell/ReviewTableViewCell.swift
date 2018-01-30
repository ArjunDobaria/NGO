//
//  ReviewTableViewCell.swift
//  Demo
//
//  Created by lanet on 22/01/18.
//  Copyright © 2018 lanet. All rights reserved.
//

import UIKit
import HCSStarRatingView

class ReviewTableViewCell: UITableViewCell {

    @IBOutlet weak var timelbl: UILabel!
    @IBOutlet weak var datelbl: UILabel!
    @IBOutlet weak var usernamelbl: UILabel!
    @IBOutlet weak var rating: HCSStarRatingView!
    @IBOutlet weak var reviewlbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
