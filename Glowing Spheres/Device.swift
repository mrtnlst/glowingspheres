//
//  Device.swift
//  Glowing Spheres
//
//  Created by Martin List on 21.01.24.
//  Copyright © 2024 Martin List. All rights reserved.
//

import Foundation

extension CGFloat {
    var isSmallDevice: Bool {
        self >= 320.0 && self < 375.0
    }

    var isMediumDevice: Bool {
        self >= 375.0 && self < 414.0
    }
    
    var isBigDevice: Bool {
        self >= 414.0
    }
}
