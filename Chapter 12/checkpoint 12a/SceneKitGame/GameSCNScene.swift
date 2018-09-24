//
//  testScene.swift
//  sceneKitTest
//
//  Created by siddharthshekar on 11/6/14.
//  Copyright (c) 2014 siddharthshekar. All rights reserved.
//

import Foundation
import UIKit
import SceneKit
import SpriteKit




enum PhysicsCategory:Int {
    case hero = 1
    case ground = 2
    case enemy = 4
}

class GameSCNScene: SCNScene,SCNPhysicsContactDelegate {

    
    var scnView: SCNView!
    var _size:CGSize!
    
    var gameOver = true
    var score:Int = 0

    var hero:Hero!
    var enemy :Enemy!
    var skScene:OverlaySKScene!
    var scrollingBackground=ScrollingBackground()



    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(currentview view: SCNView) {
        
        super.init()
        
        scnView = view
        _size = scnView.bounds.size
        
        scnView.scene = self
        scnView.allowsCameraControl = true
        scnView.showsStatistics = true
        scnView.backgroundColor = UIColor.blue
    
        self.physicsWorld.gravity = SCNVector3Make(0, -500, 0)
        self.physicsWorld.contactDelegate = self
        
        scnView.debugOptions = SCNDebugOptions.showPhysicsShapes
        
        self.hero = Hero(currentScene:self)
        hero.position = SCNVector3Make(0, 5, 0)
        
        self.enemy = Enemy(currentScene: self)
        
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: -30, y: 5, z: 12)
        cameraNode.eulerAngles.y -= Float(Double.pi/2)
        self.rootNode.addChildNode(cameraNode)
        
        self.addLightSourceNode()
        
        //add ground node
        let groundBox = SCNBox(width: 10, height: 2, length: 10, chamferRadius: 0)
        let groundNode = SCNNode(geometry: groundBox)
        
        groundNode.position = SCNVector3Make(0, -1.01, 0)
        groundNode.physicsBody = SCNPhysicsBody.static()
        groundNode.physicsBody?.restitution = 0.0
        groundNode.physicsBody?.friction = 1.0
        groundNode.physicsBody?.categoryBitMask = PhysicsCategory.ground.rawValue
        groundNode.physicsBody?.contactTestBitMask = PhysicsCategory.hero.rawValue
        groundNode.name = "ground"
        
        self.rootNode.addChildNode(groundNode)
        
        //add spritekit overlay
        skScene = OverlaySKScene(size: _size, gameScene: self)
        scnView.overlaySKScene = skScene
        skScene.scaleMode = SKSceneScaleMode.fill
        
        //add scrolling backgrounf
        self.scrollingBackground.create(currentScene: self)
        
        // add particle system
        let rain = SCNParticleSystem(named: "rain", inDirectory: nil)
        rain!.warmupDuration = 10
        
        let particleEmitterNode = SCNNode()
        particleEmitterNode.position = SCNVector3(0, 100, 0)
        particleEmitterNode.addParticleSystem(rain!)
        self.rootNode.addChildNode(particleEmitterNode)
    
        
    }
    
    // MARK: - Game Begin
    
    func startGame(){
        
        gameOver = false
        skScene.jumpBtn.isHidden = false
        skScene.myLabel.isHidden = false
        skScene.playBtn.isHidden = true
        skScene.gameOverLabel.isHidden = true
        
        if(!UserDefaults.standard.bool(forKey: "removeAdsKey")){
            skScene.noAdsBtn.isHidden = true
        }
        
        score = 0
        skScene.myLabel.text = "Score: \(score)"
        
    }
    
    // MARK: - Game Loop
    func update() {
    
         hero.update()
         scrollingBackground.update()
        
        if(!gameOver){
             enemy.update()
        }
    }
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        
        //print("begin contact")
        
        if( (contact.nodeA.name == "hero" && contact.nodeB.name == "enemy") ){
            
            contact.nodeA.physicsBody?.velocity = SCNVector3Zero
            gameOver = true
            GameOver()
        }
        
    }
    
    func GameOver(){
        
        skScene.jumpBtn.isHidden = true
        skScene.playBtn.isHidden = false
        skScene.gameOverLabel.isHidden = false
       
        if(!UserDefaults.standard.bool(forKey: "removeAdsKey")){
            skScene.noAdsBtn.isHidden = false
        }
        
        //reset hero and enemy position
        enemy.position = SCNVector3Make(0, 2.0 , 60.0)
        hero.position = SCNVector3Make(0, 5, 0)
    }
    
    func heroJump(){
        hero.jump()
    }
    
    
    func addLightSourceNode(){
        
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = SCNLight.LightType.omni
        lightNode.position = SCNVector3(x: 10, y: 10, z: 10)
        self.rootNode.addChildNode(lightNode)
        
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = SCNLight.LightType.ambient
        ambientLightNode.light!.color = UIColor.darkGray
        self.rootNode.addChildNode(ambientLightNode)
    }
    

    

}//end class

