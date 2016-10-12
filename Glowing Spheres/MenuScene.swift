//
//  MenuScene.swift
//  Liquid
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
    
    let savedMusicSetting = UserDefaults.standard
    var playMusicSwitchOn : Bool = false
    
    @IBAction func playButtonPressed(_ sender: AnyObject) {
    
    }
    
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
            playButton.setImage(UIImage(named: "Spielen"), for: .normal)
            aboutButton.setImage(UIImage(named: "Infos"), for: .normal)
            settingsButton.setImage(UIImage(named: "Einstellungen"), for: .normal)
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
        
    }
}



