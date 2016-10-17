//
//  GameViewController.swift
//  Glowing Spheres
//
//  Created by Martin List on 14/09/16.
//  Copyright © 2016 Martin List. All rights reserved.
//

import UIKit
import SpriteKit

let locale = Locale.current

class GameViewController: UIViewController {
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override var shouldAutorotate : Bool {
        return true
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.portrait, UIInterfaceOrientationMask.portraitUpsideDown]
    }
    
    var scene: GameScene!
    var field: Field!
    var score = 0
    var highscore = 0
    var tapGestureRecognizer: UITapGestureRecognizer!
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var highscoreLabel: UILabel!
    @IBOutlet weak var bonusLabel: UILabel!
    @IBOutlet weak var tapToContinueLabel: UILabel!
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var backToMenuButton: UIButton!
    @IBOutlet weak var gameOverPanel: UIImageView!
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        print(locale.languageCode)
        // Changing the style of the two buttons.
        if locale.languageCode == "de" {
            backToMenuButton.setImage(UIImage(named: "Back-de"), for: .normal)
            newGameButton.setImage(UIImage(named: "NewGame-de"), for: .normal)
            tapToContinueLabel.text = "tippen um fortzufahren"
        }
        else {
            backToMenuButton.setImage(UIImage(named: "Back"), for: .normal)
            newGameButton.setImage(UIImage(named: "NewGame"), for: .normal)
        }
        // Make sure the gameOverPanel is hidden.
        gameOverPanel.alpha = 0
        bonusLabel.alpha = 0
        tapToContinueLabel.alpha = 0
        
        //Configure the view.
        let skView = view as! SKView
        skView.isMultipleTouchEnabled = false
        
        // Create and configure the scene.
        scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .aspectFill
        
        // Present the scene.
        skView.presentScene(scene)
        
        // Creating the field and the scene.
        field = Field()
        scene.field = field
        
        // Connection between GameScene and GameViewController.
        scene.touchHandler = handleTouch
        scene.inputHandler = handleUserInput
        beginGame()
        
        // When coming back from background, restore any touch interaction, if touch was hold while entering background.
         NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.wakingUpFromBackground), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }
    
    func beginGame() {
        // Enable button and user input.
        scene.animateBeginGame {
            self.newGameButton.isUserInteractionEnabled = true
            self.view.isUserInteractionEnabled = true
            self.backToMenuButton.isUserInteractionEnabled = true
        }
        // Reset the score.
        score = 0
        
        // By default the bonusLabel is hidden.
        bonusLabel.isHidden = true

        // Recieve the highscore stored in UserDefaults.standard.
        let savedScore = UserDefaults.standard
        highscore = savedScore.integer(forKey: "Highscore")
        updateLabels()
        updateHighscoreLabel()
        
        // Begin generating the random objects.
        shuffle()
    }
    
    func shuffle() {
        // Remove old objects.
        scene.removeAllObjectSprites()
        
        // Add new objects.
        let newObjects = field.shuffle()
        scene.addSpritesForObjects(objects: newObjects)
    }
    
    // MARK: backButton Events.
    @IBAction func backButtonTouchDown(_ sender: AnyObject) {
        view.isUserInteractionEnabled = false
    }
    @IBAction func backButtonTouchUp(_ sender: AnyObject) {
        view.isUserInteractionEnabled = true
    }
    @IBAction func backButtonMoved(_ sender: AnyObject) {
        view.isUserInteractionEnabled = true
    }
    
    // MARK: NewGameButton Events.
    @IBAction func newGameButtonTouchMoved(_ sender: AnyObject) {
        view.isUserInteractionEnabled = true
    }

    @IBAction func newGameButtonPressedDown(_ sender: AnyObject) {
        view.isUserInteractionEnabled = false
          print("newGameButton TouchDown")
    }
    @IBAction func newGameButtonPressed(_ sender: AnyObject) {
        print("newGameButton TouchUp")
        
        // If touch was detected in GameScene, cancel loading a new game.
        if scene.gameSceneTouchDetected == false {
        
            // Disable input while animations.
            newGameButton.isUserInteractionEnabled = false
            view.isUserInteractionEnabled = false
        
            // If newGameButton was clicked, but a gameOverPanel is on the screen, it needs to be hidden first!
            if (tapGestureRecognizer != nil) {
                hideGameOver()
            }
            else {
                beginGame()
                }
            }
    }
    
    // MARK: Handeling Events.
    func handleUserInput(_ input: Bool){
        if input == true {
            newGameButton.isUserInteractionEnabled = false
        } else {
             newGameButton.isUserInteractionEnabled = true
        }
    }
    
    func handleTouch(_ object: Object){
       // Check if there are any matches.
        if field.detectMatches(object: object) {
            
            // If true, disable any user interaction.
            view.isUserInteractionEnabled = false
            
            // Calculate the score, based on deleteStateCount.
            print(field.deleteStateCount)
            score += field.calculateScore(count: field.deleteStateCount)
            updateLabels()
            
            // Add the with deleteStatus = true marked objects to an array.
            let matches = field.addToMatch()
            
            // Animate the matched objects, complete in handleMatch.
            scene.animateMatchedObjects(object: object, matches, completion: handleMatch)
            
            // Reset deleteStateCount.
            field.deleteStateCount = 0
            

        }
        else {
            // If detectMatches finds no matches, reset deleteStateCount and enable user interaction.
            print(field.deleteStateCount)
            field.deleteStateCount = 0
            view.isUserInteractionEnabled = true

        }
    }
    
    func handleMatch() {
        // Calculate the objects that have to move down, add them to an array and animate their sprites.
        let columns = field.fillHoles()
        scene.animateFallingObjects(columns) {
            
            // Doing the same for the movement of the column.
            let rows = self.field.fillColumns()
            self.scene.animateMovingColumns(rows) {
                
                // Check if there are any more moves to be made.
                if self.field.outOfMoves(){
                    print ("Game Over")
                 
                    // Emtpy field adds 100 extra points.
                    if self.field.emptyField() {
                        self.score += 300
                        self.updateLabels()
                        self.bonusLabel.isHidden = false
                    }
                    
                    // Check if there is a new highscore.
                    if self.score > self.highscore {
                        
                        // Show NewHighscore image.
                        if locale.languageCode == "de"{
                            self.gameOverPanel.image = UIImage(named: "NewHighscore-de")
                        }
                        else {
                            self.gameOverPanel.image = UIImage(named: "NewHighscore")
                        }
                        self.showGameOver()
                        
                        // Copy the new highscore.
                        self.highscore = self.score
                        self.updateHighscoreLabel()
                        
                        // Save the new highscore in UserDefaults.
                        let savedScore = UserDefaults.standard
                        savedScore.set(self.highscore, forKey: "Highscore")
                    } else {
                        
                        // If there is no new highscore, show OutOfMoves.
                        if locale.languageCode == "de"{
                            self.gameOverPanel.image = UIImage(named: "NoMoreMoves-de")
                        }
                        else {
                            self.gameOverPanel.image = UIImage(named: "NoMoreMoves")
                        }
                        self.showGameOver()
                    }
                }
                self.view.isUserInteractionEnabled = true
            }
        }
    }
    
    func updateLabels() {
        scoreLabel.text = String(format: "%ld", score)
    }
    func updateHighscoreLabel(){
        highscoreLabel.text = String(format: "%ld", highscore)
    }
    func showGameOver() {
        // Make sure userinteraction is disabled!
        self.newGameButton.isUserInteractionEnabled = false
        self.backToMenuButton.isUserInteractionEnabled = false
        view.isUserInteractionEnabled = false
        self.newGameButton.isHighlighted = true
        self.backToMenuButton.isHighlighted = true
        
        // If it is not hidden, the bonusLabel gets animated, too.
        UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: { self.gameOverPanel.alpha = 1.0})
        UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: { self.tapToContinueLabel.alpha = 1.0})
        UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: { self.bonusLabel.alpha = 1.0})

        // Animate gameOver (objects falling out of the screen).
        scene.animateGameOver() {
            
            // Wait for a tap to start a new game.
            self.tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.hideGameOver))
            self.view.addGestureRecognizer(self.tapGestureRecognizer)
            // If users tap, pressing newGameButton while animating, the field gets shifted.
            self.newGameButton.isUserInteractionEnabled = false
            }
        }
    func hideGameOver() {
        // Remove gestureRecognizer and hide gameOverPanel.
        view.removeGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer = nil
       
        //gameOverPanel.alpha = 1
        UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: { self.gameOverPanel.alpha = 0})
        UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: { self.tapToContinueLabel.alpha = 0})
        UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: { self.bonusLabel.alpha = 0})
        
        scene.gameSceneTouchDetected = false
        
        // Begin a new game.
        self.newGameButton.isHighlighted = false
        self.backToMenuButton.isHighlighted = false
        beginGame()
    }
    func wakingUpFromBackground(){
        view.isUserInteractionEnabled = true
        newGameButton.isUserInteractionEnabled = true
        backToMenuButton.isUserInteractionEnabled = true
        scene.isUserInteractionEnabled = true
    }
}
