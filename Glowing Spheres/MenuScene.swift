//
//  MenuScene.swift
//  Glowing Spheres
//
//  Created by Martin List on 27/09/2016.
//  Copyright © 2016 Martin List. All rights reserved.
//

import UIKit
import SpriteKit
import MediaPlayer

class MenuScene: UIViewController {
    
    // Create an instance of SettingScene.
    var settingsScene: SettingsScene!
    
    // Set an array for the logo animation.
    var images: [UIImage] = []

    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override var shouldAutorotate : Bool {
        return true
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.portrait, UIInterfaceOrientationMask.portraitUpsideDown]
    }
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var aboutButton: UIButton!
    
    // Setting up music playback (if UserSetting is enabled).
    let savedMusicSetting = UserDefaults.standard
    var playMusicSwitchOn : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Enable background music, if the userDefault setting is on.
        settingsScene = SettingsScene()
        if savedMusicSetting.value(forKey: "savedMusicSetting") != nil{
             playMusicSwitchOn = savedMusicSetting.value(forKey: "savedMusicSetting")  as! Bool
            // Check if the setting stored is true.
            if playMusicSwitchOn == true {
                // Only start playback, if the song is not playing.
                if themeSong == nil {
                settingsScene.playBackgroundMusic()
                }
            }
        } else {
            playMusicSwitchOn = true
            if themeSong == nil {
                settingsScene.playBackgroundMusic()
            }
        }
        
        // Set images for menu buttons.
        if locale.languageCode == "de" {
            playButton.setImage(UIImage(named: "Play-de"), for: .normal)
            aboutButton.setImage(UIImage(named: "About-de"), for: .normal)
            settingsButton.setImage(UIImage(named: "Settings-de"), for: .normal)
        }
        else {
            playButton.setImage(UIImage(named: "Play"), for: .normal)
            aboutButton.setImage(UIImage(named: "About"), for: .normal)
            settingsButton.setImage(UIImage(named: "Settings"), for: .normal)
        }
        // Set background image.
        self.view.backgroundColor = UIColor(patternImage: UIImage(fullscreenNamed: "Main Menu")!)
        
        // Loop through all 24 images, to generate logo animation.
        for i in 1...48 {
            images.append(UIImage(named: "logo-\(i)")!)
        }
        logoImageView.animationImages = images
        logoImageView.animationDuration = 4.0
        logoImageView.startAnimating()
        
        // When coming back from background, restore any touch interaction, if touch was hold while entering background.
        NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.wakingUpFromBackground), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }
    
    // MARK: Set up correct button behavior.
    @IBAction func playButtonTouchedDown(_ sender: AnyObject) {
        view.isUserInteractionEnabled = false
    }
    @IBAction func playButtonMoved(_ sender: AnyObject) {
        view.isUserInteractionEnabled = true
    }
    @IBAction func playButtonTouchedUpd(_ sender: AnyObject) {
        view.isUserInteractionEnabled = true
    }
    @IBAction func settingsButtonTouchedDown(_ sender: AnyObject) {
        view.isUserInteractionEnabled = false
    }
    @IBAction func settingsButtonMoved(_ sender: AnyObject) {
        view.isUserInteractionEnabled = true
    }
    @IBAction func settingsButtonTouchedUp(_ sender: AnyObject) {
        view.isUserInteractionEnabled = true
    }
    @IBAction func aboutButtonTouchedDown(_ sender: AnyObject) {
        view.isUserInteractionEnabled = false
    }
    @IBAction func aboutButtonTouchedUp(_ sender: AnyObject) {
        view.isUserInteractionEnabled = true
    }
    @IBAction func aboutButtonMoved(_ sender: AnyObject) {
        view.isUserInteractionEnabled = true
    }
    func wakingUpFromBackground(){
        view.isUserInteractionEnabled = true
        playButton.isUserInteractionEnabled = true
        settingsButton.isUserInteractionEnabled = true
        aboutButton.isUserInteractionEnabled = true
    }
}



