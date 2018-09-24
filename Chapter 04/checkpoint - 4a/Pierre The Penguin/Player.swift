//
//  Player.swift
//  Pierre The Penguin
//
//  Created by Siddharth Shekar on 10/11/17.
//  Copyright © 2017 Growl Games Studio. All rights reserved.
//

import SpriteKit

class Player : SKSpriteNode, GameSprite {
    var initialSize = CGSize(width: 64, height: 64)
    var textureAtlas:SKTextureAtlas =
        SKTextureAtlas(named:"Pierre")
    // Pierre has multiple animations. Right now, we will
    // create one animation for flying up,
    // and one for going down:
    var flyAnimation = SKAction()
    var soarAnimation = SKAction()
    
    init() {
        // Call the init function on the
        // base class (SKSpriteNode)
        super.init(texture: nil, color: .clear, size:
            initialSize)
        
        createAnimations()
        
        // If we run an action with a key, "flapAnimation",
        // we can later reference that
        // key to remove the action.
        self.run(flyAnimation, withKey: "flapAnimation")
        
        // Create a physics body based on one frame of Pierre's animation.
        // We will use the third frame, when his wings are tucked in
        let bodyTexture = textureAtlas.textureNamed("pierre-flying-3")
        self.physicsBody = SKPhysicsBody(
            texture: bodyTexture, size: self.size)
        // Pierre will lose momentum quickly with a high linearDamping:
        self.physicsBody?.linearDamping = 0.9
        // Adult penguins weigh around 30kg:
        self.physicsBody?.mass = 30
        // Prevent Pierre from rotating:
        self.physicsBody?.allowsRotation = false

    }
    
    func update(){
        
    }
    
    func createAnimations() {
        let rotateUpAction =
            SKAction.rotate(toAngle: 0, duration: 0.475)
        rotateUpAction.timingMode = .easeOut
        let rotateDownAction = SKAction.rotate(toAngle: -1,
                                               duration: 0.8)
        rotateDownAction.timingMode = .easeIn
        
        // Create the flying animation:
        let flyFrames:[SKTexture] = [
            textureAtlas.textureNamed("pierre-flying-1"),
            textureAtlas.textureNamed("pierre-flying-2"),
            textureAtlas.textureNamed("pierre-flying-3"),
            textureAtlas.textureNamed("pierre-flying-4"),
            textureAtlas.textureNamed("pierre-flying-3"),
            textureAtlas.textureNamed("pierre-flying-2")
        ]
        let flyAction = SKAction.animate(with: flyFrames,
                                         timePerFrame: 0.03)
        // Group together the flying animation with rotation:
        flyAnimation = SKAction.group([
            SKAction.repeatForever(flyAction),
            rotateUpAction
            ])
        
        // Create the soaring animation,
        // just one frame for now:
        let soarFrames:[SKTexture] =
            [textureAtlas.textureNamed("pierre-flying-1")]
        let soarAction = SKAction.animate(with: soarFrames,
                                          timePerFrame: 1)
        // Group the soaring animation with the rotation down:
        soarAnimation = SKAction.group([
            SKAction.repeatForever(soarAction),
            rotateDownAction
            ])
    }
    
    // Implement onTap to conform to the GameSprite protocol:
    func onTap() {}
    
    // Satisfy the NSCoder required init:
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

