//
//  SettingCellTableViewCell.swift
//  ListViewApp_AndreZhu
//
//  Created by Andre  Zhu on 6/15/17.
//  Copyright © 2017 Andre  Zhu. All rights reserved.
//

import UIKit

class SettingCell: UITableViewCell {

    
    @IBOutlet weak var title: UITextView!
    var index = -1
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
