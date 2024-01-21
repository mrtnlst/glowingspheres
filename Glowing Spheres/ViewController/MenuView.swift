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
    var polygonMountain = UIImageView()
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override var shouldAutorotate : Bool {
        return true
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.portrait, UIInterfaceOrientationMask.portraitUpsideDown]
    }
    
    @IBOutlet weak var howToPlayButton: UIButton!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var aboutButton: UIButton!
    @IBOutlet weak var statsButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Enable background music, if the userDefault setting is on.
        settingsScene = SettingsView()

        let value = UserDefaults.standard.value(forKey: "savedMusicSetting") as? Bool
        if let value, value {
            AudioPlayer.main.playThemeSong()
        } else if value == nil {
            AudioPlayer.main.playThemeSong()
        }

        playButton.setImage(UIImage(named: "Play"), for: .normal)
        aboutButton.setImage(UIImage(named: "About"), for: .normal)
        settingsButton.setImage(UIImage(named: "Settings"), for: .normal)
        statsButton.setImage(UIImage(named: "Stats"), for: .normal)

        // Set background image.
        setupBackground()
        
        // Loop through all 24 images, to generate logo animation.
        for i in 1...48 {
            images.append(UIImage(named: "logo-\(i)")!)
        }
        logoImageView.animationImages = images
        logoImageView.animationDuration = 4.0
        logoImageView.startAnimating()
        
        // When coming back from background, restore any touch interaction, if touch was hold while entering background.
        NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.wakingUpFromBackground), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    private func setupBackground() {
        polygonMountain = UIImageView(image: UIImage(named: "Polygon Mountain"))
        polygonMountain.translatesAutoresizingMaskIntoConstraints = false
        polygonMountain.contentMode = .scaleAspectFit
        polygonMountain.alpha = 0.6
        view.addSubview(polygonMountain)
        view.sendSubviewToBack(polygonMountain)
        
        var guide: UILayoutGuide
        
        if #available(iOS 11.0, *) {
            guide = view.safeAreaLayoutGuide
        } else {
            guide = view.layoutMarginsGuide
        }
        
        NSLayoutConstraint.activate([
            polygonMountain.topAnchor.constraint(equalTo: guide.topAnchor, constant: -250),
            polygonMountain.heightAnchor.constraint(equalToConstant: view.frame.height),
            polygonMountain.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: -150),
            polygonMountain.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: 150),
            ])
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
}



