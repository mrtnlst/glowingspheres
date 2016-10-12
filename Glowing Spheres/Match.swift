//
//  Match.swift
//  Liquid
//
//  Created by Martin List on 21/09/2016.
//  Copyright © 2016 Martin List. All rights reserved.
//

import Foundation

class Match: Hashable {
    // The objects that are part of this match.
    var objects = [Object]()

    func addObject(_ object: Object) {
        objects.append(object)
    }

    var hashValue: Int {
        return objects.reduce (0) { $0.hashValue ^ $1.hashValue }
    }
    var length: Int {
        return objects.count
    }
    
}

func ==(lhs: Match, rhs: Match) -> Bool {
    return lhs.objects == rhs.objects
}
