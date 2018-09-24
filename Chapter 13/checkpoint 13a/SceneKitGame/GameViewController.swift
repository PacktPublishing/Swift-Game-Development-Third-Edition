//
//  GameViewController.swift
//  testSceneKit
//
//  Created by Siddharth Shekar on 27/11/17.
//  Copyright © 2017 Growl Games Studio. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

import GoogleMobileAds

import GameKit

class GameViewController: UIViewController,SCNSceneRendererDelegate,GADBannerViewDelegate{
    
    var gameSCNScene: GameSCNScene!
    var bannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scnView = view as! SCNView
        scnView.delegate = self
        
        gameSCNScene = GameSCNScene(currentview: scnView)
        
        //UserDefaults.standard.set(false, forKey: "removeAdsKey")
        
        if(!UserDefaults.standard.bool(forKey: "removeAdsKey")){
            bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerLandscape)
            bannerView.adUnitID = "ca-app-pub-3896672990290126/1081287272"
            bannerView.rootViewController = self
            bannerView.load(GADRequest())
            bannerView.delegate = self
        }
        
        authenticateLocalPlayer()
    }
    
    func authenticateLocalPlayer() {
        // Create a new Game Center localPlayer instance:
        let localPlayer = GKLocalPlayer.local
        // Create a function to check if they authenticated
        // or show them the log in screen:
        localPlayer.authenticateHandler =
            {(viewController, error) -> Void in
                if viewController != nil {
                    // They are not logged in, show the log in:
                    self.present(viewController!, animated: true,
                                 completion: nil)
                }
                else if localPlayer.isAuthenticated {
                    // They authenticated successfully!
                    // We will be back later to create a
                    // leaderboard button in the MenuScene
                }
                else {
                    // Not able to authenticate, skip Game Center
                }
        }
    }


    
    func renderer(_ aRenderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
        gameSCNScene.update()
        
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    
    //++++++++++++++++++++++++++++++++++++++++++
    //++++++++++ Smart Banner ad  ++++++++++++++
    //++++++++++++++++++++++++++++++++++++++++++
    
    func addBannerView(_ bannerView: GADBannerView){
        
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
            [NSLayoutConstraint(item: bannerView,
                                attribute: .bottom,
                                relatedBy: .equal,
                                toItem: view.safeAreaLayoutGuide.topAnchor ,
                                attribute: .top,
                                multiplier: 1,
                                constant: 0),
             NSLayoutConstraint(item: bannerView,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0)
            ])
        
    }
    
    /// Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        
        print("adViewDidReceiveAd")
        addBannerView(bannerView)
        
    }
    
    func removeAd(){
        print("removed ad")
        
        bannerView.removeFromSuperview()
    }
    


}
