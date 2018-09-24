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
    
    // Store whether we are flapping our wings or in free-fall:
    var flapping = false
    // Set a maximum upward force.
    // 57,000 feels good to me, adjust to taste:
    let maxFlappingForce:CGFloat = 57000
    // Pierre should slow down when he flies too high:
    let maxHeight:CGFloat = 1000
    
    // The player will be able to take 3 hits before game over:
    var health:Int = 3
    // Keep track of when the player is invulnerable:
    var invulnerable = false
    // Keep track of when the player is newly damaged:
    var damaged = false
    // We will create animations to run when the player takes
    // damage or dies. Add these properties to store them:
    var damageAnimation = SKAction()
    var dieAnimation = SKAction()
    // We want to stop forward velocity if the player dies,
    // so we will now store forward velocity as a property:
    var forwardVelocity:CGFloat = 200

    
    init() {
        // Call the init function on the
        // base class (SKSpriteNode)
        super.init(texture: nil, color: .clear, size:
            initialSize)
        
        createAnimations()
        
        self.run(soarAnimation, withKey: "soarAnimation")
        
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
        
        //Assigning Category, Collision and Contact bitmasks
        self.physicsBody?.categoryBitMask =             PhysicsCategory.penguin.rawValue
        
        self.physicsBody?.collisionBitMask =            PhysicsCategory.ground.rawValue
       
        self.physicsBody?.contactTestBitMask =          PhysicsCategory.enemy.rawValue |
                                                        PhysicsCategory.ground.rawValue |
                                                        PhysicsCategory.powerup.rawValue |
                                                        PhysicsCategory.coin.rawValue
        
        
        // Grant a momentary reprieve from gravity:
        self.physicsBody?.affectedByGravity = false
        // Add some slight upward velocity:
        self.physicsBody?.velocity.dy = 80
        // Create a SKAction to start gravity after a small delay:
        let startGravitySequence = SKAction.sequence([
            SKAction.wait(forDuration: 0.6),
            SKAction.run {
                self.physicsBody?.affectedByGravity = true
            }])
        self.run(startGravitySequence)

    }
    
    func update(){
        
        // If flapping, apply a new force to push Pierre higher.
        if self.flapping {
            var forceToApply = maxFlappingForce
            
            // Apply less force if Pierre is above position 600
            if position.y > 600 {
                // The higher Pierre goes, the more force we
                // remove. These next three lines determine the
                // force to subtract:
                let percentageOfMaxHeight = position.y / maxHeight
                let flappingForceSubtraction =
                    percentageOfMaxHeight * maxFlappingForce
                forceToApply -= flappingForceSubtraction
            }
            // Apply the final force:
            self.physicsBody?.applyForce(CGVector(dx: 0, dy:
                forceToApply))
        }
        
        // Limit Pierre's top speed as he climbs the y-axis.
        // This prevents him from gaining enough momentum to shoot
        // over our max height. We bend the physics for game play:
        if self.physicsBody!.velocity.dy > 300 {
            self.physicsBody!.velocity.dy = 300
        }

        // Set a constant velocity to the right:
        self.physicsBody?.velocity.dx = self.forwardVelocity

        
    }//update function
    
    // Implement onTap to conform to the GameSprite protocol:
    func onTap() {
        
        
    }
    
    // Begin the flap animation, set flapping to true:
    func startFlapping() {
        
        if self.health <= 0 { return }
        
        self.removeAction(forKey: "soarAnimation")
        self.run(flyAnimation, withKey: "flapAnimation")
        self.flapping = true
    }
    
    // Stop the flap animation, set flapping to false:
    func stopFlapping() {
        
        if self.health <= 0 { return }
        
        self.removeAction(forKey: "flapAnimation")
        self.run(soarAnimation, withKey: "soarAnimation")
        self.flapping = false
    }
    
    func die() {
        // Make sure the player is fully visible:
        self.alpha = 1
        // Remove all animations:
        self.removeAllActions()
        // Run the die animation:
        self.run(self.dieAnimation)
        // Prevent any further upward movement:
        self.flapping = false
        // Stop forward movement:
        self.forwardVelocity = 0
        
        // Alert the GameScene:
        if let gameScene = self.parent as? GameScene {
            gameScene.gameOver()
        }

    }
    
    func takeDamage() {
        // If invulnerable or damaged, return:
        if self.invulnerable || self.damaged { return }
        
        // Set the damaged state to true after being hit:
        self.damaged = true
        
        // Remove one from our health pool
        self.health -= 1
        if self.health == 0 {
            // If we are out of health, run the die function:
            die()
        }
        else {
            // Run the take damage animation:
            self.run(self.damageAnimation)
        }
    }

    func starPower() {
        // Remove any existing star power-up animation, if
        // the player is already under the power of star
        self.removeAction(forKey: "starPower")
        // Grant great forward speed:
        self.forwardVelocity = 400
        // Make the player invulnerable:
        self.invulnerable = true
        // Create a sequence to scale the player larger,
        // wait 8 seconds, then scale back down and turn off
        // invulnerability, returning the player to normal:
        let starSequence = SKAction.sequence([
            SKAction.scale(to: 1.5, duration: 0.3),
            SKAction.wait(forDuration: 8),
            SKAction.scale(to: 1, duration: 1),
            SKAction.run {
                self.forwardVelocity = 200
                self.invulnerable = false
            }
            ])
        // Execute the sequence:
        self.run(starSequence, withKey: "starPower")
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
        
        // --- Create the taking damage animation ---
        let damageStart = SKAction.run {
            // Allow the penguin to pass through enemies:
            self.physicsBody?.categoryBitMask =
                PhysicsCategory.damagedPenguin.rawValue
        }
        // Create an opacity pulse, slow at first and fast at the end:
        let slowFade = SKAction.sequence([
            SKAction.fadeAlpha(to: 0.3, duration: 0.35),
            SKAction.fadeAlpha(to: 0.7, duration: 0.35)
            ])
        let fastFade = SKAction.sequence([
            SKAction.fadeAlpha(to: 0.3, duration: 0.2),
            SKAction.fadeAlpha(to: 0.7, duration: 0.2)
            ])
        let fadeOutAndIn = SKAction.sequence([
            SKAction.repeat(slowFade, count: 2),
            SKAction.repeat(fastFade, count: 5),
            SKAction.fadeAlpha(to: 1, duration: 0.15)
            ])
        // Return the penguin to normal:
        let damageEnd = SKAction.run {
            self.physicsBody?.categoryBitMask =
                PhysicsCategory.penguin.rawValue
            // Turn off the newly damaged flag:
            self.damaged = false
        }
        // Store the whole sequence in the damageAnimation property:
        self.damageAnimation = SKAction.sequence([
            damageStart,
            fadeOutAndIn,
            damageEnd
            ])
        
        /* --- Create the death animation --- */
        let startDie = SKAction.run {
            // Switch to the death texture with X eyes:
            self.texture =
                self.textureAtlas.textureNamed("pierre-dead")
            // Suspend the penguin in space:
            self.physicsBody?.affectedByGravity = false
            // Stop any movement:
            self.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        }
        
        let endDie = SKAction.run {
            // Turn gravity back on:
            self.physicsBody?.affectedByGravity = true
        }
        
        self.dieAnimation = SKAction.sequence([
            startDie,
            // Scale the penguin bigger:
            SKAction.scale(to: 1.3, duration: 0.5),
            // Use the waitForDuration action to provide a short pause:
            SKAction.wait(forDuration: 0.5),
            // Rotate the penguin on to his back:
            SKAction.rotate(toAngle: 3, duration: 1.5),
            SKAction.wait(forDuration: 0.5),
            endDie
            ])


    }
    

    
    // Satisfy the NSCoder required init:
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

