//
//  GameScene.swift
//  Pierre The Penguin
//
//  Created by Siddharth Shekar on 3/11/17.
//  Copyright © 2017 Growl Games Studio. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    // Create a constant cam as a SKCameraNode:
    let cam = SKCameraNode()
    
    // replace the bee variable with the new player
    let player = Player()
    
    let ground = Ground()
    
    override func didMove(to view: SKView) {
        self.anchorPoint = .zero
        self.backgroundColor = UIColor(red: 0.4, green: 0.6, blue:
            0.95, alpha: 1.0)
        
        // Assign the camera to the scene
        self.camera = cam
        
        //add a second bee
        let bee2 = Bee()
        bee2.position = CGPoint(x:325, y: 325)
        self.addChild(bee2)
        
        //add third bee
        let bee3 = Bee()
        bee3.position = CGPoint(x: 200, y : 325)
        self.addChild(bee3)
        
        // Position the ground based on the screen size.
        // Position X: Negative one screen width.
        // Position Y: 150 above the bottom (remember the top
        // left anchor point).
        ground.position = CGPoint(x: -self.size.width * 2, y: 150)
        // Set the ground width to 3x the width of the scene
        // The height can be 0, our child nodes will create the height
        ground.size = CGSize(width: self.size.width * 6, height: 0)
        // Run the ground's createChildren function to build
        // the child texture tiles:
        ground.createChildren()
        // Add the ground node to the scene:
        self.addChild(ground)

        //Add the player to the scene
        player.position = CGPoint(x: 150, y:250)
        self.addChild(player)

    }
    
    // A new function
    override func didSimulatePhysics() {
        // Keep the camera centered on the bee
        // Notice the ! operator after camera. SKScene's camera
        // is an optional, but we know it is there since we
        // assigned it above in the didMove function. We can tell
        // Swift that we know it can unwrap this value by using
        // the ! operator after the property name.
        self.camera!.position = player.position
    }
    

}

