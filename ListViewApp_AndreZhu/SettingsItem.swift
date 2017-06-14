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
    
    init(settingsOptions: [String], settingsType: String){
        self.optionsList = settingsOptions
        self.type = settingsType
    }
}
