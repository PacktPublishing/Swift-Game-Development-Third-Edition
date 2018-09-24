//
//  ParticlePool.swift
//  Pierre The Penguin
//
//  Created by Siddharth Shekar on 27/11/17.
//  Copyright © 2017 Growl Games Studio. All rights reserved.
//

import SpriteKit

class ParticlePool {
        var cratePool:[SKEmitterNode] = []
        var heartPool:[SKEmitterNode] = []
        var crateIndex = 0
        var heartIndex = 0
        // A property to store a reference to the GameScene:
        var gameScene = SKScene()
    
        init() {
            // Create 5 crate explosion emitter nodes:
            for i in 1...5 {
                // Create a crate emitter node:
                let crate = SKEmitterNode(fileNamed:
                    "CrateExplosion")!
                crate.position = CGPoint(x: -2000, y: -2000)
                crate.zPosition = CGFloat(45 - i)
                crate.name = "crate" + String(i)
                // Add the emitter to the crate pool array:
                cratePool.append(crate)
            }
            // Repeat these steps to create 1 heart emitter:
            for i in 1...1 {
                let heart = SKEmitterNode(fileNamed:
                    "HeartExplosion")!
                heart.position = CGPoint(x: -2000, y: -2000)
                heart.zPosition = CGFloat(45 - i)
                heart.name = "heart" + String(i)
                heartPool.append(heart)
            }
        }
    
        // Called from GameScene to add emitters as children
        func addEmittersToScene(scene:GameScene) {
            self.gameScene = scene
            // Add the crate emitters to the scene:
            for i in 0..<cratePool.count {
                self.gameScene.addChild(cratePool[i])
            }
            // Add the heart emitters to the scene:
            for i in 0..<heartPool.count {
                self.gameScene.addChild(heartPool[i])
            }
        }
    
        // We will use this function to reposition the
        // next pooled node into the desired position
        func placeEmitter(node:SKNode, emitterType:String)
        {
            // Pull an emitter node from the correct pool:
            var emitter:SKEmitterNode
            switch emitterType {
            case "crate":
                emitter = cratePool[crateIndex]
                // Keep track of the next node to pull:
                crateIndex += 1
                if crateIndex >= cratePool.count {
                    crateIndex = 0
                }
            case "heart":
                emitter = heartPool[heartIndex]
                heartIndex += 1
                if heartIndex >= heartPool.count {
                    heartIndex = 0
                }
            default:
                return
            }
            
            // Find the node's position relative to GameScene:
            var absolutePosition = node.position
            if node.parent != gameScene {
                absolutePosition =
                    gameScene.convert(node.position, from:
                        node.parent!)
            }
            
            // Position the emitter on top of the node:
            emitter.position = absolutePosition
            // Restart the emitter animation:
            emitter.resetSimulation()
    }

}
