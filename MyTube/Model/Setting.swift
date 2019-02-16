//
//  Setting.swift
//  MyTube
//
//  Created by Charles Martin Reed on 2/14/19.
//  Copyright © 2019 Charles Martin Reed. All rights reserved.
//

import UIKit

struct Setting {
    let name: SettingName
    let imageName: String
    
    init(name: SettingName, imageName: String) {
        self.name = name
        self.imageName = imageName
    }
}

enum SettingName: String {
    case setting = "Settings"
    case privacy = "Terms and Privacy Policy"
    case feedback = "Send Feedback"
    case help = "Help"
    case switchAccount = "Switch Account"
    case cancel = "Cancel & Dismiss"
}
