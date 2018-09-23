//
//  SettingsView.swift
//  Glowing Spheres
//
//  Created by Martin List on 27/09/2016.
//  Copyright © 2016 Martin List. All rights reserved.
//

import UIKit
import AVFoundation

var themeSong: AVAudioPlayer?

class SettingsView: UIViewController {

    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override var shouldAutorotate : Bool {
        return true
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.portrait, UIInterfaceOrientationMask.portraitUpsideDown]
    }
    
    // MARK:  Variables and constants.
    var product_id: String?
    var images: [UIImage] = []
    let savedMusicSetting = UserDefaults.standard
    var playMusicSwitchOn : Bool = false
    let savedSoundsSetting = UserDefaults.standard
    var playSoundsSwitchOn : Bool = false
    var savedFasterAnimations: Bool?
    
    // MARK: Outlets Variables and constants.
    @IBOutlet weak var playSoundsUISwitch: UISwitch!
    @IBOutlet weak var playMusicUISwitch: UISwitch!
    @IBOutlet weak var playSoundsImage: UIImageView!
    @IBOutlet weak var playMusicImage: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var resetHighscore: UIButton!
    @IBOutlet weak var supporterLabel: UIImageView!
    @IBOutlet weak var resetStatsButton: UIButton!

    override func viewDidLoad() {
        // Allow simultaneous playback.
        super.viewDidLoad()
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let error as NSError { print(error)}
       
        // Set the images for the buttons.
        backButton.setImage(UIImage(named: "Back"), for: .normal)
        resetHighscore.setImage(UIImage(named: "ResetHighscore"), for: .normal)
        resetStatsButton.setImage(UIImage(named: "ResetStats"), for: .normal)

        playSoundsImage.image = UIImage(named: "Play Sounds")
        playMusicImage.image = UIImage(named: "Play Music")
        
        // Load Background.
        self.view.backgroundColor = UIColor(patternImage: UIImage(fullscreenNamed: "BG")!)
        
        // Set the playMusicSwitch for the stored userDefault setting.
        if savedMusicSetting.value(forKey: "savedMusicSetting") != nil{
            playMusicSwitchOn = savedMusicSetting.value(forKey: "savedMusicSetting")  as! Bool
            playMusicUISwitch.setOn(playMusicSwitchOn, animated: false)
        } else {
            // If there is no defaultUser setting available, set it true.
            playMusicSwitchOn = true
            playMusicUISwitch.setOn(playMusicSwitchOn, animated: false)
        }
        if savedSoundsSetting.value(forKey: "savedSoundsSetting") != nil{
            playSoundsSwitchOn = savedMusicSetting.value(forKey: "savedSoundsSetting")  as! Bool
            playSoundsUISwitch.setOn(playSoundsSwitchOn, animated: false)
            print("Loading Setting")
        } else {
            // If there is no defaultUser setting available, set it true.
            playSoundsSwitchOn = true
            playSoundsUISwitch.setOn(playSoundsSwitchOn, animated: false)
        }

        // Initialize in-app purchase.
       if (UserDefaults.standard.bool(forKey: "purchased")){
            supportAnimation()
            } else {
            supporterLabel.isHidden = true
        }
        // When coming back from background, restore any touch interaction, if touch was hold while entering background.
        NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.wakingUpFromBackground), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @IBAction func playMusicUISwitchToggled(_ sender: AnyObject) {
        // If the user enables music playback.
        if playMusicUISwitch.isOn{
            // Set the new userDefault setting.
            playMusicSwitchOn = true
            savedMusicSetting.set(playMusicSwitchOn, forKey: "savedMusicSetting")
            
            // Only start playing if there is no playback.
            if themeSong == nil {
                playBackgroundMusic()
                print ("Music started.")
            } else {
                    print("Music already playing.")
            }
        }
       
        // If the user disables music playback.
        if playMusicUISwitch.isOn == false{
            playMusicSwitchOn = false
            savedMusicSetting.set(playMusicSwitchOn, forKey: "savedMusicSetting")
            // Only stop, if a song is playing.
            if themeSong != nil {
                //themeSong?.stop()
                themeSong = nil
            }
        }
    }
    
    @IBAction func playSoundsUISwitchToggled(_ sender: AnyObject) {
        if playSoundsUISwitch.isOn{
            playSoundsSwitchOn = true
            savedSoundsSetting.set(playSoundsSwitchOn, forKey: "savedSoundsSetting")
        }
        if playSoundsUISwitch.isOn == false{
            playSoundsSwitchOn = false
            savedSoundsSetting.set(playSoundsSwitchOn, forKey: "savedSoundsSetting")
    }
    }
    // MARK: backButton Events.
    @IBAction func BackButtonTouchedUp(_ sender: AnyObject) {
        view.isUserInteractionEnabled = true
    }
    @IBAction func BackButtonTouchDown(_ sender: AnyObject) {
        view.isUserInteractionEnabled = false
    }
    @IBAction func BackButtonMoved(_ sender: AnyObject) {
        view.isUserInteractionEnabled = true
    }
    
    // MARK: resetHighscore Events.
    @IBAction func reseHighscoreButtonTouchedDown(_ sender: AnyObject) {
        view.isUserInteractionEnabled = false
    }
    @IBAction func resetHighscoreButtonMoved(_ sender: AnyObject) {
        view.isUserInteractionEnabled = true
    }
    @IBAction func resetHighscoreButtonPressed(_ sender: AnyObject) {
        
        view.isUserInteractionEnabled = true
        // Initiating an alertbox to confirm highscore reset.
        var title: String
        var message: String
        
        title = "Reset Highscore"
        message = "This cannot be undone!"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        // Actions for alertbox.
        alert.addAction(UIAlertAction(title: "Ok", style: .default) { action in
            let savedScore = UserDefaults.standard
            savedScore.set(0, forKey: "Highscore")
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        self.present(alert, animated: true, completion: nil)
    }
    
    func playBackgroundMusic(){
        let path = Bundle.main.path(forResource: "Theme.m4a", ofType:nil)!
        let url = URL(fileURLWithPath: path)
        
        do {
            let sound = try AVAudioPlayer(contentsOf: url)
            themeSong = sound
            sound.volume = 0.1
            sound.play()
            sound.numberOfLoops = -1
        } catch {
            print("couldn't load file")
        }
        
    }
// MARK: Reset Stats Events:
    
    @IBAction func resetStatsTouchUp(_ sender: Any) {
        view.isUserInteractionEnabled = true
        
        var title: String
        var message: String
        
        title = "Reset Stats"
        message = "This cannot be undone!"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        // Actions for alertbox.
        alert.addAction(UIAlertAction(title: "Ok", style: .default) { action in
            let savedScore = UserDefaults.standard
            savedScore.set(0, forKey: "Highscore")
            savedScore.set(0, forKey: "TotalCount")
            savedScore.set(0, forKey: "HighestCombo")
            savedScore.set(0, forKey: "PerfectGames")
            savedScore.set(0, forKey: "GamesPlayed")
            savedScore.set(false, forKey: "SwapsPerGame")

            savedScore.set(false, forKey: "Highscore-Achievement")
            savedScore.set(false, forKey: "Spheres-Achievement")
            savedScore.set(false, forKey: "Combo-Achievement")
            savedScore.set(false, forKey: "Perfect-Achievement")
            savedScore.set(false, forKey: "Games-Achievement")
            savedScore.set(false, forKey: "Swaps-Achievement")
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)

    }
    
    @IBAction func resetStatsTouchDown(_ sender: Any) {
        view.isUserInteractionEnabled = false
    }
    @IBAction func resetStatsMoved(_ sender: Any) {
        view.isUserInteractionEnabled = true
    }
    
    func supportAnimation() {
        // Animation for supporterst of the app.
        for i in 1...48 {
        images.append(UIImage(named: "supporter-\(i)")!)
        }
        supporterLabel.animationImages = images
        supporterLabel.animationDuration = 4.0
        supporterLabel.startAnimating()

    }
   
    @objc func wakingUpFromBackground(){
        view.isUserInteractionEnabled = true
        resetHighscore.isUserInteractionEnabled = true
        backButton.isUserInteractionEnabled = true
    }
}
