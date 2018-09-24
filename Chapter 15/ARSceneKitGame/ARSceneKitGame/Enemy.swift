//
//  Enemy.swift
//  testSceneKit
//
//  Created by Siddharth Shekar on 28/11/17.
//  Copyright © 2017 Growl Games Studio. All rights reserved.
//

import SceneKit

class Enemy:SCNNode{
    
    var _currentScene: SCNScene!
    var spawnPos: SCNVector3!
    
    var score:Int = 0
    
    init(_ currentScene: SCNScene, _ spawnPositon: SCNVector3){
        
        super.init()
        
        
        print("spawn enemy")
        
        self._currentScene = currentScene
        self.spawnPos = spawnPositon
        
        spawnPos = SCNVector3(spawnPos.x + 0.8,spawnPos.y + 2.0/100, spawnPos.z)
        
        let geo = SCNBox(width: 4.0/100.0, height: 4.0/100.0, length: 4.0/100.0, chamferRadius: 0.0)
        geo.firstMaterial?.diffuse.contents = UIColor.yellow
        
        self.geometry = geo
        
        self.position = spawnPos
        self.physicsBody = SCNPhysicsBody.kinematic()
        self.name = "enemy"
        
        self.physicsBody?.categoryBitMask = PhysicsCategory.enemy.rawValue
        self.physicsBody?.contactTestBitMask = PhysicsCategory.hero.rawValue
        
        currentScene.rootNode.addChildNode(self)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func update(){
        
        self.position.x += -0.9/100.0
        
        if((self.position.x - 5.0/100.0) < -60/100.0){
            
            let factor = arc4random_uniform(2) + 1
            
            if( factor == 1 ){
                self.position = spawnPos
            }else{
                self.position = SCNVector3Make(spawnPos.x, spawnPos.y + 0.1 , spawnPos.z)
            }
            
            score += 1
        }
    }
    
    func reset(){
        
        self.position = spawnPos
        self.score = 0
        
    }
    
    
}// end class
