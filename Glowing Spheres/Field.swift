//
//  Field.swift
//  Liquid
//
//  Created by Martin List on 16/09/16.
//  Copyright © 2016 Martin List. All rights reserved.
//

import Foundation
import SpriteKit

let NumColumns = 7
let NumRows = 10

class Field {
    var objects = Array2D<Object>(columns: NumColumns, rows: NumRows)
    var deleteStateCount: Int = 0

    func objectAtColumn(column: Int, row: Int) -> Object? {
        // Verify if row or/and column number is valid.
        assert(column >= 0 && column < NumColumns)
        assert(row >= 0 && row < NumRows)
        return objects[column, row]
    }
    
    func objectTypeAtColumn(column: Int, row: Int) -> ObjectType?{
        assert(column >= 0 && column < NumColumns)
        assert(row >= 0 && row < NumRows)
        return objects[column, row]?.objectType
    }
    
    func shuffle() -> Set<Object> {
        return createInitialObjects()
    }
    
    private func createInitialObjects() -> Set<Object> {
        var set = Set<Object>()
        
        // 1: Looping through rows and columns.
        for row in 0..<NumRows {
            for column in 0..<NumColumns {
                
                // 2: Pick a random objecttype!
                let objectType = ObjectType.random()
                
                // 3: Adding a new object object to the Array.
                let object = Object(column: column, row: row, objectType: objectType)
                objects[column, row] = object
                
                // 4: Add the new object to a set.
                set.insert(object)
            }
        }
        return set
    }
// This function is called by handleTouch, to check if there are any objects with the same type around the first.
    func detectMatches(object: Object) -> Bool {
        
        // deleteStateCount counts how many matches are found.
        // All matched objects are marked with deleteStatus = true
        deleteStateCount += 1
        objects[object.column, object.row]?.deleteStatus = true

        // These functions check in all direction for objects with the same type.
        checkForMatch(column: object.column, row: object.row + 1, type: object.objectType.rawValue)
        checkForMatch(column: object.column, row: object.row - 1, type: object.objectType.rawValue)
        checkForMatch(column: object.column + 1, row: object.row, type: object.objectType.rawValue)
        checkForMatch(column: object.column - 1, row: object.row, type: object.objectType.rawValue)

        // If there are no matches, make sure that deleteStatus is back on false.
        if deleteStateCount == 1 {
            objects[object.column, object.row]?.deleteStatus = false
            return false
        }
        else {
            return true
        }
    }
    func checkForMatch(column: Int, row: Int, type: Int){
            if (column > NumColumns-1) || (row>NumRows-1) || (column < 0) || (row<0) {
                return
            }
        if ((objects[column, row]?.objectType.rawValue == type) && objects[column, row]?.deleteStatus == false) {
            deleteStateCount += 1
            objects[column, row]?.deleteStatus = true

            checkForMatch(column: column, row: row + 1, type: type)
            checkForMatch(column: column, row: row - 1, type: type)
            checkForMatch(column: column + 1, row: row, type: type)
            checkForMatch(column: column - 1, row: row, type: type)
        }
        else {
            return
        }
    }

    func addToMatch() -> Set<Match> {
        var set = Set<Match>()
        let match = Match()
        for row in 0..<NumRows{
            for column in 0..<NumColumns {
                if objects[column, row]?.deleteStatus == true {
                    match.addObject(objects[column, row]!)
                    print("I'm a Match!")
                    objects[column, row]?.deleteStatus = false
                    objects[column, row] = nil
                }
            }
        }
        set.insert(match)
        return set
    }
    
    func fillHoles() -> [[Object]] {
        var columns = [[Object]]()  // We create an empty array, where we put all the moved objects in.
        
        // We loop from bottom to the top.
        for column in 0..<NumColumns {
            var array = [Object]()
            for row in 0..<NumRows {
                
                // We found an empty tile!
               if objects[column, row] == nil {
                    
                    // We scan upward, to look if there is a object.
                    for lookup in (row + 1)..<NumRows {
                        if let object = objects[column, lookup] {
                            // We swap the object with the empty hole.
                            objects[column, lookup] = nil
                            objects[column, row] = object
                            object.row = row
                            
                            array.append(object)
                            break
                        }
                    }
                }
            }
            
            if !array.isEmpty {
                columns.append(array)
            }
        }
        return columns
    }
    func fillColumns() ->[[Object]] {
        var rows = [[Object]]()
        var columnCount = 0

        for column in (0..<NumColumns).reversed(){
            var array = [Object]()
            if objects[column, 0] == nil {
                for lookUpColumn in (0..<(column)).reversed() {
                    if objects[lookUpColumn, 0] != nil {
                        for row in 0..<NumRows {
                            if let object = objects[lookUpColumn, row] {
                                if columnCount > 0 {
                                    objects[lookUpColumn, row] = nil
                                    objects[column + columnCount, row] = object
                                    object.column = column + columnCount
                                    
                                    array.append(object)
                                } else {
                                objects[lookUpColumn, row] = nil
                                objects[column, row] = object
                                object.column = column
                        
                                array.append(object)
                                }
                            }
                        }
                    }
                    else {
                        columnCount += 1
                    }
                    
                    break
                    
                    }
                }
        if !array.isEmpty {
            rows.append(array)
            }
        }
        return rows
    }
    func calculateScore (count: Int!) -> Int! {
        if count == 1{
            return 0
        }
        else {
        return count*(count-1)
        }
    }
    
    func outOfMoves() -> Bool {
        
        // Scanning through grid from the bottom right.
        for column in (1..<NumColumns).reversed(){
            for row in (0..<(NumRows - 1)) {
                let type = objects[column, row]?.objectType.rawValue
                
                // Check the object above or or left exists and has the same type.
                if (objects[column - 1, row]?.objectType.rawValue == type) && (objects[column - 1, row] != nil){
                    return false
                }
                if (objects[column, row + 1]?.objectType.rawValue == type) && (objects[column, row + 1] != nil){
                    return false
                }

            }
        }
        return true
    }
    
    func emptyField() -> Bool {
        if objects[NumColumns - 1, 0] == nil {
           return true
        }
        return false
    }
}
