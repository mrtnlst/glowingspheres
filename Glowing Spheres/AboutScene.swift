//
//  AboutScene.swift
//  Glowing Spheres
//
//  Created by Martin List on 29/09/2016.
//  Copyright © 2016 Martin List. All rights reserved.
//

import UIKit

class AboutScene: UIViewController {
    
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
    @IBOutlet weak var writeEmail: UIButton!
    @IBOutlet weak var followOnTwitter: UIButton!
    @IBOutlet weak var followGlowingSpheres: UIButton!
    
    // Setting up a twitter URL.
    var twitterURLMartin = URL(string: "https://twitter.com/mrtnlst")
    var twitterURLGlowingSpheres = URL(string: "https://twitter.com/glowingspheres")
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Setting up the button image.
        if locale.languageCode == "de" {
            backButton.setImage(UIImage(named: "Back-de"), for: .normal)
            aboutText.text = "Glowing Spheres wurde gestaltet \nund programmiert von Martin List.\n"
            fontCreditsText.text = "\nSchriftart LAZER 84 von Juan Hodgson. \nSchriftart Axis von Jean M. Wojciechowski\n\n"
        } else {
        backButton.setImage(UIImage(named: "Back"), for: .normal)
        }
        // Setting up the background color.
        view.backgroundColor = UIColor.black
        
        if (self.view.frame.size.width == 320){
            //iPhone 2G, 3G, 3GS, 4, 4s, 5, 5s, 5c
            aboutText.font = UIFont(name: "Futura", size: 16)
            
        }
        else if (self.view.frame.size.width == 375){
            //iPhone 6
            aboutText.font = UIFont(name: "Futura", size: 18)
        }
        else if (self.view.frame.size.width == 414){
            //iPhone 6 Plus
            aboutText.font = UIFont(name: "Futura", size: 21)
        }
        // When coming back from background, restore any touch interaction, if touch was hold while entering background.
        NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.wakingUpFromBackground), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }
    // MARK: writeEmail Events.
    @IBAction func writeEmailTouchDown(_ sender: AnyObject) {
        view.isUserInteractionEnabled = false
    }
    @IBAction func writeEmailMoved(_ sender: AnyObject) {
        view.isUserInteractionEnabled = true
    }
    @IBAction func writeEmailPressed(_ sender: AnyObject) {
        view.isUserInteractionEnabled = true
        let coded = URL(string:"mailto:glowingspheresios@gmail.com")
        let options = [UIApplicationOpenURLOptionUniversalLinksOnly : false]
        UIApplication.shared.open(coded!, options: options, completionHandler: nil)

    }
    
    // MARK: followGlowingSpheres Events.
    @IBAction func followGlowingSpheresTouchDown(_ sender: AnyObject) {
        view.isUserInteractionEnabled = false
    }
    @IBAction func followGlowingSpheresMoved(_ sender: AnyObject) {
        view.isUserInteractionEnabled = true
    }
    @IBAction func followGlowingSpheresPressed(_ sender: AnyObject) {
        view.isUserInteractionEnabled = true
        let options = [UIApplicationOpenURLOptionUniversalLinksOnly : false]
        UIApplication.shared.open(twitterURLGlowingSpheres!, options: options, completionHandler: nil)

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
        let options = [UIApplicationOpenURLOptionUniversalLinksOnly : false]
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
    func wakingUpFromBackground(){
        view.isUserInteractionEnabled = true
        followOnTwitter.isUserInteractionEnabled = true
        followGlowingSpheres.isUserInteractionEnabled = true
        writeEmail.isUserInteractionEnabled = true
        backButton.isUserInteractionEnabled = true
    }
}
