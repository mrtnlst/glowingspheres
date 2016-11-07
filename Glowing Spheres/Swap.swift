//
//  Swap.swift
//  Glowing Spheres
//
//  Created by Martin List on 17/10/2016.
//  Copyright © 2016 Martin List. All rights reserved.
//

import Foundation

struct Swap: CustomStringConvertible {
    let objectA: Object
    let objectB: Object
    
    init(objectA: Object, objectB: Object) {
        self.objectA = objectA
        self.objectB = objectB
    }
    
    var description: String {
        return "swap \(objectA) with \(objectB)"
    }
}
