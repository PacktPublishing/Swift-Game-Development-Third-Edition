//
//  GameViewController.swift
//  SceneKitGame
//
//  Created by Siddharth Shekar on 6/12/17.
//  Copyright © 2017 Siddharth Shekar. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController {

    var gameSCNScene:GameSCNScene!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let scnView = view as! SCNView
        gameSCNScene = GameSCNScene(currentview: scnView)
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

}
