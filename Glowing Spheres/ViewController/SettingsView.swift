//
//  SettingsView.swift
//  Glowing Spheres
//
//  Created by Martin List on 27/09/2016.
//  Copyright © 2016 Martin List. All rights reserved.
//

import UIKit
import AVFoundation

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
    let savedSoundsSetting = UserDefaults.standard
    var playSoundsSwitchOn : Bool = false
    var savedFasterAnimations: Bool?
    var background: BackgroundView!

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
        // Set the images for the buttons.
        backButton.setImage(UIImage(named: "Back"), for: .normal)
        resetHighscore.setImage(UIImage(named: "ResetHighscore"), for: .normal)
        resetStatsButton.setImage(UIImage(named: "ResetStats"), for: .normal)

        playSoundsImage.image = UIImage(named: "Play Sounds")
        playMusicImage.image = UIImage(named: "Play Music")

        // Load Background.
        background = BackgroundView(frame: view.frame)
        view.addSubview(background)
        view.sendSubviewToBack(background)

        // Set the playMusicSwitch for the stored userDefault setting.
        if let value = UserDefaults.standard.value(forKey: "savedMusicSetting") as? Bool {
            playMusicUISwitch.setOn(value, animated: false)
        } else {
            // If there is no defaultUser setting available, set it true.
            playMusicUISwitch.setOn(true, animated: false)
        }
        if savedSoundsSetting.value(forKey: "savedSoundsSetting") != nil{
            playSoundsSwitchOn = UserDefaults.standard.value(forKey: "savedSoundsSetting")  as! Bool
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
        if playMusicUISwitch.isOn {
            // Set the new userDefault setting.
            UserDefaults.standard.set(true, forKey: "savedMusicSetting")

            // Only start playing if there is no playback.
            AudioPlayer.main.playThemeSong()
        }

        // If the user disables music playback.
        if !playMusicUISwitch.isOn {
            UserDefaults.standard.set(false, forKey: "savedMusicSetting")
            AudioPlayer.main.stopThemeSong()
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
