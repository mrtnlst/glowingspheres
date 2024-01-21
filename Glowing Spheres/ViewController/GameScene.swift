//
//  GameScene.swift
//  Glowing Spheres
//
//  Created by Martin List on 14/09/16.
//  Copyright © 2016 Martin List. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

let screenSize = UIScreen.main.bounds.height

class GameScene: SKScene {
    private var touchInColumn: Int?
    private var touchInRow: Int?
    private var checkSelectionSprite: Bool?
    var field: Field!
   
    // Set TileWidth and TileHight.
    
    var TileWidth: CGFloat = 40.0
    var TileHeight: CGFloat = 40.0
    
    // Set the game and objects layer.
    let gameLayer = SKNode()
    let objectsLayer = SKNode()
    
    // Sprite image for higlighted object.
    var selectionSprite = SKSpriteNode()
    
    // Preload sound effect for match.

    let savedSoundsSetting = UserDefaults.standard
    var playSoundsSwitchOn : Bool = false
    
    // The touchHandler connect GameViewController with GameScene.
    // It is called when a object is touched and transfers object Information to handleTouch in GameViewController.
    var touchHandler: ((Object) -> ())?

    // Managing swaps. 3 swaps per game are allowed.
    var availableSwaps = 3
    var swipeHandler: ((Swap) -> ())?
    
    // The inputHandler allows to disable input from newGameButton in the GameViewController.
    var inputHandler: ((Bool) -> ())?
    
    // To check, whether a touch in touchesBegan is detected.
    var gameSceneTouchDetected: Bool = false


// MARK: INITIALISING THE GAME
    
    override init(size: CGSize) {
        super.init(size: size)
        
        // Different screen size, different tile size
        switch screenSize {
        case 736, 896:
            TileWidth = 50.0
            TileHeight = 50.0
        case 667, 812:
            TileWidth = 45.0
            TileHeight = 45.0
        default:
            TileWidth = 40.0
            TileHeight = 40.0
        }
        
        anchorPoint = CGPoint(x: 0.5, y: 0.4)
        backgroundColor = SKColor.black

        
        addChild(gameLayer)
        let layerPosition = CGPoint(
            x: -TileWidth * CGFloat(NumColumns) / 2,
            y: -TileHeight * CGFloat(NumRows) / 2)
        
        objectsLayer.position = layerPosition
        gameLayer.addChild(objectsLayer)
        
        touchInRow = nil
        touchInColumn = nil
        checkSelectionSprite = nil
      
        let _ = SKLabelNode(fontNamed: "Futura-CondensedExtraBold")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) is not used in this app")
    }

   // Adding sprite image to the objects.
    func addSpritesForObjects(objects: Set<Object>) {
        for object in objects {
            let sprite = SKSpriteNode(imageNamed: object.objectType.spriteName)
            sprite.size = CGSize(width: TileWidth, height: TileHeight)
            sprite.position = pointForColumn(column: object.column, row:object.row)
            objectsLayer.addChild(sprite)
            object.sprite = sprite
            
            sprite.alpha = 0
            sprite.xScale = 0.5
            sprite.yScale = 0.5
            sprite.run(
                SKAction.sequence([
                    SKAction.wait(forDuration: 0.25, withRange: 0.5),
                    SKAction.group([
                        SKAction.fadeIn(withDuration: 0.25),
                        SKAction.scale(to: 1.0, duration: 0.25)
                        ])
                    ]))
        }
        // Check for the userDefault setting of sounds.
        if savedSoundsSetting.value(forKey: "savedSoundsSetting") != nil{
            playSoundsSwitchOn = savedSoundsSetting.value(forKey: "savedSoundsSetting")  as! Bool
        } else {
            // If there is no defaultUser setting available, set it true.
            playSoundsSwitchOn = true
        }
    }
    // Convert row and column number into a CGPoint for objectsLayer.
    func pointForColumn(column: Int, row: Int) -> CGPoint {
        return CGPoint(
            x: CGFloat(column)*TileWidth + TileWidth/2,
            y: CGFloat(row)*TileHeight + TileHeight/2)
    }
 
    // Doing the same vice versa.
    func convertPoint(point: CGPoint) -> (success: Bool, column: Int, row: Int) {
        if point.x >= 0 && point.x < CGFloat(NumColumns)*TileWidth &&
            point.y >= 0 && point.y < CGFloat(NumRows)*TileHeight {
            return (true, Int(point.x / TileWidth), Int(point.y / TileHeight))
        } else {
            return (false, 0, 0)  // invalid location
        }
    }

