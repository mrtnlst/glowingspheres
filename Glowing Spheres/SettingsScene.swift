//
//  SettingsScene.swift
//  Glowing Spheres
//
//  Created by Martin List on 27/09/2016.
//  Copyright © 2016 Martin List. All rights reserved.
//

import UIKit
import AVFoundation
//import StoreKit

var themeSong: AVAudioPlayer?

class SettingsScene: UIViewController/*, SKProductsRequestDelegate, SKPaymentTransactionObserver*/ {

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
    let savedMusicSetting = UserDefaults.standard
    var playMusicSwitchOn : Bool = false
    let savedSoundsSetting = UserDefaults.standard
    var playSoundsSwitchOn : Bool = false
    var savedFasterAnimations: Bool?
    
    // MARK: Outlets Variables and constants.
    @IBOutlet weak var playSoundsUISwitch: UISwitch!
    @IBOutlet weak var playMusicUISwitch: UISwitch!
    //@IBOutlet weak var inAppPurchaseLabel: UILabel!
    //@IBOutlet weak var restorePurchasesButton: UIButton!
    //@IBOutlet weak var tipJarButton: UIButton!
    @IBOutlet weak var playSoundsImage: UIImageView!
    @IBOutlet weak var playMusicImage: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var resetHighscore: UIButton!
    @IBOutlet weak var supporterLabel: UIImageView!

