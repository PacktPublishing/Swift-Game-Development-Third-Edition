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

class GameViewController: UIViewController,SCNSceneRendererDelegate {

      var gameSCNScene: GameSCNScene!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scnView = view as! SCNView
        scnView.delegate = self
        
        gameSCNScene = GameSCNScene(currentview: scnView)
        
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

}
