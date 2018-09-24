//
//  GameSCNScene.swift
//  SceneKitGame
//
//  Created by Siddharth Shekar on 6/12/17.
//  Copyright © 2017 Siddharth Shekar. All rights reserved.
//


import SceneKit


class GameSCNScene: SCNScene{
    
    var scnView: SCNView!
    var _size:CGSize!
    
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
        
        self.addGeometryNode()
        self.addLightSourceNode()
        self.addCameraNode()
        self.addFloorNode()
        
        //load the monster from the collada scene
        let monsterScene:SCNScene = SCNScene(named: "art.scnassets/theDude.DAE")!
        let monsterNode = monsterScene.rootNode.childNode(withName: "CATRigHub001", recursively: false)!
        self.rootNode.addChildNode(monsterNode)
        
        

    }
    
    func addGeometryNode(){
        
        let sphereGeometry = SCNSphere(radius: 1.0)
        sphereGeometry.firstMaterial?.diffuse.contents = UIColor.orange
        
        let sphereNode = SCNNode(geometry: sphereGeometry)
        sphereNode.position = SCNVector3Make(0.0, 0.0, 0.0)
        self.rootNode.addChildNode(sphereNode)
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
    
    func addCameraNode(){
        
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 40, z: 100)
        self.rootNode.addChildNode(cameraNode)
    }

    func addFloorNode(){
        
        let floorNode = SCNNode()
        floorNode.geometry = SCNFloor()
        floorNode.position.y = -1.0
        self.rootNode.addChildNode(floorNode)
    }


}