    override func viewDidLoad() {
        // Allow simultaneous playback.
        super.viewDidLoad()
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let error as NSError { print(error)}
       
        // Set the images for the buttons.
        if locale.languageCode == "de" {
            backButton.setImage(UIImage(named: "Back-de"), for: .normal)
            resetHighscore.setImage(UIImage(named: "ResetHighscore-de"), for: .normal)
            playSoundsImage.image = UIImage(named: "PlaySounds-de")
            playMusicImage.image = UIImage(named: "PlayMusic-de")
            //tipJarButton.setImage(UIImage(named: "SupportDevelopment-de"), for: .normal)
            //restorePurchasesButton.setImage(UIImage(named: "RestorePurchases-de"), for: .normal)
            //inAppPurchaseLabel.text = " Gefällt dir meine App?\n Unterstütze mich mit 99 ct."

        }
        else {
            backButton.setImage(UIImage(named: "Back"), for: .normal)
            resetHighscore.setImage(UIImage(named: "ResetHighscore"), for: .normal)
            //tipJarButton.setImage(UIImage(named: "SupportDevelopment"), for: .normal)
            //restorePurchasesButton.setImage(UIImage(named: "RestorePurchases"), for: .normal)
            //inAppPurchaseLabel.text = " Like my app? Support its development\n with a 99 ct in-app purchase."


        }
        // Set the playMusicSwitch for the stored userDefault setting.
        if savedMusicSetting.value(forKey: "savedMusicSetting") != nil{
            playMusicSwitchOn = savedMusicSetting.value(forKey: "savedMusicSetting")  as! Bool
            playMusicUISwitch.setOn(playMusicSwitchOn, animated: false)
        } else {
            // If there is no defaultUser setting available, set it true.
            playMusicSwitchOn = true
            playMusicUISwitch.setOn(playMusicSwitchOn, animated: false)
        }
        if savedSoundsSetting.value(forKey: "savedSoundsSetting") != nil{
            playSoundsSwitchOn = savedMusicSetting.value(forKey: "savedSoundsSetting")  as! Bool
            playSoundsUISwitch.setOn(playSoundsSwitchOn, animated: false)
            print("Loading Setting")
        } else {
            // If there is no defaultUser setting available, set it true.
            playSoundsSwitchOn = true
            playSoundsUISwitch.setOn(playSoundsSwitchOn, animated: false)
        }

        // Set the background color.
        view.backgroundColor = UIColor.black

        // Initialize in-app purchase.
//        product_id = "com.martinlist.glowingspheres.tipJar"
//        SKPaymentQueue.default().add(self)
//
        if (UserDefaults.standard.bool(forKey: "purchased")){
            // Hide ads
            //restorePurchasesButton.isEnabled = false
            //restorePurchasesButton.isHighlighted = true
            //tipJarButton.isEnabled = false
            //tipJarButton.isHighlighted = true
            supportAnimation()
            //supporterLabel.isHidden = false
//            if locale.languageCode == "de" {
//                inAppPurchaseLabel.text = " Danke für deine Unterstützung. \n Du bist klasse!"
//            }
//            else {
//                inAppPurchaseLabel.text = " Thanks for your support. \n You're awesome!"
//            }

        } else {
            supporterLabel.isHidden = true
        }
        // When coming back from background, restore any touch interaction, if touch was hold while entering background.
        NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.wakingUpFromBackground), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }
    
    @IBAction func playMusicUISwitchToggled(_ sender: AnyObject) {
        // If the user enables music playback.
        if playMusicUISwitch.isOn{
            // Set the new userDefault setting.
            playMusicSwitchOn = true
            savedMusicSetting.set(playMusicSwitchOn, forKey: "savedMusicSetting")
            
            // Only start playing if there is no playback.
            if themeSong == nil {
                playBackgroundMusic()
                print ("Music started.")
            } else {
                    print("Music already playing.")
            }
        }
       
        // If the user disables music playback.
        if playMusicUISwitch.isOn == false{
            playMusicSwitchOn = false
            savedMusicSetting.set(playMusicSwitchOn, forKey: "savedMusicSetting")
            // Only stop, if a song is playing.
            if themeSong != nil {
                //themeSong?.stop()
                themeSong = nil
            }
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
        
        if locale.languageCode == "de" {
            title = "Highscore zurücksetzen"
            message = "Dies kann nicht rückgängig gemacht werden!"
        } else {
            title = "Reset Highscore"
            message = "This cannot be undone!"
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        // Actions for alertbox.
        alert.addAction(UIAlertAction(title: "Ok", style: .default) { action in
            let savedScore = UserDefaults.standard
            savedScore.set(0, forKey: "Highscore")
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        self.present(alert, animated: true, completion: nil)
    }
    
    func playBackgroundMusic(){
        let path = Bundle.main.path(forResource: "Theme.m4a", ofType:nil)!
        let url = URL(fileURLWithPath: path)
        
        do {
            let sound = try AVAudioPlayer(contentsOf: url)
            themeSong = sound
            sound.volume = 0.1
            sound.play()
            sound.numberOfLoops = -1
        } catch {
            print("couldn't load file")
        }
        
    }
    
// MARK: restorePurchases Events
//    @IBAction func restorePurchasesMoved(_ sender: AnyObject) {
//        view.isUserInteractionEnabled = true
//    }
//    @IBAction func restorePurchasesTouchedDown(_ sender: AnyObject) {
//        view.isUserInteractionEnabled = false
//    }
//    @IBAction func restorePurchasesButtonPressed(_ sender: AnyObject) {
//        view.isUserInteractionEnabled = true
//        if (SKPaymentQueue.canMakePayments()) {
//            SKPaymentQueue.default().restoreCompletedTransactions()
//        }
//
//    }
//    
//// MARK: tipJar Events
//    @IBAction func tipJarButtonTouchedDown(_ sender: AnyObject) {
//        view.isUserInteractionEnabled = false
//    }
//    @IBAction func tipJarButtonMoved(_ sender: AnyObject) {
//        view.isUserInteractionEnabled = true
//    }
//    @IBAction func tipJarButtonPressed(_ sender: AnyObject) {
//        view.isUserInteractionEnabled = true
//        print("About to fetch the product...")
//        
//        // Can make payments
//        if (SKPaymentQueue.canMakePayments())
//        {
//            let productID:NSSet = NSSet(object: self.product_id!);
//            let productsRequest:SKProductsRequest = SKProductsRequest(productIdentifiers: productID as! Set<String>);
//            productsRequest.delegate = self;
//            productsRequest.start();
//            print("Fetching Products");
//        }else{
//            print("Can't make purchases");
//        }
//    }
//    func buyProduct(product: SKProduct){
//        print("Sending the Payment Request to Apple");
//        let payment = SKPayment(product: product)
//        SKPaymentQueue.default().add(payment);
//        
//    }
//    func productsRequest (_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
//        
//        let count : Int = response.products.count
//        if (count>0) {
//            let validProduct: SKProduct = response.products[0] as SKProduct
//            if (validProduct.productIdentifier == self.product_id) {
//                print(validProduct.localizedTitle)
//                print(validProduct.localizedDescription)
//                print(validProduct.price)
//                buyProduct(product: validProduct);
//            } else {
//                print(validProduct.productIdentifier)
//            }
//        } else {
//            print("nothing")
//        }
//    }
//    
//    
//    func request(_ request: SKRequest, didFailWithError error: Error) {
//        print("Error Fetching product information");
//    }
//    
//    func paymentQueue(_ queue: SKPaymentQueue,
//                      updatedTransactions transactions: [SKPaymentTransaction])
//        
//    {
//        print("Received Payment Transaction Response from Apple");
//        
//        for transaction:AnyObject in transactions {
//            if let trans:SKPaymentTransaction = transaction as? SKPaymentTransaction{
//                switch trans.transactionState {
//                case .purchased:
//                    print("Product Purchased");
//                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
//                    // Handle the purchase
//                    UserDefaults.standard.set(true , forKey: "purchased")
//                    
//                    // Unhide the animted supporter Label.
//                    supporterLabel.isHidden = false
//                    supporterLabel.isHidden = false
//                   
//                    // Disable the purchaseButton and restoreButton.
//                    restorePurchasesButton.isEnabled = false
//                    restorePurchasesButton.isHighlighted = true
//                    tipJarButton.isEnabled = false
//                    tipJarButton.isHighlighted = true
//                    if locale.languageCode == "de" {
//                        inAppPurchaseLabel.text = " Danke für deine Unterstützung. \n Du bist klasse!"
//                    }
//                    else {
//                        inAppPurchaseLabel.text = " Thanks for your support. \n You're awesome!"
//                    }
//
//                    // Start animation.
//                    supportAnimation()
//                    
//                    break;
//                
//                case .failed:
//                    print("Purchased Failed");
//                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
//                    break;
//                    
//                case .restored:
//                    print("Already Purchased");
//                    //SKPaymentQueue.default().restoreCompletedTransactions()
//                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
//                    
//                    // Unhide the animted supporter Label.
//                    supporterLabel.isHidden = false
//                   
//                    // Disable the purchaseButton and restoreButton.
//                    restorePurchasesButton.isEnabled = false
//                    restorePurchasesButton.isHighlighted = true
//                    tipJarButton.isEnabled = false
//                    tipJarButton.isHighlighted = true
//                    supportAnimation()
//                    if locale.languageCode == "de" {
//                        inAppPurchaseLabel.text = " Danke für deine Unterstützung. \n Du bist klasse!"
//                    }
//                    else {
//                        inAppPurchaseLabel.text = " Thanks for your support. \n You're awesome!"
//                    }
//
//                    // Handle the purchase
//                    UserDefaults.standard.set(true , forKey: "purchased")
//                    break;
//                default:
//                    break;
//                }
//            }
//        }
//        
//    }
    func supportAnimation() {
        // Animation for supporterst of the app.
        for i in 1...48 {
            if locale.languageCode == "de" {
                images.append(UIImage(named: "supporter-de-\(i)")!)
            } else {
            images.append(UIImage(named: "supporter-\(i)")!)
            }
        }
        supporterLabel.animationImages = images
        supporterLabel.animationDuration = 4.0
        supporterLabel.startAnimating()

    }
    func wakingUpFromBackground(){
        view.isUserInteractionEnabled = true
        //restorePurchasesButton.isUserInteractionEnabled = true
        //tipJarButton.isUserInteractionEnabled = true
        resetHighscore.isUserInteractionEnabled = true
        backButton.isUserInteractionEnabled = true
    }
}
