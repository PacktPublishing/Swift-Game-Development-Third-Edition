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
    
    func explode(gameScene:GameScene) {
    // Do not do anything if this crate already exploded:
    if exploded { return }
    exploded = true
    
    // Place a crate explosion at this location:
    gameScene.particlePool.placeEmitter(node: self,
    emitterType: "crate")
    // Fade out the crate sprite:
    self.run(SKAction.fadeAlpha(to: 0, duration: 0.1))
    
    if (givesHeart) {
    // If this is a heart crate, award a health point:
    let newHealth = gameScene.player.health + 1
    let maxHealth = gameScene.player.maxHealth
    gameScene.player.health = newHealth > maxHealth ?
    maxHealth : newHealth
    gameScene.hud.setHealthDisplay(newHealth:
    gameScene.player.health)
    // Place a heart explosion at this location:
    gameScene.particlePool.placeEmitter(node: self,
    emitterType: "heart")
    }
    else {
    // Otherwise, reward the player with coins:
    gameScene.coinsCollected += 1
    gameScene.hud.setCoinCountDisplay(newCoinCount:
    gameScene.coinsCollected)
    }
    
    // Prevent additional contact:
    self.physicsBody?.categoryBitMask = 0
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

