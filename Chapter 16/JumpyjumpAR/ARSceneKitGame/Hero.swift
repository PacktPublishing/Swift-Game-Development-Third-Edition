//
//  Hero.swift
//  testSceneKit
//
//  Created by Siddharth Shekar on 28/11/17.
//  Copyright © 2017 Growl Games Studio. All rights reserved.
//

import SceneKit
import ARKit

class Hero:SCNNode{
    
    var isGrounded = false
    
    var monsterNode  = SCNNode()
    var jumpPlayer = SCNAnimationPlayer()
    var runPlayer = SCNAnimationPlayer()
    

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func time(atFrame frame:Int, fps:Double = 30) -> TimeInterval {
        return TimeInterval(frame) / fps
    }
    static func timeRange(forStartingAtFrame start:Int, endingAtFrame end:Int, fps:Double = 30) -> (offset:TimeInterval, duration:TimeInterval) {
        let startTime   = self.time(atFrame: start, fps: fps)
        let endTime     = self.time(atFrame: end, fps: fps)
        return (offset:startTime, duration:endTime - startTime)
    }

    static func animation(from full:CAAnimation, startingAtFrame start:Int, endingAtFrame end:Int, fps:Double = 30) -> CAAnimation {
        let range = self.timeRange(forStartingAtFrame: start, endingAtFrame: end, fps: fps)
        let animation = CAAnimationGroup()
        let sub = full.copy() as! CAAnimation
        sub.timeOffset = range.offset
        animation.animations = [sub]
        animation.duration = range.duration
        return animation
    }
    
    init(_ currentScene: SCNScene, _ spawnPositon: SCNVector3){
        super.init()
        
        //load the monster from the collada scene
        let monsterScene:SCNScene = SCNScene(named: "art.scnassets/theDude.DAE")!
        monsterNode = monsterScene.rootNode.childNode(withName: "CATRigHub001", recursively: false)! //CATRigHub001
        self.addChildNode(monsterNode)
        
        // set the anchor point to the center of the character
        let (minVec, maxVec)  = self.boundingBox
        let bound = SCNVector3(x: maxVec.x - minVec.x, y: maxVec.y - minVec.y,z: maxVec.z - minVec.z)
        monsterNode.pivot = SCNMatrix4MakeTranslation(bound.x * 1.1, 0 , 0)
        
        // get the animation keys and store it in the anims
        let animKeys = monsterNode.animationKeys.first
        let animPlayer = monsterNode.animationPlayer(forKey: animKeys!)
        let anims = CAAnimation(scnAnimation: (animPlayer?.animation)!)
        
        // get the run animation from the animations
        let runAnimation = Hero.animation(from: anims, startingAtFrame: 31, endingAtFrame: 50)
        runAnimation.repeatCount = .greatestFiniteMagnitude
        runAnimation.fadeInDuration = 0.0
        runAnimation.fadeOutDuration = 0.0
        
        //set the run animation to the player
        runPlayer = SCNAnimationPlayer(animation: SCNAnimation(caAnimation: runAnimation))
        monsterNode.addAnimationPlayer(runPlayer, forKey: "run")
        
        
        // get the jump animation from the animations
        let jumpAnimation = Hero.animation(from: anims, startingAtFrame:81, endingAtFrame: 100)
        jumpAnimation.repeatCount = .greatestFiniteMagnitude
        jumpAnimation.fadeInDuration = 0.0
        jumpAnimation.fadeOutDuration = 0.0
        
        //set the jump animation to the player
        jumpPlayer = SCNAnimationPlayer(animation: SCNAnimation(caAnimation: jumpAnimation))
        monsterNode.addAnimationPlayer(jumpPlayer, forKey: "jump")
        
        //remove all the animations from the character
        monsterNode.removeAllAnimations()
        
        // play the run animation at start
        monsterNode.animationPlayer(forKey: "run")?.play()
        
        // set the collision box for the character
        let collisionBox = SCNBox(width: 2/100.0, height: 8/100.0, length: 2/100.0, chamferRadius: 0)
        collisionBox.firstMaterial?.diffuse.contents = UIColor.orange
        
       
        //self.geometry = collisionBox
        
        self.physicsBody = SCNPhysicsBody(type: .dynamic, shape:SCNPhysicsShape(geometry: collisionBox, options:nil))
        self.physicsBody?.categoryBitMask = PhysicsCategory.hero.rawValue
        self.physicsBody?.collisionBitMask = PhysicsCategory.ground.rawValue
        self.physicsBody!.contactTestBitMask = PhysicsCategory.enemy.rawValue | PhysicsCategory.ground.rawValue
        
        // set angular velocity factor to 0 so that the character deosnt keel over
        self.physicsBody?.angularVelocityFactor = SCNVector3(0, 0, 0)
        self.physicsBody?.restitution = 0.0
        // set the mass so that the character gets affected by gravity
        self.physicsBody?.mass = 20/100.0 //4.5
        
        
        self.transform = SCNMatrix4MakeRotation(Float(.pi / 2.0), 0.0, 1.0, 0.0)
        
      
        
        //set the scale and name of the current class
        self.scale = SCNVector3(0.1/100.0, 0.1/100.0, 0.1/100.0)
        
        self.name = "hero"
        
        self.position = SCNVector3(spawnPositon.x, spawnPositon.y + 0.25, spawnPositon.z)
        
       
        // add the current node to the parent scene
        currentScene.rootNode.addChildNode(self)
        
    }
    
    func jump(){
        
        //print("player jump")
        
        if(isGrounded == true){
            //print("grounded")
            self.physicsBody?.applyForce(SCNVector3Make(0, 0.2, 0), asImpulse: true) //1400
            isGrounded = false
            playJumpAnim()
        }
    }
    
    func playRunAnim(){
        
        monsterNode.removeAllAnimations()
        monsterNode.addAnimationPlayer(runPlayer, forKey: "run")
        monsterNode.animationPlayer(forKey: "run")?.play()
        
    }
    
    func playJumpAnim(){
        
        monsterNode.removeAllAnimations()
        monsterNode.addAnimationPlayer(jumpPlayer, forKey: "jump")
        monsterNode.animationPlayer(forKey: "jump")?.play()
        
    }
    
    
}// end class
