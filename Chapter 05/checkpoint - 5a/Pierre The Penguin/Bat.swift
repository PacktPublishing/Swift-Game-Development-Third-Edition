//
//  Bat.swift
//  Pierre The Penguin
//
//  Created by Siddharth Shekar on 15/11/17.
//  Copyright © 2017 Growl Games Studio. All rights reserved.
//

import SpriteKit

class Bat: SKSpriteNode, GameSprite {
    var initialSize = CGSize(width: 44, height: 24)
    var textureAtlas:SKTextureAtlas =
        SKTextureAtlas(named: "Enemies")
    var flyAnimation = SKAction()
    
    init() {
        super.init(texture: nil, color: .clear,
                   size: initialSize)
        self.physicsBody = SKPhysicsBody(circleOfRadius:
            size.width / 2)
        self.physicsBody?.affectedByGravity = false
        createAnimations()
        self.run(flyAnimation)
    }
    
    func createAnimations() {
        let flyFrames:[SKTexture] = [
            textureAtlas.textureNamed("bat"),
            textureAtlas.textureNamed("bat-fly")
        ]
        let flyAction = SKAction.animate(with: flyFrames,
                                         timePerFrame: 0.12)
        flyAnimation = SKAction.repeatForever(flyAction)
    }
    
    func onTap() {}
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

