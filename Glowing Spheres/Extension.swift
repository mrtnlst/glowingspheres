//
//  Extension.swift
//  Glowing Spheres
//
//  Created by Martin List on 30/09/2016.
//  Copyright © 2016 Martin List. All rights reserved.
//

import Foundation
import UIKit


// Extension for iPhone 6 screen size.
extension UIImage {
    convenience init?(fullscreenNamed name: String) {
        if UIScreen.main.bounds.size.height == 667 {
            self.init(named: "\(name)-667h")
        }
        else if UIScreen.main.bounds.size.height == 812 {
            self.init(named: "\(name)-812h")
        }
        else {
            self.init(named: name)
        }
    }
}
