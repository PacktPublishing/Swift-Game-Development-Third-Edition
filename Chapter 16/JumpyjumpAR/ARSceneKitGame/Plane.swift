//
//  Plane.swift
//  ARSceneKitGame
//
//  Created by Siddharth Shekar on 1/20/18.
//  Copyright © 2018 Siddharth Shekar. All rights reserved.
//

import Foundation
import SceneKit
import ARKit

class Plane: SCNNode{
    
    
    var planeGeometry: SCNPlane!
    
    init(_ anchor: ARPlaneAnchor){
    
        super.init()
    
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "plane.png")
        
        self.planeGeometry = SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))
        planeGeometry.materials = [material]
        
    let planeNode = SCNNode(geometry: self.planeGeometry)
        planeNode.position = SCNVector3Make(anchor.center.x, 0, anchor.center.z)
        planeNode.transform = SCNMatrix4MakeRotation(Float(-.pi / 2.0), 1.0, 0.0, 0.0)
        
        setTextureScale()
        
        self.addChildNode(planeNode)
        
        print("plane added")
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(_ anchor: ARPlaneAnchor){
        
        self.planeGeometry.width = CGFloat(anchor.extent.x)
        self.planeGeometry.height = CGFloat(anchor.extent.z)
        self.position = SCNVector3Make(anchor.center.x, 0, anchor.center.z);
        setTextureScale()
        
    }
    
    func setTextureScale(){
        
        let width = self.planeGeometry.width
        let height = self.planeGeometry.height
        
        let material = self.planeGeometry.materials.first
        material?.diffuse.contentsTransform = SCNMatrix4MakeScale(Float(width), Float(height), 1);
        material?.diffuse.wrapS = SCNWrapMode.repeat
        material?.diffuse.wrapT = SCNWrapMode.repeat
        
    }
    
}
