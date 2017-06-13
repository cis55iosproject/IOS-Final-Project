//
//  ToDoItem.swift
//  ListViewApp_AndreZhu
//
//  Created by Andre  Zhu on 5/31/17.
//  Copyright © 2017 Andre  Zhu. All rights reserved.
//

import UIKit
import CoreData

class ToDoItem: NSObject {
    var title = ""
    var desc = ""
    var image = UIImage(named:"")
    var link = "";
    
    init(itemTitle:String, itemDesc: String, itemImg: UIImage, itemLink: String){
        self.title = itemTitle
        self.desc = itemDesc
        self.image = itemImg
        //IMDB link
        self.link = itemLink
    }

}
