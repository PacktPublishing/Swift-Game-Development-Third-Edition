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
    // Create our bee node as a property of GameScene so we can
    // access it throughout the class
    // (Make sure to remove the old bee declaration below)
    let bee = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        self.anchorPoint = .zero
        self.backgroundColor = UIColor(red: 0.4, green: 0.6, blue:
            0.95, alpha: 1.0)
        
        // Assign the camera to the scene
        self.camera = cam
        
        // Call the new bee function
        self.addTheFlyingBee()
        
        // Add background
        self.addBackground()
    }
    
    // A new function
    override func didSimulatePhysics() {
        // Keep the camera centered on the bee
        // Notice the ! operator after camera. SKScene's camera
        // is an optional, but we know it is there since we
        // assigned it above in the didMove function. We can tell
        // Swift that we know it can unwrap this value by using
        // the ! operator after the property name.
        self.camera!.position = bee.position
    }
    
    func addBackground(){
        
        let bg = SKSpriteNode(imageNamed:"background-menu")
        bg.position = CGPoint(x: 250, y: 250)
        self.addChild(bg)
    }
    
    // I moved all of our bee animation code into a new function:
    func addTheFlyingBee() {
        // Position our bee
        bee.position = CGPoint(x: 250, y: 250)
        bee.size = CGSize(width: 28, height: 24)
        // Add the bee to the scene
        self.addChild(bee)
        
        // Find the bee textures from the texture atlas
        let beeAtlas = SKTextureAtlas(named:"Enemies")
        let beeFrames:[SKTexture] = [
            beeAtlas.textureNamed("bee"),
            beeAtlas.textureNamed("bee-fly")]
        // Create a new SKAction to animate between the frames
        let flyAction = SKAction.animate(with: beeFrames,
                                         timePerFrame: 0.14)
        // Create an SKAction to run the flyAction repeatedly
        let beeAction = SKAction.repeatForever(flyAction)
        // Instruct our bee to run the final repeat action:
        bee.run(beeAction)
        
        // Set up new actions to move our bee back and forth:
        let pathLeft =
            SKAction.moveBy(x: -200, y: -10, duration: 2)
        let pathRight =
            SKAction.moveBy(x: 200, y: 10, duration: 2)
        let flipTextureNegative =
            SKAction.scaleX(to: -1, duration: 0)
        let flipTexturePositive =
            SKAction.scaleX(to: 1, duration: 0)
        // Combine actions into a cohesive flight sequence
        let flightOfTheBee = SKAction.sequence([
            pathLeft,flipTextureNegative, pathRight,
            flipTexturePositive])
        // Last, create a looping action that will repeat forever
        let neverEndingFlight =
            SKAction.repeatForever(flightOfTheBee)
        
        // Tell our bee to run the flight path, and away it goes!
        bee.run(neverEndingFlight)
    }
}

