//
//  Ground.swift
//  Pierre The Penguin
//
//  Created by Siddharth Shekar on 10/11/17.
//  Copyright © 2017 Growl Games Studio. All rights reserved.
//

import SpriteKit

// A new class, inheriting from SKSpriteNode and
// adhering to the GameSprite protocol.
class Ground: SKSpriteNode, GameSprite {
    
    
    
    var textureAtlas:SKTextureAtlas = SKTextureAtlas(named: "Environment")
    
    
    // We will not use initialSize for ground, but we still need
    // to declare it to conform to our GameSprite protocol:
    var initialSize = CGSize.zero
    
    var jumpWidth = CGFloat()
    // Note the instantiation value of 1 here:
    var jumpCount = CGFloat(1)

    
    // This function tiles the ground texture across the width
    // of the Ground node. We will call it from our GameScene.
    func createChildren() {
        // This is one of those unique situations where we use a
        // non-default anchor point. By positioning the ground by
        // its top left corner, we can place it just slightly
        // above the bottom of the screen, on any of screen size.
        self.anchorPoint = CGPoint(x: 0, y: 1)
        
        // First, load the ground texture from the atlas:
        let texture = textureAtlas.textureNamed("ground")
        
        var tileCount:CGFloat = 0
        // We will size the tiles in their point size
        // They are 35 points wide and 300 points tall
        let tileSize = CGSize(width: 35, height: 300)
        
        // Build nodes until we cover the entire Ground width
        while tileCount * tileSize.width < self.size.width {
            let tileNode = SKSpriteNode(texture: texture)
            tileNode.size = tileSize
            tileNode.position.x = tileCount * tileSize.width
            // Position child nodes by their upper left corner
            tileNode.anchorPoint = CGPoint(x: 0, y: 1)
            // Add the child texture to the ground node:
            self.addChild(tileNode)
            
            tileCount += 1
        }
        
        // Note: physics body positions are relative to their nodes.
        // The top left of the node is X: 0, Y: 0, given our anchor point.
        // The top right of the node is X: size.width, Y: 0
        let pointTopLeft = CGPoint(x: 0, y: 0)
        let pointTopRight = CGPoint(x: size.width, y: 0)
        self.physicsBody = SKPhysicsBody(edgeFrom: pointTopLeft, to: pointTopRight)
        
        // Save the width of one-third of the children nodes
        jumpWidth = tileSize.width * floor(tileCount / 3)


    }
    
    func checkForReposition(playerProgress:CGFloat) {
        // The ground needs to jump forward
        // every time the player has moved this distance:
        let groundJumpPosition = jumpWidth * jumpCount
        
        if playerProgress >= groundJumpPosition {
            // The player has moved past the jump position!
            // Move the ground forward:
            self.position.x += jumpWidth
            // Add one to the jump count:
            jumpCount += 1
        }
    }

    
    // Implement onTap to adhere to the protocol:
    func onTap() {}
}

