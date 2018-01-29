//
//  HomeTableViewCell.swift
//  Demo
//
//  Created by lanet on 17/01/18.
//  Copyright © 2018 lanet. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var copntainnerview: UIView!
    
    @IBOutlet weak var bannerImg: UIImageView!
    @IBOutlet weak var shadowImg: UIImageView!
    
    @IBOutlet weak var titlelbl: UILabel!
    @IBOutlet weak var subtitle1lbl: UILabel!
    @IBOutlet weak var subtitle2lbl: UILabel!
    
    @IBOutlet weak var imgsubtitle1img: UIImageView!
    @IBOutlet weak var imgsubtitle2img: UIImageView!
    
    @IBOutlet weak var navigationmapbtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        copntainnerview.layer.cornerRadius = 20
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}


