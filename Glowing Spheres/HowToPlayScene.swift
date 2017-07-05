//
//  HowToPlayScene.swift
//  Glowing Spheres
//
//  Created by Martin List on 19/10/2016.
//  Copyright © 2016 Martin List. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class HowToPlayScene: UIViewController {
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.portrait, UIInterfaceOrientationMask.portraitUpsideDown]
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override var shouldAutorotate : Bool {
        return true
    }
    
    @IBOutlet weak var instructionLabel1: UILabel!
    @IBOutlet weak var instructionLabel2: UILabel!
    @IBOutlet weak var instructionLabel3: UILabel!
    @IBOutlet weak var backToMenuButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Load Background.
        self.view.backgroundColor = UIColor(patternImage: UIImage(fullscreenNamed: "BG")!)
        backToMenuButton.setImage(UIImage(named: "Back"), for: .normal)
        
        if (self.view.frame.size.width == 320){
            //iPhone 2G, 3G, 3GS, 4, 4s, 5, 5s, 5c
            instructionLabel1.font = UIFont(name: "Futura", size: 16)
            
        }
        else if (self.view.frame.size.width == 375){
            //iPhone 6
            instructionLabel1.font = UIFont(name: "Futura", size: 20)
            instructionLabel2.font = UIFont(name: "Futura", size: 20)
            instructionLabel3.font = UIFont(name: "Futura", size: 20)

        }
        else if (self.view.frame.size.width == 414){
            //iPhone 6 Plus
            instructionLabel1.font = UIFont(name: "Futura", size: 22)
            instructionLabel2.font = UIFont(name: "Futura", size: 22)
            instructionLabel3.font = UIFont(name: "Futura", size: 22)        }

        // When coming back from background, restore any touch interaction, if touch was hold while entering background.
        NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.wakingUpFromBackground), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)

    }
   
    @IBAction func backToMenuButtonTouchDown(_ sender: AnyObject) {
        view.isUserInteractionEnabled = false
    }
    @IBAction func backToMenuButtonMoved(_ sender: AnyObject) {
        view.isUserInteractionEnabled = true
    }
    @IBAction func backToMenuButtonTouchUp(_ sender: AnyObject) {
        view.isUserInteractionEnabled = true
    }
    func wakingUpFromBackground(){
        view.isUserInteractionEnabled = true
        backToMenuButton.isUserInteractionEnabled = true
    }
}
