//
//  ChooseGameScene.swift
//  Glowing Spheres
//
//  Created by Martin List on 08/11/2016.
//  Copyright © 2016 Martin List. All rights reserved.
//

import Foundation
import SpriteKit

class ChooseGameScene: UIViewController {
    
    override var prefersStatusBarHidden : Bool {
        return true
    }

    override var shouldAutorotate : Bool {
        return true
    }

    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.portrait, UIInterfaceOrientationMask.portraitUpsideDown]
    }
    @IBOutlet weak var originalModeButton: UIButton!
    @IBOutlet weak var timeModeButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBAction func originalModeButtonTouchUp(_ sender: Any) {
        view.isUserInteractionEnabled = true
    }
    @IBAction func originalModeButtonTouchDown(_ sender: Any) {
        view.isUserInteractionEnabled = false
    }
    @IBAction func originalModeButtonOutside(_ sender: Any) {
        view.isUserInteractionEnabled = true
    }
    @IBAction func timeModeButtonTouchInside(_ sender: Any) {
        view.isUserInteractionEnabled = true
    }
    @IBAction func timeModeButtonTouchDown(_ sender: Any) {
        view.isUserInteractionEnabled = false
    }
    @IBAction func timeModeButtonOutside(_ sender: Any) {
        view.isUserInteractionEnabled = true
    }
    @IBAction func backButtonTouchInside(_ sender: Any) {
        view.isUserInteractionEnabled = true
    }
    @IBAction func backButtonTouchDown(_ sender: Any) {
        view.isUserInteractionEnabled = false
    }
    @IBAction func backButtonOutside(_ sender: Any) {
        view.isUserInteractionEnabled = true
    }
}
