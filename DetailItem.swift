//
//  DetailItem.swift
//  ListViewApp_AndreZhu
//
//  Created by Andre  Zhu on 6/20/17.
//  Copyright © 2017 Andre  Zhu. All rights reserved.
//

import UIKit

class DetailItem: NSObject {
    var title = ""
    var author = ""
    var rating = 0.0
    var price = 0.0
    var desc = ""
    var image = UIImage(named:"")
    
    init(itemTitle:String, itemDesc: String, itemImg: UIImage, itemAuthor: String, itemPrice: Double, itemRating: Double){
        self.title = itemTitle
        self.desc = itemDesc
        self.image = itemImg
        self.author = itemAuthor
        self.price = itemPrice
        self.rating = itemRating
    }
    
}
