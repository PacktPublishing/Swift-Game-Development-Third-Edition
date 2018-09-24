//
//  Coin.swift
//  Pierre The Penguin
//
//  Created by Siddharth Shekar on 15/11/17.
//  Copyright © 2017 Growl Games Studio. All rights reserved.
//

import SpriteKit

class Coin: SKSpriteNode, GameSprite {
    var initialSize = CGSize(width: 26, height: 26)
    var textureAtlas:SKTextureAtlas =
        SKTextureAtlas(named: "Environment")
    var value = 1
    
    init() {
        let bronzeTexture =
            textureAtlas.textureNamed("coin-bronze")
        super.init(texture: bronzeTexture, color: .clear,
                   size: initialSize)
        self.physicsBody = SKPhysicsBody(circleOfRadius:
            size.width / 2)
        self.physicsBody?.affectedByGravity = false
    }
    
    // A function to transform this coin into gold!
    func turnToGold() {
        self.texture =
            textureAtlas.textureNamed("coin-gold")
        self.value = 5
    }
    
    func onTap() {}
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

