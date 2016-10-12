//
//  Object.swift
//  Liquid
//
//  Created by Martin List on 25/09/2016.
//  Copyright © 2016 Martin List. All rights reserved.
//

import Foundation
import SpriteKit

enum ObjectType: Int, CustomStringConvertible {
    case Unkown = 0, NeoBlue, NeoGreen, NeoYellow, NeoPurple
    
    var spriteName: String {
        let spriteNames = [
            "NeoBubbleBlue",
            "NeoBubbleGreen",
            "NeoBubbleYellow",
            "NeoBubblePurple"]
        
        return spriteNames[rawValue - 1]
    }
    static func random() -> ObjectType {
        return ObjectType(rawValue: Int(arc4random_uniform(4)) + 1)!
    }
    var description: String {
        return spriteName
    }
    var highlightedSpriteName: String {
        return spriteName + "Selected"
    }
}

class Object: CustomStringConvertible, Hashable {
    var column: Int
    var row: Int
    var objectType: ObjectType
    var sprite: SKSpriteNode?
    var deleteStatus: Bool
    var description: String {
        return "type:\(objectType) position:(\(column),\(row))"
    }
    var hashValue: Int {
        return row*10 + column
    }
    
    init(column: Int, row: Int, objectType: ObjectType) {
        self.column = column
        self.row = row
        self.objectType = objectType
        self.deleteStatus = false
    }
}

func ==(lhs: Object, rhs: Object) -> Bool {
    return lhs.column == rhs.column && lhs.row == rhs.row
}
