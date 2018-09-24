//
//  Crate.swift
//  Pierre The Penguin
//
//  Created by Siddharth Shekar on 27/11/17.
//  Copyright © 2017 Growl Games Studio. All rights reserved.
//

import SpriteKit

class Crate: SKSpriteNode, GameSprite {
    var initialSize = CGSize(width: 40, height: 40)
    var textureAtlas:SKTextureAtlas =
        SKTextureAtlas(named: "Environment")
    var givesHeart = false
    var exploded = false
    
    init() {
        super.init(texture: nil, color: UIColor.clear,
                   size: initialSize)
        self.physicsBody = SKPhysicsBody(rectangleOf:
            initialSize)
        
        // Only collide with the ground and other crates:
        self.physicsBody?.collisionBitMask =
            PhysicsCategory.ground.rawValue |
            PhysicsCategory.crate.rawValue
        self.physicsBody?.categoryBitMask =
            PhysicsCategory.crate.rawValue
        
        self.texture = textureAtlas.textureNamed("crate")
    }
    
    // A function to create a crate that gives health:
    func turnToHeartCrate() {
        self.physicsBody?.affectedByGravity = false
        self.texture =
            textureAtlas.textureNamed("crate-power-up")
        givesHeart = true
    }
    
    // A function for exploding crates!
    func explode() {
        // Do not do anything if already exploded:
        if exploded { return }
        exploded = true
        
        // Prevent additional contact:
        self.physicsBody?.categoryBitMask = 0
        // TODO: We will add more here in a bit
    }
    
    // A function to reset the crate for re-use
    func reset() {
        self.alpha = 1
        self.physicsBody?.categoryBitMask =
            PhysicsCategory.crate.rawValue
        exploded = false
    }
    // Conform to the necessary protocols:
    func onTap() {}
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

