//
//  StatsView.swift
//  Glowing Spheres
//
//  Created by Martin List on 22/02/2017.
//  Copyright © 2017 Martin List. All rights reserved.
//

import Foundation
import UIKit

class StatsView: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var totalCount: UILabel!
    @IBOutlet weak var currentHighscore: UILabel!
    @IBOutlet weak var highestCombo: UILabel!
    @IBOutlet weak var gamesPlayed: UILabel!
    @IBOutlet weak var perfectGames: UILabel!

    @IBOutlet weak var totalCountLabel: UILabel!
    @IBOutlet weak var highscoreLabel: UILabel!
    @IBOutlet weak var highestComboLabel: UILabel!
    @IBOutlet weak var gamesPlayedLabel: UILabel!
    @IBOutlet weak var perfectGamesLabel: UILabel!
    
    @IBOutlet weak var gamesPlayedImage: UIImageView!
    @IBOutlet weak var perfectGamesImage: UIImageView!
    @IBOutlet weak var highscoreImage: UIImageView!
    @IBOutlet weak var highestComboImage: UIImageView!
    @IBOutlet weak var totalSpheresImage: UIImageView!
    @IBOutlet weak var swapsEarnedImage: UIImageView!
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    var background: BackgroundView!

    
// MARK: Button Events.
    @IBAction func BackButtonTouchedUp(_ sender: AnyObject) {
        view.isUserInteractionEnabled = true
    }
    @IBAction func BackButtonTouchDown(_ sender: AnyObject) {
        view.isUserInteractionEnabled = false
    }
    @IBAction func BackButtonMoved(_ sender: AnyObject) {
        view.isUserInteractionEnabled = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Bool values, if achievement has been unlocked.
        let savedState = UserDefaults.standard
        let highscoreAchievement = savedState.bool(forKey: "Highscore-Achievement")
        let totalCountAchievement = savedState.bool(forKey: "Spheres-Achievement")
        let comboAchievement = savedState.bool(forKey: "Combo-Achievement")
        let gamesAchievement = savedState.bool(forKey: "Perfect-Achievement")
        let playedAchievement = savedState.bool(forKey: "Games-Achievement")
        let swapsAchievement = savedState.bool(forKey: "Swaps-Achievement")
        
        // Actual values for stats.
        let savedScore = UserDefaults.standard
        let savedHighscore = savedScore.integer(forKey: "Highscore")
        let totalSavedCount = savedScore.integer(forKey: "TotalCount")
        let savedHighestCombo = savedScore.integer(forKey: "HighestCombo")
        let games = savedScore.integer(forKey: "PerfectGames")
        let played = savedScore.integer(forKey: "GamesPlayed")
        
        loadLabels(score: savedHighscore, count: totalSavedCount, combo: savedHighestCombo, games: games, played: played)
        checkAchievements(highscore: highscoreAchievement, count: totalCountAchievement, combo: comboAchievement, games: gamesAchievement, played: playedAchievement, swaps: swapsAchievement)
        
        // Load Achievement Images.
        gamesPlayedImage.image = UIImage(named: "100Games")
        totalSpheresImage.image = UIImage(named: "10kSpheres")
        highestComboImage.image = UIImage(named: "Combo")
        perfectGamesImage.image = UIImage(named: "perfectGames")
        swapsEarnedImage.image = UIImage(named: "swapsEarned")
        highscoreImage.image = UIImage(named: "15khighscore")

        // Load Background.
        background = BackgroundView(frame: view.frame)
        view.addSubview(background)
        view.sendSubviewToBack(background)
        
        if view.frame.size.width.isSmallDevice {
            //iPhone 2G, 3G, 3GS, 4, 4s, 5, 5s, 5c
            totalCount.font = UIFont(name: "Futura-Bold", size: 18)
            totalCountLabel.font = UIFont(name: "Futura", size: 18)

            currentHighscore.font = UIFont(name: "Futura-Bold", size: 18)
            highscoreLabel.font = UIFont(name: "Futura", size: 18)
            
            highestCombo.font = UIFont(name: "Futura-Bold", size: 18)
            highestComboLabel.font = UIFont(name: "Futura", size: 18)
            
            perfectGames.font = UIFont(name: "Futura-Bold", size: 18)
            perfectGamesLabel.font = UIFont(name: "Futura", size: 18)
            
            gamesPlayed.font = UIFont(name: "Futura-Bold", size: 18)
            gamesPlayedLabel.font = UIFont(name: "Futura", size: 18)


        } else if view.frame.size.width.isMediumDevice {
            //iPhone 6
            totalCount.font = UIFont(name: "Futura-Bold", size: 20)
            totalCountLabel.font = UIFont(name: "Futura", size: 20)
            
            currentHighscore.font = UIFont(name: "Futura-Bold", size: 20)
            highscoreLabel.font = UIFont(name: "Futura", size: 20)
            
            highestCombo.font = UIFont(name: "Futura-Bold", size: 20)
            highestComboLabel.font = UIFont(name: "Futura", size: 20)
            
            perfectGames.font = UIFont(name: "Futura-Bold", size: 20)
            perfectGamesLabel.font = UIFont(name: "Futura", size: 20)
            
            gamesPlayed.font = UIFont(name: "Futura-Bold", size: 20)
            gamesPlayedLabel.font = UIFont(name: "Futura", size: 20)

        } else if view.frame.size.width.isBigDevice {
            //iPhone 6 Plus
            totalCount.font = UIFont(name: "Futura-Bold", size: 24)
            totalCountLabel.font = UIFont(name: "Futura", size: 24)
            
            currentHighscore.font = UIFont(name: "Futura-Bold", size: 24)
            highscoreLabel.font = UIFont(name: "Futura", size: 24)
            
            highestCombo.font = UIFont(name: "Futura-Bold", size: 24)
            highestComboLabel.font = UIFont(name: "Futura", size: 24)
            
            perfectGames.font = UIFont(name: "Futura-Bold", size: 24)
            perfectGamesLabel.font = UIFont(name: "Futura", size: 24)
            
            gamesPlayed.font = UIFont(name: "Futura-Bold", size: 24)
            gamesPlayedLabel.font = UIFont(name: "Futura", size: 24)

        }

        // When coming back from background, restore any touch interaction, if touch was hold while entering background.
        NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.wakingUpFromBackground), name: UIApplication.didBecomeActiveNotification, object: nil)
    
    }
    func loadLabels(score: Int, count: Int, combo: Int, games: Int, played: Int) {
        totalCount.text = String(format: "%ld", count)
        currentHighscore.text = String(format: "%ld", score)
        highestCombo.text = String(format: "%ld", combo)
        gamesPlayed.text = String(format: "%ld", played)
        perfectGames.text = String(format: "%ld", games)
    }
    
    @objc func wakingUpFromBackground(){
        view.isUserInteractionEnabled = true
        backButton.isUserInteractionEnabled = true
    }
    
    func checkAchievements(highscore: Bool, count: Bool, combo: Bool, games: Bool, played: Bool, swaps: Bool){
        if highscore{
            highscoreImage.alpha = 1.0
        } else {
             highscoreImage.alpha = 0.3
        }
        
        if count {
            totalSpheresImage.alpha = 1.0
        } else {
            totalSpheresImage.alpha = 0.3
        }
        
        if combo {
            highestComboImage.alpha = 1.0
        } else {
            highestComboImage.alpha = 0.3
        }
        
        if games{
            perfectGamesImage.alpha = 1.0
        } else {
            perfectGamesImage.alpha = 0.3
        }
        
        if played{
            gamesPlayedImage.alpha = 1.0
        } else {
            gamesPlayedImage.alpha = 0.3
        }
    
        if swaps{
            swapsEarnedImage.alpha = 1.0
        } else {
            swapsEarnedImage.alpha = 0.3
        }
    
    }
}
