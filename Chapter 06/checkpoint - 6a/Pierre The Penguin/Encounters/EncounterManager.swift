//
//  EncounterManager.swift
//  Pierre The Penguin
//
//  Created by Siddharth Shekar on 11/17/17.
//  Copyright © 2017 Growl Games Studio. All rights reserved.
//

import SpriteKit

class EncounterManager {
    // Store your encounter file names:
    let encounterNames:[String] = [
        "EncounterA"
    ]
    // Each encounter is an SKNode, store an array:
    var encounters:[SKNode] = []
    
    init() {
        // Loop through each encounter scene:
        for encounterFileName in encounterNames {
            // Create a new node for the encounter:
            let encounterNode = SKNode()
            
            // Load this scene file into a SKScene instance:
            if let encounterScene = SKScene(fileNamed:
                encounterFileName) {
                // Loop through each child node in the SKScene
                for child in encounterScene.children {
                    // Create a copy of the scene's child node
                    // to add to our encounter node:
                    let copyOfNode = type(of: child).init()
                    // Save the scene node's position to the copy:
                    copyOfNode.position = child.position
                    // Save the scene node's name to the copy:
                    copyOfNode.name = child.name
                    // Add the copy to our encounter node:
                    encounterNode.addChild(copyOfNode)
                }
            }
            
            // Add the populated encounter node to the array:
            encounters.append(encounterNode)
        }
    }
    
    // We will call this addEncountersToScene function from
    // the GameScene to append all of the encounter nodes to the
    // world node from our GameScene:
    func addEncountersToScene(gameScene:SKNode) {
        var encounterPosY = 1000
        for encounterNode in encounters {
            // Spawn the encounters behind the action, with
            // increasing height so they do not collide:
            encounterNode.position = CGPoint(x: -2000,
                                             y: encounterPosY)
            gameScene.addChild(encounterNode)
            // Double the Y pos for the next encounter:
            encounterPosY *= 2
        }
    }
}

