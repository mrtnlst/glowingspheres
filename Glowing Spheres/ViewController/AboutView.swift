//
//  AboutView.swift
//  Glowing Spheres
//
//  Created by Martin List on 29/09/2016.
//  Copyright © 2016 Martin List. All rights reserved.
//

import UIKit

class AboutView: UIViewController {
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.portrait, UIInterfaceOrientationMask.portraitUpsideDown]
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override var shouldAutorotate : Bool {
        return true
    }
   
    @IBOutlet weak var fontCreditsText: UILabel!
    @IBOutlet weak var aboutText: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var followOnTwitter: UIButton!
    @IBOutlet weak var openWebsite: UIButton!
    
    // Setting up a twitter URL.
    var twitterURLMartin = URL(string: "https://twitter.com/mrtnlst")
    var websiteURL = URL(string: "https://martinlist.org")
    var background: BackgroundView!

    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Load Background.
        background = BackgroundView(frame: view.frame)
        view.addSubview(background)
        view.sendSubviewToBack(background)
        
        // Setting up the button image.
        backButton.setImage(UIImage(named: "Back"), for: .normal)
        
        if view.frame.size.width.isSmallDevice {
            //iPhone 2G, 3G, 3GS, 4, 4s, 5, 5s, 5c
            aboutText.font = UIFont(name: "Futura", size: 18)
            
        } else if view.frame.size.width.isMediumDevice {
            //iPhone 6
            aboutText.font = UIFont(name: "Futura", size: 20)
        } else if view.frame.size.width.isBigDevice {
            //iPhone 6 Plus
            aboutText.font = UIFont(name: "Futura", size: 24)
        }
        // When coming back from background, restore any touch interaction, if touch was hold while entering background.
        NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.wakingUpFromBackground), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    // MARK: followGlowingSpheres Events.
    @IBAction func openWebsiteTouchDown(_ sender: AnyObject) {
        view.isUserInteractionEnabled = false
    }
    @IBAction func openWebsiteMoved(_ sender: AnyObject) {
        view.isUserInteractionEnabled = true
    }
    @IBAction func openWebsitePressed(_ sender: AnyObject) {
        view.isUserInteractionEnabled = true
        let options = [UIApplication.OpenExternalURLOptionsKey.universalLinksOnly : false]
        UIApplication.shared.open(websiteURL!, options: options, completionHandler: nil)

    }
    
    // MARK: followOnTwitter Events.
    @IBAction func followOnTwitterTouchDown(_ sender: AnyObject) {
        view.isUserInteractionEnabled = false
    }
    @IBAction func followOnTwitterMoved(_ sender: AnyObject) {
        view.isUserInteractionEnabled = true
    }
    @IBAction func followOnTwitterPressed(_ sender: AnyObject) {
        view.isUserInteractionEnabled = true
        // If the button is pressed, open Twitter.app if possible, or safari.
        let options = [UIApplication.OpenExternalURLOptionsKey.universalLinksOnly : false]
        UIApplication.shared.open(twitterURLMartin!, options: options, completionHandler: nil)
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
    
    @objc func wakingUpFromBackground(){
        view.isUserInteractionEnabled = true
        followOnTwitter.isUserInteractionEnabled = true
        openWebsite.isUserInteractionEnabled = true
        backButton.isUserInteractionEnabled = true
    }
}
