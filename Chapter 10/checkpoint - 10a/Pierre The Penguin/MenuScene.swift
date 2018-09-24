//
//  MenuScene.swift
//  Pierre The Penguin
//
//  Created by Siddharth Shekar on 24/11/17.
//  Copyright © 2017 Growl Games Studio. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {
    // Grab the HUD sprite atlas:
    let textureAtlas:SKTextureAtlas = SKTextureAtlas(named:"HUD")
    // Instantiate a sprite node for the start button
    // (we'll use this in a moment):
    let startButton = SKSpriteNode()
    let optionsButton = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        
        // Position nodes from the center of the scene:
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        // Add the background image:
        let backgroundImage = SKSpriteNode(imageNamed: "background-menu")
        backgroundImage.size = CGSize(width: 1024, height: 768)
        backgroundImage.zPosition = -1
        self.addChild(backgroundImage)
        
        // Draw the name of the game:
        let logoText = SKLabelNode(fontNamed: "AvenirNext-Heavy")
        logoText.text = "Pierre Penguin"
        logoText.position = CGPoint(x: 0, y: 100)
        logoText.fontSize = 60
        self.addChild(logoText)
        // Add another line below:
        let logoTextBottom = SKLabelNode(fontNamed:
            "AvenirNext-Heavy")
        logoTextBottom.text = "Escapes the Antarctic"
        logoTextBottom.position = CGPoint(x: 0, y: 50)
        logoTextBottom.fontSize = 40
        self.addChild(logoTextBottom)

        // Build the start game button:
        startButton.texture = textureAtlas.textureNamed("button")
        startButton.size = CGSize(width: 295, height: 76)
        // Name the start node for touch detection:
        startButton.name = "StartBtn"
        startButton.position = CGPoint(x: 0, y: -20)
        self.addChild(startButton)
        
        // Add text to the start button:
        let startText = SKLabelNode(fontNamed:
            "AvenirNext-HeavyItalic")
        startText.text = "START GAME"
        startText.verticalAlignmentMode = .center
        startText.position = CGPoint(x: 0, y: 2)
        startText.fontSize = 40
        // Name the text node for touch detection:
        startText.name = "StartBtn"
        startText.zPosition = 5
        startButton.addChild(startText)
        
        // Pulse the start text in and out gently:
        let pulseAction = SKAction.sequence([
            SKAction.fadeAlpha(to: 0.5, duration: 0.9),
            SKAction.fadeAlpha(to: 1, duration: 0.9),
            ])
        startText.run(SKAction.repeatForever(pulseAction))
        
        
        
        //options menu button
        optionsButton.texture = textureAtlas.textureNamed("button-options")
        optionsButton.name = "OptionsBtn"
        optionsButton.position = CGPoint(x: 0, y: -120)
        optionsButton.size = CGSize(width: 75, height: 75)
        self.addChild(optionsButton)

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in (touches) {
            // Find the location of the touch:
            let location = touch.location(in: self)
            // Locate the node at this location:
            let nodeTouched = atPoint(location)
            
            if nodeTouched.name == "StartBtn" {
                // Player touched the start text or button node
                // Switch to an instance of the GameScene:
                self.view?.presentScene(GameScene(size: self.size))
            }else if nodeTouched.name == "OptionsBtn"{
                self.view?.presentScene(OptionsScene(size: self.size))
            }
        }
    }

}

