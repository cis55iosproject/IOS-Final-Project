//
//  TableViewCell.swift
//  ListViewApp_AndreZhu
//
//  Created by Andre  Zhu on 5/8/17.
//  Copyright © 2017 Andre  Zhu. All rights reserved.
//

import UIKit
import CoreData

class TableViewCell: UITableViewCell {

    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemText: UITextView!
    @IBOutlet weak var itemAuthor: UITextView!
    @IBOutlet weak var itemPrice: UITextView!
    
    let priceFormat = "$%.02f";
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func addPrice(newPrice: Double){
        let stringPrice = String(format: priceFormat, locale: Locale.current, arguments: [newPrice])
        itemPrice.text = stringPrice
    }
}
