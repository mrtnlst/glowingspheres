//
//  AboutScene.swift
//  Liquid
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
            backButton.setImage(UIImage(named: "Zurueck"), for: .normal)
            aboutText.text = "Alle Inhalte von Glowing Spheres wurden gestaltet und programmiert von Martin List."
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
    }
    
    @IBAction func writeEmailPressed(_ sender: AnyObject) {
        let coded = URL(string:"mailto:glowingspheresios@gmail.com")
        let options = [UIApplicationOpenURLOptionUniversalLinksOnly : false]
        UIApplication.shared.open(coded!, options: options, completionHandler: nil)

    }
    @IBAction func followGlowingSpheresPressed(_ sender: AnyObject) {
        let options = [UIApplicationOpenURLOptionUniversalLinksOnly : false]
        UIApplication.shared.open(twitterURLGlowingSpheres!, options: options, completionHandler: nil)

    }
    @IBAction func followOnTwitterPressed(_ sender: AnyObject) {
        
        // If the button is pressed, open Twitter.app if possible, or safari. 
        let options = [UIApplicationOpenURLOptionUniversalLinksOnly : false]
        UIApplication.shared.open(twitterURLMartin!, options: options, completionHandler: nil)
    }
}
