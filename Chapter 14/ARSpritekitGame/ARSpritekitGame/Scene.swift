//
//  Scene.swift
//  ARSpritekitGame
//
//  Created by Siddharth Shekar on 21/12/17.
//  Copyright © 2017 Siddharth Shekar. All rights reserved.
//

import SpriteKit
import ARKit

class Scene: SKScene {
    
   
    var crosshair: SKSpriteNode!
    let scoreText = SKLabelNode(text: "00")
    
    var creationTime : TimeInterval = 0
    var score: Int = 0
    
    func randomFloat(min: Float, max: Float) -> Float {
        return (Float(arc4random()) / 0xFFFFFFFF) * (max - min) + min
    }
    
    var sceneView: ARSKView {
        return view as! ARSKView
    }
    
    override func didMove(to view: SKView) {
        // Setup your scene here
        
        crosshair = SKSpriteNode(imageNamed: "crosshair")
        addChild(crosshair)
        
        scoreText.fontName = "AvenirNext-HeavyItalic"
        let coinTextPosition = CGPoint(x: view.bounds.width * 0.4,
                                       y: view.bounds.height * 0.4)
        scoreText.position = coinTextPosition
        scoreText.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        scoreText.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        self.addChild(scoreText)
        
        srand48(Int(Date.timeIntervalSinceReferenceDate))
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        if currentTime > creationTime {
            createAnchorNode()
            creationTime = currentTime + TimeInterval(randomFloat(min: 2.0, max: 6.0))
        }
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        print("touch")
        
        let location = crosshair.position
        let hitNodes = nodes(at: location)
        
        for node in hitNodes {
            
            if(node.name == "enemy"){
        
                node.removeFromParent()
                
                score-=1
                self.scoreText.text = "\(score)"
                
                break
            }
        }
    }
    
    func createAnchorNode(){
        
        var translation = matrix_identity_float4x4
        translation.columns.3.x = randomFloat(min: -1.0, max: 1.0)
        translation.columns.3.y = randomFloat(min: -1.0, max: 1.0)
        translation.columns.3.z = randomFloat(min: -1.0, max: -0.5)
        
        // Add a new anchor to the session
        let anchor = ARAnchor(transform: translation)
        sceneView.session.add(anchor: anchor)
            
        score+=1
        self.scoreText.text = "\(score)"

    }

}// end of class

