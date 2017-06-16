//
//  SettingsItem.swift
//  ListViewApp_AndreZhu
//
//  Created by Andre  Zhu on 6/13/17.
//  Copyright © 2017 Andre  Zhu. All rights reserved.
//

import UIKit

class SettingsItem: NSObject {
    var optionsList = [String]()
    var type = ""
    var title = ""
    var sectionTitles = [""]
    
    init(settingsOptions: [String], settingsType: String, settingsTitle: String, secTitles: [String]){
        self.optionsList = settingsOptions
        self.type = settingsType
        self.title = settingsTitle
        self.sectionTitles = secTitles
    }
}
