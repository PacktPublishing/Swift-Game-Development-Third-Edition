//
//  Star.swift
//  Pierre The Penguin
//
//  Created by Siddharth Shekar on 15/11/17.
//  Copyright © 2017 Growl Games Studio. All rights reserved.
//

import SpriteKit

class Star: SKSpriteNode, GameSprite {
    var initialSize = CGSize(width: 40, height: 38)
    var textureAtlas:SKTextureAtlas =
        SKTextureAtlas(named: "Environment")
    var pulseAnimation = SKAction()
    
    init() {
        let starTexture =
            textureAtlas.textureNamed("star")
        super.init(texture: starTexture, color: .clear,
                   size: initialSize)
        // Assign a physics body:
        self.physicsBody = SKPhysicsBody(circleOfRadius:
            size.width / 2)
        self.physicsBody?.affectedByGravity = false
        // Create our star animation and start it:
        createAnimations()
        self.run(pulseAnimation)
        
        self.physicsBody?.categoryBitMask =    PhysicsCategory.powerup.rawValue

    }
    
    func createAnimations() {
        // Scale the star smaller and fade it slightly:
        let pulseOutGroup = SKAction.group([
            SKAction.fadeAlpha(to: 0.85, duration: 0.8),
            SKAction.scale(to: 0.6, duration: 0.8),
            SKAction.rotate(byAngle: -0.3, duration: 0.8)
            ])
        // Push the star big again, and fade it back in:
        let pulseInGroup = SKAction.group([
            SKAction.fadeAlpha(to: 1, duration: 1.5),
            SKAction.scale(to: 1, duration: 1.5),
            SKAction.rotate(byAngle: 3.5, duration: 1.5)
            ])
        // Combine the two into a sequence:
        let pulseSequence = SKAction.sequence([pulseOutGroup,
                                               pulseInGroup])
        pulseAnimation =
            SKAction.repeatForever(pulseSequence)
    }
    
    // Required to conform to protocols:
    func onTap() {}
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

