//
//  ViewController.swift
//  ARSpritekitGame
//
//  Created by Siddharth Shekar on 21/12/17.
//  Copyright © 2017 Siddharth Shekar. All rights reserved.
//

import UIKit
import SpriteKit
import ARKit

class ViewController: UIViewController, ARSKViewDelegate {
    
    @IBOutlet var sceneView: ARSKView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as? ARSKView {
        
            // Set the view's delegate
            sceneView.delegate = self
        
            // Show statistics such as fps and node count
            sceneView.showsFPS = true
            sceneView.showsNodeCount = true
        
            let scene = Scene(size: view.bounds.size)
            scene.scaleMode = .resizeFill
            scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            view.presentScene(scene)
        
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    // MARK: - ARSKViewDelegate
    
    func randomInt(min: Int, max: Int) -> Int {
        return min + Int(arc4random_uniform(UInt32(max - min + 1)))
    }
    
    func view(_ view: ARSKView, nodeFor anchor: ARAnchor) -> SKNode? {
        
        //let labelNode = SKLabelNode(text: "👾")
        //labelNode.horizontalAlignmentMode = .center
        //labelNode.verticalAlignmentMode = .center
        //return labelNode;

        
        
        var gameNode: SKSpriteNode!
        let random = randomInt(min: 1, max: 3)
        
        switch random {
        case 1:
            gameNode = Bat()
        case 2:
            gameNode = Bee()
        case 3:
            gameNode = MadFly()
        default:
            print(" cannot load enemy ")
        }

        gameNode.name = "enemy"
        
        return gameNode
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
