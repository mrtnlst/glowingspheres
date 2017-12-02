//
//  GameViewController.swift
//  Glowing Spheres
//
//  Created by Martin List on 14/09/16.
//  Copyright © 2016 Martin List. All rights reserved.
//

import UIKit
import SpriteKit

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
    
    var totalCount = 0
    var highestCombo = 0
    var gamesPlayed = 0
    var swapsPerGame = 0
    var perfectGame = 0
    
    var highscoreThresh = 1500
    var comboThresh = 810
    var swapsThresh = 4
    var perfectGamesThresh = 30
    var spheresTotalThresh = 10000
    var totalGamesThresh = 100
    
    
    @IBOutlet weak var swapBonusLabel: UILabel!
    @IBOutlet weak var swapLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var highscoreLabel: UILabel!
    @IBOutlet weak var bonusLabel: UILabel!
    @IBOutlet weak var tapToContinueLabel: UILabel!
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var backToMenuButton: UIButton!
    @IBOutlet weak var gameOverPanel: UIImageView!
    @IBOutlet weak var achievementUnlockedLabel: UILabel!
    @IBOutlet weak var scoreHeaderLabel: UIImageView!
    @IBOutlet weak var highscoreHeaderLabel: UIImageView!
    @IBOutlet weak var swapsHeaderLabel: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Changing the style of the two buttons.
        backToMenuButton.setImage(UIImage(named: "Quit"), for: .normal)
        newGameButton.setImage(UIImage(named: "NewGame"), for: .normal)
        self.swapsHeaderLabel.image = UIImage(fullscreenNamed: "Swap")
        self.highscoreHeaderLabel.image = UIImage(fullscreenNamed: "Highscore")
        self.scoreHeaderLabel.image = UIImage(fullscreenNamed: "Score")
        
        // Make sure the gameOverPanel is hidden.
        gameOverPanel.alpha = 0
        bonusLabel.alpha = 0
        tapToContinueLabel.alpha = 0
        swapBonusLabel.alpha = 0
        achievementUnlockedLabel.alpha = 0
        
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
        scene.swipeHandler = handleSwipe
        
        if (self.view.frame.size.width == 320){
            //iPhone 2G, 3G, 3GS, 4, 4s, 5, 5s, 5c
            scoreLabel.font = UIFont(name: "Futura-Bold", size: 16)
            swapLabel.font = UIFont(name: "Futura-Bold", size: 16)
            highscoreLabel.font = UIFont(name: "Futura-Bold", size: 16)
        }
        else if (self.view.frame.size.width == 375){
            //iPhone 6
            scoreLabel.font = UIFont(name: "Futura-Bold", size: 18)
            swapLabel.font = UIFont(name: "Futura-Bold", size: 18)
            highscoreLabel.font = UIFont(name: "Futura-Bold", size: 18)
        }
        else if (self.view.frame.size.width == 414){
            //iPhone 6 Plus
            scoreLabel.font = UIFont(name: "Futura-Bold", size: 20)
            swapLabel.font = UIFont(name: "Futura-Bold", size: 20)
            highscoreLabel.font = UIFont(name: "Futura-Bold", size: 20)
        }
        UserDefaults.standard.register(defaults: ["Highscore-Achievement" : false])
        UserDefaults.standard.register(defaults: ["Combo-Achievement" : false])
        UserDefaults.standard.register(defaults: ["Swaps-Achievement" : false])
        UserDefaults.standard.register(defaults: ["Spheres-Achievement" : false])
        UserDefaults.standard.register(defaults: ["Games-Achievement" : false])
        UserDefaults.standard.register(defaults: ["Perfect-Achievement" : false])
        
        UserDefaults.standard.register(defaults: ["Highscore" : 0])
        UserDefaults.standard.register(defaults: ["PerfectGames" : 0])
        UserDefaults.standard.register(defaults: ["TotalCount" : 0])
        UserDefaults.standard.register(defaults: ["HighestCombo" : 0])
        UserDefaults.standard.register(defaults: ["GamesPlayed" : 0])
        UserDefaults.standard.register(defaults: ["SwapsPerGame" : false])

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
        // Reset the variables.
        score = 0
        scene.availableSwaps = 3
        swapsPerGame = 0
        
        // By default the bonusLabel, swapBonusLabel and achievementLabel are hidden.
        bonusLabel.isHidden = true
        swapBonusLabel.isHidden = true
        achievementUnlockedLabel.isHidden = true
        

        // Receive total games played.
        let perfectGames = UserDefaults.standard
        perfectGame = perfectGames.integer(forKey: "PerfectGames")
        
        // Receive total games played.
        let totalGamesPlayed = UserDefaults.standard
        gamesPlayed = totalGamesPlayed.integer(forKey: "GamesPlayed")
        
        // Receive total count.
        let totalSavedCount = UserDefaults.standard
        totalCount = totalSavedCount.integer(forKey: "TotalCount")
        
        // Receive highest combo.
        let highestComboSaved = UserDefaults.standard
        highestCombo = highestComboSaved.integer(forKey: "HighestCombo")
                
        // Receive the highscore stored in UserDefaults.standard.
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
        
        // Check, wether there is a game in proggress or not. If yes, ask if the player wants to quit it.
        if score != 0 {
            var title: String
            var message: String
        
            title = "Quit this game?"
            message = "You will lose your current score!"
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
            // Actions for alertbox.
            alert.addAction(UIAlertAction(title: "Ok", style: .default) { action in
                self.performSegue(withIdentifier: "continue", sender: nil)
            })
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
            self.present(alert, animated: true, completion: nil)
            }
            else {
                performSegue(withIdentifier: "continue", sender: nil)
            }
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
    func handleSwipe(swap: Swap) {
        view.isUserInteractionEnabled = false
        
        field.performSwap(swap: swap)
        scene.availableSwaps -= 1
        updateLabels()
        let swapsAvailable = scene.availableSwaps

        scene.animate(swap) {
            // Whether the user made his last swap, if true end the game.
            if swapsAvailable < 1 {
                // Check if there are any more moves to be made.
                if self.field.outOfSameColors(){
                    print ("Game Over")
                
                    // Emtpy field adds extra points.
                    if self.field.emptyField() {
                        self.score += 300
                        self.updateLabels()
                        self.bonusLabel.isHidden = false
                    }
                
                    // Check if there is a new highscore.
                    if self.score > self.highscore {
                        
                        // Show NewHighscore image.
                        self.gameOverPanel.image = UIImage(named: "NewHighscore")
                        self.showGameOver()
                        
                        // Copy the new highscore.
                        self.highscore = self.score
                        self.updateHighscoreLabel()
                        
                        // Save the new highscore in UserDefaults.
                        let savedScore = UserDefaults.standard
                        savedScore.set(self.highscore, forKey: "Highscore")
                    }
                    else {
                        // If there is no new highscore, show OutOfMoves.
                        self.gameOverPanel.image = UIImage(named: "NoMoreMoves")
                        self.showGameOver()
                    }
                }
            }
            self.view.isUserInteractionEnabled = true
        }
    }

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
            
            // Save the totalCount of spheres.
            print(field.deleteStateCount)
            totalCount += field.deleteStateCount
            
            var savedScore = UserDefaults.standard
            savedScore.set(self.totalCount, forKey: "TotalCount")
            print("\nTotal Count:" , totalCount)
            score += field.calculateScore(count: field.deleteStateCount)
            
            let checkCombo = field.calculateScore(count: field.deleteStateCount)
            if checkCombo! > highestCombo{
                highestCombo = checkCombo!
                savedScore = UserDefaults.standard
                savedScore.set(self.highestCombo, forKey: "HighestCombo")
            }
            
            // Calculate the score, based on deleteStateCount.
            if field.deleteStateCount > 6 {
                if field.deleteStateCount > 18 {
                    scene.availableSwaps += 2
                    self.swapsPerGame += 2
                } else {
                scene.availableSwaps += 1
                self.swapsPerGame += 1
                }
            }
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
        let swapsAvailable = scene.availableSwaps
        let columns = field.fillHoles()
        scene.animateFallingObjects(columns) {
            
            // Doing the same for the movement of the column.
            let rows = self.field.fillColumns()
            self.scene.animateMovingColumns(rows) {
                
                if swapsAvailable < 1 {
                // Check if there are any more moves to be made.
                    if self.field.outOfSameColors(){
                        
                        // Achievement calculating.
                        self.gamesPlayed += 1
                        print ("Game Over\nGames played:", self.gamesPlayed)

                        let totalGamesPlayed = UserDefaults.standard
                        totalGamesPlayed.set(self.gamesPlayed, forKey: "GamesPlayed")
                        
                        if self.swapsPerGame > self.swapsThresh {
                            let swapAchievement = true
                            let swapsPerGameEarned = UserDefaults.standard
                            swapsPerGameEarned.set(swapAchievement, forKey: "SwapsPerGame")
                            print ("Swaps achievement:", swapAchievement)
                        }
                        
                        // Emtpy field adds extra points.
                        if self.field.emptyField() {
                            self.score += 300
                            self.updateLabels()
                            self.bonusLabel.isHidden = false
                            
                            // Set total games played.
                            self.perfectGame += 1
                            let perfectGames = UserDefaults.standard
                            perfectGames.set(self.perfectGame, forKey: "PerfectGames")
                            print ("Perfect Games played:", self.perfectGame)
                        }
                        
                        // Check if there is a new highscore.
                        if self.score > self.highscore {
                            
                            // Copy the new highscore.
                            self.highscore = self.score
                            self.updateHighscoreLabel()
                            
                            // Save the new highscore in UserDefaults.
                            let savedScore = UserDefaults.standard
                            savedScore.set(self.highscore, forKey: "Highscore")
                            
                            // Check whether an achievement was unlocked!
                            if self.checkAchievementUnlocked(){
                                self.achievementUnlockedLabel.isHidden = false
                            }
                            
                            // Show NewHighscore image.
                            self.gameOverPanel.image = UIImage(named: "NewHighscore")
                            self.showGameOver()
                           
                        }
                        else {
                            // Check whether an achievement was unlocked!
                            if self.checkAchievementUnlocked(){
                                self.achievementUnlockedLabel.isHidden = false
                            }
                            
                            // If there is no new highscore, show OutOfMoves.
                            self.gameOverPanel.image = UIImage(named: "NoMoreMoves")
                            self.showGameOver()
                        }
                    }
                }
                else {
                    // Check whether you are able to swap and make a combination.
                    if self.field.outOfMoves(availableSwaps: swapsAvailable) == true {
                        self.gamesPlayed += 1
                        print ("Game Over\nGames played:", self.gamesPlayed)
                        
                        let totalGamesPlayed = UserDefaults.standard
                        totalGamesPlayed.set(self.gamesPlayed, forKey: "GamesPlayed")
                        
                        if self.swapsPerGame > self.swapsThresh {
                            let swapAchievement = true
                            let swapsPerGameEarned = UserDefaults.standard
                            swapsPerGameEarned.set(swapAchievement, forKey: "SwapsPerGame")
                            print ("Swaps achievement:", swapAchievement)
                        }
                        
                        // Emtpy field adds extra points.
                        if self.field.emptyField() {
                            self.score += 300
                            self.updateLabels()
                            self.bonusLabel.isHidden = false
                            
                            // Set total games played.
                            self.perfectGame += 1
                            let perfectGames = UserDefaults.standard
                            perfectGames.set(self.perfectGame, forKey: "PerfectGames")
                            print ("Perfect Games played:", self.perfectGame)
                        }
                        if swapsAvailable > 0 {
                            self.score += (50 * swapsAvailable)
                            self.updateLabels()
                            
                            if swapsAvailable > 1 {
                                    self.swapBonusLabel.text = String(format: "%d Swaps left: + %d", swapsAvailable, swapsAvailable * 50)
                                } else {
                                    self.swapBonusLabel.text = String(format: "%d Swap left: + %d", swapsAvailable, swapsAvailable * 50)
                                    }
                            self.swapBonusLabel.isHidden = false
                        }
                        
                        // Check if there is a new highscore.
                        if self.score > self.highscore {
                            
                            // Copy the new highscore.
                            self.highscore = self.score
                            self.updateHighscoreLabel()
                            
                            // Save the new highscore in UserDefaults.
                            let savedScore = UserDefaults.standard
                            savedScore.set(self.highscore, forKey: "Highscore")
                            
                            // Check whether an achievement was unlocked!
                            if self.checkAchievementUnlocked(){
                                self.achievementUnlockedLabel.isHidden = false
                            }
                            
                            // Show NewHighscore image.
                            self.gameOverPanel.image = UIImage(named: "NewHighscore")
                            self.showGameOver()
                           
                        }
                        else {
                            // Check whether an achievement was unlocked!
                            if self.checkAchievementUnlocked(){
                                self.achievementUnlockedLabel.isHidden = false
                            }
            
                            // If there is no new highscore, show OutOfMoves.
                            self.gameOverPanel.image = UIImage(named: "NoMoreMoves")
                            self.showGameOver()
                        }
                    }
                }
                self.view.isUserInteractionEnabled = true
            }
        }
    }
    
    func updateLabels() {
        scoreLabel.text = String(format: "%ld", score)
        swapLabel.text = String(format: "%ld", scene.availableSwaps)
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
        UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: { self.swapBonusLabel.alpha = 1.0})
        UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: { self.achievementUnlockedLabel.alpha = 1.0})

        // Animate gameOver (objects falling out of the screen).
        scene.animateGameOver() {
            
            // Wait for a tap to start a new game.
            self.tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.hideGameOver))
            self.view.addGestureRecognizer(self.tapGestureRecognizer)
            // If users tap, pressing newGameButton while animating, the field gets shifted.
            self.newGameButton.isUserInteractionEnabled = false
            }
        }
    @objc func hideGameOver() {
        // Remove gestureRecognizer and hide gameOverPanel.
        view.removeGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer = nil
       
        //gameOverPanel.alpha = 1
        UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: { self.gameOverPanel.alpha = 0})
        UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: { self.tapToContinueLabel.alpha = 0})
        UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: { self.bonusLabel.alpha = 0})
        UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: { self.swapBonusLabel.alpha = 0})
        UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: { self.achievementUnlockedLabel.alpha = 0})
        
        scene.gameSceneTouchDetected = false
        
        // Begin a new game.
        self.newGameButton.isHighlighted = false
        self.backToMenuButton.isHighlighted = false
        beginGame()
    }
    @objc func wakingUpFromBackground(){
        view.isUserInteractionEnabled = true
        newGameButton.isUserInteractionEnabled = true
        backToMenuButton.isUserInteractionEnabled = true
        scene.isUserInteractionEnabled = true
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return true
    }
    
    func checkAchievementUnlocked()->Bool{
        var check = false
        
        let savedScore = UserDefaults.standard
        let savedHighscore = savedScore.integer(forKey: "Highscore")
        let totalSavedCount = savedScore.integer(forKey: "TotalCount")
        let savedHighestCombo = savedScore.integer(forKey: "HighestCombo")
        let games = savedScore.integer(forKey: "PerfectGames")
        let played = savedScore.integer(forKey: "GamesPlayed")
        let swapsCheck = savedScore.bool(forKey: "SwapsPerGame")
        
        if savedHighscore >= highscoreThresh && !(savedScore.bool(forKey: "Highscore-Achievement")) {
            savedScore.set(true, forKey: "Highscore-Achievement")
            check = true
        }
        if totalSavedCount >= spheresTotalThresh && !(savedScore.bool(forKey: "Spheres-Achievement")) {
            savedScore.set(true, forKey: "Spheres-Achievement")
            check = true
        }
        if savedHighestCombo >= comboThresh && !(savedScore.bool(forKey: "Combo-Achievement")){
            savedScore.set(true, forKey: "Combo-Achievement")
            check = true
        }
        if games >= perfectGamesThresh && !(savedScore.bool(forKey: "Perfect-Achievement")){
            savedScore.set(true, forKey: "Perfect-Achievement")
            check = true
        }
        if played >= totalGamesThresh && !(savedScore.bool(forKey: "Games-Achievement")){
            savedScore.set(true, forKey: "Games-Achievement")
            check = true
        }
        if swapsCheck == true && !(savedScore.bool(forKey: "Swaps-Achievement")){
            savedScore.set(true, forKey: "Swaps-Achievement")
            check = true
        }
        
        return check
        
    }
}
