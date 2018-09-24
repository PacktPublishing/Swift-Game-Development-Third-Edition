//
//  ScrollingBackground.swift
//  testSceneKit
//
//  Created by Siddharth Shekar on 28/11/17.
//  Copyright © 2017 Growl Games Studio. All rights reserved.
//

import SceneKit

class ScrollingBackground{
    
    var parallaxWallNode1: SCNNode!
    var parallaxWallNode2: SCNNode!
    var parallaxFloorNode1: SCNNode!
    var parallaxFloorNode2: SCNNode!
    
    
    func create(currentScene: GameSCNScene){
        
        //Preparing Wall geometry
        let wallGeometry = SCNPlane(width: 250, height: 120)
        wallGeometry.firstMaterial?.diffuse.contents = "monster.scnassets/wall.png"
        wallGeometry.firstMaterial?.diffuse.wrapS = SCNWrapMode.repeat
        wallGeometry.firstMaterial?.diffuse.wrapT = SCNWrapMode.repeat
        wallGeometry.firstMaterial?.diffuse.mipFilter = SCNFilterMode.linear
        wallGeometry.firstMaterial?.diffuse.contentsTransform = SCNMatrix4MakeScale(6.25, 3.0, 1.0)
        
        wallGeometry.firstMaterial?.normal.contents = "monster.scnassets/wall_NRM.png"
        wallGeometry.firstMaterial?.normal.wrapS = SCNWrapMode.repeat
        wallGeometry.firstMaterial?.normal.wrapT = SCNWrapMode.repeat
        wallGeometry.firstMaterial?.normal.mipFilter = SCNFilterMode.linear
        wallGeometry.firstMaterial?.normal.contentsTransform = SCNMatrix4MakeScale(6.25, 3.0, 1.0)
        
        wallGeometry.firstMaterial?.specular.contents = "monster.scnassets/wall_SPEC.png"
        wallGeometry.firstMaterial?.specular.wrapS = SCNWrapMode.repeat
        wallGeometry.firstMaterial?.specular.wrapT = SCNWrapMode.repeat
        wallGeometry.firstMaterial?.specular.mipFilter = SCNFilterMode.linear
        wallGeometry.firstMaterial?.specular.contentsTransform = SCNMatrix4MakeScale(6.25, 3.0, 1.0)
        
        wallGeometry.firstMaterial?.locksAmbientWithDiffuse = true
        
        //Preparing floor geometry

        let floorGeometry = SCNPlane(width: 120, height: 250)
        floorGeometry.firstMaterial?.diffuse.contents = "monster.scnassets/floor.png"
        floorGeometry.firstMaterial?.diffuse.wrapS = SCNWrapMode.repeat
        floorGeometry.firstMaterial?.diffuse.wrapT = SCNWrapMode.repeat
        floorGeometry.firstMaterial?.diffuse.mipFilter = SCNFilterMode.linear
        floorGeometry.firstMaterial?.diffuse.contentsTransform = SCNMatrix4MakeScale(12.0, 25, 1.0)
        
        floorGeometry.firstMaterial?.normal.contents = "monster.scnassets/floor_NRM.png"
        floorGeometry.firstMaterial?.normal.wrapS = SCNWrapMode.repeat
        floorGeometry.firstMaterial?.normal.wrapT = SCNWrapMode.repeat
        floorGeometry.firstMaterial?.normal.mipFilter = SCNFilterMode.linear
        floorGeometry.firstMaterial?.normal.contentsTransform = SCNMatrix4MakeScale(24.0, 50, 1.0)
        
        floorGeometry.firstMaterial?.specular.contents = "monster.scnassets/floor_SPEC.png"
        floorGeometry.firstMaterial?.specular.wrapS = SCNWrapMode.repeat
        floorGeometry.firstMaterial?.specular.wrapT = SCNWrapMode.repeat
        floorGeometry.firstMaterial?.specular.mipFilter = SCNFilterMode.linear
        floorGeometry.firstMaterial?.specular.contentsTransform = SCNMatrix4MakeScale(24.0, 50, 1.0)
        
        floorGeometry.firstMaterial?.locksAmbientWithDiffuse = true
        
        //assign wall geometry to wall nodes

        parallaxWallNode1 = SCNNode(geometry: wallGeometry)
        parallaxWallNode1.rotation = SCNVector4Make(0, 1, 0, Float(-Double.pi / 2))
        parallaxWallNode1.position = SCNVector3Make(15, 0, 0)
        currentScene.rootNode.addChildNode(parallaxWallNode1)
        
        parallaxWallNode2 = SCNNode(geometry: wallGeometry)
        parallaxWallNode2.rotation = SCNVector4Make(0, 1, 0, Float(-Double.pi / 2))
        parallaxWallNode2.position = SCNVector3Make(15, 0, 250)
        currentScene.rootNode.addChildNode(parallaxWallNode2)
        
        
        //assign floor geometry to floor nodes
        //floors
        parallaxFloorNode1 = SCNNode(geometry: floorGeometry)
        parallaxFloorNode1.rotation = SCNVector4Make(0, 1, 0, Float(-Double.pi / 2))
        parallaxFloorNode1.rotation = SCNVector4Make(1, 0, 0, Float(-Double.pi / 2))
        
        parallaxFloorNode1.position = SCNVector3Make(15, 0, 0)
        currentScene.rootNode.addChildNode(parallaxFloorNode1)
        
        
        parallaxFloorNode2 = SCNNode(geometry: floorGeometry)
        parallaxFloorNode2.rotation = SCNVector4Make(0, 1, 0, Float(-Double.pi / 2))
        parallaxFloorNode2.rotation = SCNVector4Make(1, 0, 0, Float(-Double.pi / 2))
        
        parallaxFloorNode2.position = SCNVector3Make(15, 0, 250)
        currentScene.rootNode.addChildNode(parallaxFloorNode2)
        
      
        
    }
    
    func update(){
        
        parallaxWallNode1.position.z += -0.5
        parallaxWallNode2.position.z += -0.5
        parallaxFloorNode1.position.z += -0.5
        parallaxFloorNode2.position.z += -0.5
        
        
        if((parallaxWallNode1.position.z + 250) <= 0){
            self.parallaxWallNode1.position = SCNVector3Make(15, 0, 250)
        }
        
        if((parallaxWallNode2.position.z + 250) <= 0){
            self.parallaxWallNode2.position = SCNVector3Make(15, 0, 250)
        }
        
        if((parallaxFloorNode1.position.z + 250) <= 0){
            self.parallaxFloorNode1.position = SCNVector3Make(15, 0, 250)
        }
        
        if((parallaxFloorNode2.position.z + 250) <= 0){
           self.parallaxFloorNode2.position = SCNVector3Make(15, 0, 250)
        }
        
    }
    
}//class end