// MARK: TOUCH INTERACTIONS
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touchesBegan")
        
        // Allow GameViewController to check whether touchBegan is active.
        gameSceneTouchDetected = true
        guard let touch = touches.first else { return }
        // Convert the touch location to a point relative to the objectsLayer.
        let location = touch.location(in: objectsLayer)
        let (success, column, row) = convertPoint(point: location)
        if success {
            
            // Save row and column to remember, which object is selected. Use it later for to check where touch ended.
            touchInColumn = column
            touchInRow = row
            // If the touch is on a object, show that it was selected!
            if let object = field.objectAtColumn(column: column, row: row) {
                showSelectionIndicatorForObject(object)
                checkSelectionSprite = true
                
            }

        }
    }
    
     override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touchesEnded")

        // Converts touched point to a location relative to objectsLayer.
        guard let touch = touches.first else { return }
        let location = touch.location(in: objectsLayer)
        
        // Convert point, if it's inside the object grid to column and row.
        let (success, column, row) = convertPoint(point: location)
        if success {
            
            // Check, if there is a object inside the location.
            if field.objectAtColumn(column: column, row: row) != nil{
                
                // Check if object touch ended at the same position, where it began.
                // Otherwise you can tap on an object, swipe and release on a different object.
                if column == touchInColumn && row == touchInRow {
                    print(field.objects[column, row]?.description as Any)
                    if let handler = touchHandler {
                        let object = field.objects[column, row]
                        handler(object!)
                        }
                    }
                }
            }
        
        // No matter, where the touch ended, if it began on an object, it's indicator must be removed.
        // Using a completion handler to make sure, while hiding no userInteraction is enabled.
        // checkSelectionSprite checks if the user touched inside an empty tile.
        if checkSelectionSprite == true {
            hideSelectionIndicator(completion: enableUserInteraction)
            checkSelectionSprite = false
        } 
        gameSceneTouchDetected = false
        touchInRow = nil
        touchInColumn = nil
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if availableSwaps > 0 {
        // 1
        guard touchInColumn != nil else { return }
        
        // 2
        guard let touch = touches.first else { return }
        let location = touch.location(in: objectsLayer)
        
        let (success, column, row) = convertPoint(point: location)
        if success {
            
            // 3
            var horzDelta = 0, vertDelta = 0
            if column < touchInColumn! {          // swipe left
                horzDelta = -1
            } else if column > touchInColumn! {   // swipe right
                horzDelta = 1
            } else if row < touchInRow! {         // swipe down
                vertDelta = -1
            } else if row > touchInRow! {         // swipe up
                vertDelta = 1
            }
            
            // 4
            if horzDelta != 0 || vertDelta != 0 {
                trySwap(horizontal: horzDelta, vertical: vertDelta)
                
                // 5
                touchInColumn = nil
                }
            }
        }
    }

// MARK: OBJECT ANIMATIONS
    
    func animateMatchedObjects(object: Object, _ matches: Set<Match>, completion: @escaping () -> ()){
        for match in matches {
            animateScoreForMatch(object: object)
            for object in match.objects
            {
                if let sprite = object.sprite {
                    if sprite.action(forKey: "removing") == nil {
                        let scaleAction = SKAction.scale(to: 0.1, duration: 0.3)
                        scaleAction.timingMode = .easeOut
                        sprite.run(SKAction.sequence([scaleAction, SKAction.removeFromParent()]), withKey:"removing")
                    }
                }
            }
        }
        if playSoundsSwitchOn {
            playSoundeffect()
        }
        run(SKAction.wait(forDuration: 0.3), completion: completion)
    }
    
    func animateFallingObjects(_ columns: [[Object]], completion: @escaping () -> ()){
        var longestDuration: TimeInterval = 0
        for array in columns {
            for (idx, object) in array.enumerated() {
                let newPosition = pointForColumn(column: object.column, row: object.row)
                
                // Calculating the duration. If the hole between the objects is large, the delay must be longer.
                let delay = 0.05 + 0.0*TimeInterval(idx)
                
                let sprite = object.sprite! // Sprites always exits at this moment

                let duration = TimeInterval(((sprite.position.y - newPosition.y) / TileHeight) * 0.1)
                longestDuration = max(longestDuration, duration + delay)
                
                let moveAction = SKAction.move(to: newPosition, duration: duration)
                moveAction.timingMode = .easeOut
                sprite.run(
                    SKAction.sequence([
                        SKAction.wait(forDuration: delay), SKAction.group([moveAction])]))
            }
        }
        
        // Wait until all the objects have fallen down before we continue.
        run(SKAction.wait(forDuration: longestDuration), completion: completion)
    }
    
    func animateMovingColumns(_ rows: [[Object]], completion: @escaping () -> ()) {
        
        var longestDuration: TimeInterval = 0
        for array in rows {
            for (idx, object) in array.enumerated() {
                let newPosition = pointForColumn(column: object.column, row: object.row)
                
                // Calculating the duration. If the hole between the objects is large, the delay must be longer.
                let delay = 0.05 + 0.0*TimeInterval(idx)
                
                let sprite = object.sprite! // Sprites always exits at this moment
                
                let duration = TimeInterval(((sprite.position.x + newPosition.x) / TileWidth) * 0.05)
                longestDuration = max(longestDuration, duration + delay)
                
                let moveAction = SKAction.move(to: newPosition, duration: duration)
                moveAction.timingMode = .easeOut
                sprite.run(
                    SKAction.sequence([
                        SKAction.wait(forDuration: delay), SKAction.group([moveAction])]))
            }
        }
        
        // Wait until all the objects have fallen down before we continue.
        run(SKAction.wait(forDuration: longestDuration), completion: completion)
    }
    
    func animateScoreForMatch(object: Object) {
        // Figure out what the position.
        var centerPosition = pointForColumn(column: object.column, row: object.row)
        
        // Add a label for the score that slowly floats up.
        let scoreLabel = SKLabelNode(fontNamed: "Futura-CondensedExtraBold")
        scoreLabel.fontSize = 16
        scoreLabel.text = String(format: "%ld", field.calculateScore(count: field.deleteStateCount))
        scoreLabel.position = centerPosition
        scoreLabel.zPosition = 300
        objectsLayer.addChild(scoreLabel)
        
        let moveAction = SKAction.move(by: CGVector(dx: 0, dy: 3), duration: 0.7)
        moveAction.timingMode = .easeOut
        scoreLabel.run(SKAction.sequence([moveAction, SKAction.removeFromParent()]))
        
        if field.deleteStateCount > 6
        {
            let swapLabel = SKLabelNode(fontNamed: "Futura-CondensedExtraBold")
            centerPosition.y -= 20
            swapLabel.fontSize = 16
            if field.deleteStateCount > 18 {
                swapLabel.text = String(format: "+ 2 Swap")
            }
            else {
                swapLabel.text = String(format: "+ 1 Swap")
            }
            swapLabel.position = centerPosition
            swapLabel.zPosition = 300
            swapLabel.fontColor = UIColor.white //(red:0.00, green:1.00, blue:1.00, alpha:1.0)
            objectsLayer.addChild(swapLabel)
            
            let moveAction = SKAction.move(by: CGVector(dx: 0, dy: 3), duration: 0.7)
            moveAction.timingMode = .easeOut
            swapLabel.run(SKAction.sequence([moveAction, SKAction.removeFromParent()]))
        }
    }

    
    func animateGameOver(completion: @escaping () -> ()) {
        let action = SKAction.move(by: CGVector(dx: 0, dy: -size.height), duration: 0.5)
        action.timingMode = .easeIn
        gameLayer.run(action, completion: completion)
    }
    
    func animateBeginGame(completion: @escaping () -> ()) {
        gameLayer.isHidden = false
        gameLayer.position = CGPoint(x: 0, y: size.height)
        let action = SKAction.move(by: CGVector(dx: 0, dy: -size.height), duration: 0.5)
        action.timingMode = .easeOut
        gameLayer.run(action, completion: completion)
    }

