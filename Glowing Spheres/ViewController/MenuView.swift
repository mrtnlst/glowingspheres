//
//  MenuView.swift
//  Glowing Spheres
//
//  Created by Martin List on 27/09/2016.
//  Copyright © 2016 Martin List. All rights reserved.
//

import UIKit
import SpriteKit
import MediaPlayer

class MenuView: UIViewController {
    
    // Create an instance of SettingScene.
    var settingsScene: SettingsView!
    
    // Set an array for the logo animation.
    var images: [UIImage] = []
    var tapGestureRecognizer: UITapGestureRecognizer!

    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override var shouldAutorotate : Bool {
        return true
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.portrait, UIInterfaceOrientationMask.portraitUpsideDown]
    }
    
    @IBOutlet weak var whatIsNewImage: UIImageView!
    @IBOutlet weak var howToPlayButton: UIButton!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var aboutButton: UIButton!
    @IBOutlet weak var statsButton: UIButton!
    
    // Setting up music playback (if UserSetting is enabled).
    let savedMusicSetting = UserDefaults.standard
    var playMusicSwitchOn : Bool = false
    let whatIsNewSetting = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Enable background music, if the userDefault setting is on.
        settingsScene = SettingsView()
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
        
        playButton.setImage(UIImage(named: "Play"), for: .normal)
        aboutButton.setImage(UIImage(named: "About"), for: .normal)
        settingsButton.setImage(UIImage(named: "Settings"), for: .normal)
        statsButton.setImage(UIImage(named: "Stats"), for: .normal)

        // Set background image.
        self.view.backgroundColor = UIColor(patternImage: UIImage(fullscreenNamed: "Main Menu")!)
        
        // Loop through all 24 images, to generate logo animation.
        for i in 1...48 {
            images.append(UIImage(named: "logo-\(i)")!)
        }
        logoImageView.animationImages = images
        logoImageView.animationDuration = 4.0
        logoImageView.startAnimating()
        
        // Only show whatIsNewImage, first time user opens the app.
        if whatIsNewSetting.value(forKey: "whatIsNewV1.2") == nil{
            showWhatIsNew()
            whatIsNewSetting.set(true, forKey: "whatIsNewV1.2")
        }
        else {
            // I set false, because it's standard is true (buttons where clickable while image was displayed).
            whatIsNewImage.isUserInteractionEnabled = false
        }

        
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
    
    @IBAction func howToPlayButtonTouchDown(_ sender: AnyObject) {
        view.isUserInteractionEnabled = false
        
    }
    @IBAction func howToPlayButtonMoved(_ sender: AnyObject) {
        view.isUserInteractionEnabled = true
    }
    @IBAction func howToPlayButtonTouchUp(_ sender: AnyObject) {
        view.isUserInteractionEnabled = true
    }
    
    @IBAction func statsButtonTouchedDown(_ sender: AnyObject) {
        view.isUserInteractionEnabled = false
    }
    @IBAction func statsButtonMoved(_ sender: AnyObject) {
        view.isUserInteractionEnabled = true
    }
    @IBAction func statsButtonTouchedUpd(_ sender: AnyObject) {
        view.isUserInteractionEnabled = true
    }

    
    
    @objc func wakingUpFromBackground(){
        view.isUserInteractionEnabled = true
        playButton.isUserInteractionEnabled = true
        settingsButton.isUserInteractionEnabled = true
        aboutButton.isUserInteractionEnabled = true
        statsButton.isUserInteractionEnabled = true
    }
    @objc func hideWhatIsNew (){
        view.removeGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer = nil
        
        UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: { self.whatIsNewImage.alpha = 0})
        
        playButton.isUserInteractionEnabled = true
        settingsButton.isUserInteractionEnabled = true
        aboutButton.isUserInteractionEnabled = true
        howToPlayButton.isUserInteractionEnabled = true
        whatIsNewImage.isUserInteractionEnabled = false
        statsButton.isUserInteractionEnabled = true
   
    }
    func showWhatIsNew(){
        playButton.isUserInteractionEnabled = false
        settingsButton.isUserInteractionEnabled = false
        aboutButton.isUserInteractionEnabled = false
        howToPlayButton.isUserInteractionEnabled = false
        statsButton.isUserInteractionEnabled = false
        
       
        whatIsNewImage.image = UIImage(fullscreenNamed: "whatIsNew")
        
        
        whatIsNewImage.alpha = 0
        UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: { self.whatIsNewImage.alpha = 1.0})
        
        self.tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.hideWhatIsNew))
        self.view.addGestureRecognizer(self.tapGestureRecognizer)
    }
}