// MARK: SELECTION INDICATION
    func showSelectionIndicatorForObject(_ object: Object) {
        // Disabling the user input in GameScene and GameViewController.
        isUserInteractionEnabled = false
        if let status = inputHandler {
            status(true)
        }
        
        // If there is still an selectionSprite, delete it!
        if selectionSprite.parent != nil {
            selectionSprite.removeFromParent()
        }
        
        if let sprite = object.sprite {
            let texture = SKTexture(imageNamed: object.objectType.highlightedSpriteName)
            selectionSprite.size = CGSize(width: TileWidth, height: TileHeight)
            selectionSprite.run(SKAction.setTexture(texture))
            
            sprite.addChild(selectionSprite)
            selectionSprite.alpha = 1.0
        
        }
    }
    
    func hideSelectionIndicator(completion: @escaping () -> () ) {
        // Hiding the selectionSprite with a fade-out effect.
        selectionSprite.run(SKAction.sequence([
            SKAction.fadeOut(withDuration: 0.3),
            SKAction.removeFromParent()]), completion: completion)
    }
    
    func removeAllObjectSprites() {
        objectsLayer.removeAllChildren()
    }
    
    func enableUserInteraction(){
        // Enable the user input in GameScene and GameViewController.
        isUserInteractionEnabled = true
        if let status = inputHandler {
            status(false)
        }
    }

    func playSoundeffect() {
        AudioPlayer.main.playSoundEffect()
    }

    func trySwap(horizontal horzDelta: Int, vertical vertDelta: Int) {
        // 1
        let toColumn = touchInColumn! + horzDelta
        let toRow = touchInRow! + vertDelta
        // 2
        guard toColumn >= 0 && toColumn < NumColumns else { return }
        guard toRow >= 0 && toRow < NumRows else { return }
        // 3
        if let toObject = field.objectAtColumn(column: toColumn, row: toRow),
            let fromObject = field.objectAtColumn(column: touchInColumn!, row: touchInRow!) {
            // 4
            print("*** swapping \(fromObject) with \(toObject)")
            if let handler = swipeHandler {
                let swap = Swap(objectA: fromObject, objectB: toObject)
                handler(swap)
            }
        }
    }
    func animate(_ swap: Swap, completion: @escaping () -> ()) {
        let spriteA = swap.objectA.sprite!
        let spriteB = swap.objectB.sprite!
        
        spriteA.zPosition = 100
        spriteB.zPosition = 90
        
        let duration: TimeInterval = 0.3
        
        let moveA = SKAction.move(to: spriteB.position, duration: duration)
        moveA.timingMode = .easeOut
        spriteA.run(moveA, completion: completion)
        
        let moveB = SKAction.move(to: spriteA.position, duration: duration)
        moveB.timingMode = .easeOut
        spriteB.run(moveB)
    }
}



