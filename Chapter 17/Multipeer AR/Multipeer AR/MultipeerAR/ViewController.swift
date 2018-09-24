//
//  ViewController.swift
//  MultipeerAR
//
//  Created by siddharthshekar on 2/09/18.
//  Copyright © 2018 siddharthshekar. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import MultipeerConnectivity

class ViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate, MCBrowserViewControllerDelegate {
    
    // MARK: - IBOutlets
    
    // session info view at the top left of the screen
    @IBOutlet weak var sessionInfoView: UIView!
    
    // scene view
    @IBOutlet weak var sceneView: ARSCNView!
    
    //text label inside the info view on top left
    @IBOutlet weak var sessionInfoLabel: UILabel!
    
    // text lable at the bottom middle above the button
    @IBOutlet weak var mappingStatusLabel: UILabel!
    
    @IBOutlet weak var sendMapButton: UIButton!
    
    @IBOutlet weak var hostButton: UIButton!
    
    @IBOutlet weak var joinButton: UIButton!
    
    @IBOutlet var tapRecogniser: UITapGestureRecognizer!
    
    var multipeerSession: MultipeerSession!
    
    var isTrackingEnabled = false;
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        
        multipeerSession.browser.dismiss(animated: true, completion: { () -> Void in
            
            print(" pressed done ")
            
            self.hostButton.isHidden = true
            self.joinButton.isHidden = true;
            
        })
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        multipeerSession.browser.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        multipeerSession = MultipeerSession(receivedDataHandler: receivedData)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        guard ARWorldTrackingConfiguration.isSupported else {
            fatalError("""
                ARKit is not available on this device.
            """)
        }
        
        // Prevent the screen from being dimmed after a while as users will likely
        // have long periods of interaction without touching the screen or buttons.
        UIApplication.shared.isIdleTimerDisabled = true
        
        hostButton.layer.cornerRadius = 0.125 * hostButton.bounds.size.width
        joinButton.layer.cornerRadius = 0.125 * joinButton.bounds.size.width
        
        
        tapRecogniser.isEnabled = false
        
        sendMapButton.isHidden = true;
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's AR session.
        sceneView.session.pause()
    }
    
    
    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        if let name = anchor.name, name.hasPrefix("hero") {
            
            node.addChildNode(loadPlayerModel())
        }
    }
    
    // MARK: - ARSessionDelegate
    
    /// - Tag: CheckMappingStatus
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        
        // Checks mapping status depending on whether
        // if the environment is mapped or not
        // Greys out or enables the button.
        
        if isTrackingEnabled {
        
            switch frame.worldMappingStatus {
        
            case .notAvailable, .limited:
                sendMapButton.isEnabled = false
            case .extending:
                sendMapButton.isEnabled = false
           
            case .mapped:
                
                if(!multipeerSession.connectedPeers.isEmpty){
                
                    sendMapButton.isEnabled = true;
                
                    tapRecogniser.isEnabled = true
                
                    isTrackingEnabled = false
                }
            }
            
            //-- Mapping status label above the mapping button
            //-- Description is in utilities
            
            mappingStatusLabel.text = frame.worldMappingStatus.description
            
            //-- Session info label
            //-- On the top left of the screen
            updateSessionInfoLabel(for: frame, trackingState: frame.camera.trackingState)
            
        }
        
    }
    
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        
        updateSessionInfoLabel(for: session.currentFrame!, trackingState: camera.trackingState)
        
    }
    
    // MARK: - ARSessionObserver
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay.
        sessionInfoLabel.text = "Session was interrupted"
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required.
        sessionInfoLabel.text = "Session interruption ended"
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user.
        sessionInfoLabel.text = "Session failed: \(error.localizedDescription)"
    }
    
    func sessionShouldAttemptRelocalization(_ session: ARSession) -> Bool {
        return true
    }
    
    
    // MARK: - Buttons and Touches
    
    @IBAction func hostSession(_ sender: Any) {
       
        // Start the view's AR session.
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration)
        
        // Set a delegate to track the number of plane anchors for providing UI feedback.
        sceneView.session.delegate = self
        
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        multipeerSession.advertiseSelf()
        
        hostButton.isHidden = true
        joinButton.isHidden = true;
        
        isTrackingEnabled = true;
        
        sendMapButton.isHidden = false;
    
    }
    
    @IBAction func joinSession(_ sender: Any) {
    
        if multipeerSession.session != nil{
            
            multipeerSession.setupBrowser()
            multipeerSession.browser.delegate = self
            
            self.present(multipeerSession.browser, animated: true, completion: nil)
        }
    }
    
    /// - Tag: GetWorldMap
    
    // Sends ONLY worldmap details to all peers
    // button press at the middle of bottom of screen
    @IBAction func shareSession(_ button: UIButton) {
        
        //1. Attempt To Get The World Map From Our ARSession
        
        sceneView.session.getCurrentWorldMap { worldMap, error in
            
            guard let map = worldMap
                else { print("Error: \(error!.localizedDescription)"); return }
            
            //2. We Have A Valid ARWorldMap So Send It To Any Peers
            guard let data = try? NSKeyedArchiver.archivedData(withRootObject: map, requiringSecureCoding: true)
                else { fatalError("can't encode map") }
            
            self.multipeerSession.sendToAllPeers(data)
            
            self.sendMapButton.isHidden = true
            
        }// get world map function
    }
    
    
    /// - Tag: PlaceCharacter
    
    // -- Tap gesture action
    // -- Sends ONLY anchor details
    
    @IBAction func handleSceneTap(_ sender: UITapGestureRecognizer) {
        
        // -- Hit test to find a place for a virtual object.

        guard let hitTestResult = sceneView
            .hitTest(sender.location(in: sceneView), types: [.existingPlaneUsingGeometry, .estimatedHorizontalPlane])
            .first
            else { return }
        
        // -- Place an anchor for a virtual character. The model appears in renderer(_:didAdd:for:).
        // -- Create Our Anchor & Add It To The Scene
        
        let anchor = ARAnchor(name: "hero", transform: hitTestResult.worldTransform)
        sceneView.session.add(anchor: anchor)
        
        // -- Send the anchor info to peers, so they can place the same content.
        // -- Share The Angle, Rotation & Scale With Peers
        guard let data = try? NSKeyedArchiver.archivedData(withRootObject: anchor, requiringSecureCoding: true)
            else { fatalError("can't encode anchor") }
        self.multipeerSession.sendToAllPeers(data)
    }
    

    // MARK: - Received Data Handler Functions
    
    var mapProvider: MCPeerID?

    /// - Tag: ReceiveData
    // - Data receiver handler passed into the MultipeerSession class in viewDidLoad function
    func receivedData(_ data: Data, from peer: MCPeerID) {
        
            
            if  let unarchivedMap = try? NSKeyedUnarchiver.unarchivedObject(ofClasses: [ARWorldMap.classForKeyedUnarchiver()], from: data),
            
            // -- 1. Try To UnArchive Our Data As An ARWorldMap
                
                let worldMap = unarchivedMap as? ARWorldMap {
                
                // A map is available run/ restart the session with the received world map.
                let configuration = ARWorldTrackingConfiguration()
                configuration.planeDetection = .horizontal
                configuration.initialWorldMap = worldMap
                sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
                
                // Remember who provided the map for showing UI feedback.
                mapProvider = peer
                
                
                if(!multipeerSession.connectedPeers.isEmpty){
                    
                    // Enable tap recognizer on client
                    tapRecogniser.isEnabled = true
                }
                
            }
                
            // -- 2. Try To Unarchive Our Data As An ARAnchor
           
            else if let unarchivedAnchor = try? NSKeyedUnarchiver.unarchivedObject(ofClasses: [ARAnchor.classForKeyedUnarchiver()], from: data),
                
                let anchor = unarchivedAnchor as? ARAnchor  {

                // Add anchor to the session, ARSCNView delegate adds visible content.
                sceneView.session.add(anchor: anchor)
                
            }
            
            // -- 3. Unknown data type or cant decode data
            else {
                print("unknown data recieved from \(peer)")
            }

    }
    
    // MARK: - Helper Functions
    
    private func updateSessionInfoLabel(for frame: ARFrame, trackingState: ARCamera.TrackingState) {
        
        // tracking staus
        
        // Update the UI to provide feedback on the state of the AR experience.
        
        let message: String
        
        switch trackingState {
            
        case .normal where frame.anchors.isEmpty && multipeerSession.connectedPeers.isEmpty:
            // No planes detected; provide instructions for this app's AR interactions.
            message = "Move around to map the environment, or wait to join a shared session."
            
        case .normal where !multipeerSession.connectedPeers.isEmpty && mapProvider == nil:
            let peerNames = multipeerSession.connectedPeers.map({ $0.displayName }).joined(separator: ", ")
            message = "Connected with \(peerNames)."
            
        case .notAvailable:
            message = "Tracking unavailable."
            
        case .limited(.excessiveMotion):
            message = "Tracking limited - Move the device more slowly."
            
        case .limited(.insufficientFeatures):
            message = "Tracking limited - Point the device at an area with visible surface detail, or improve lighting conditions."
            
        case .limited(.initializing) where mapProvider != nil,
             .limited(.relocalizing) where mapProvider != nil:
            message = "Received map from \(mapProvider!.displayName)."
            
        case .limited(.relocalizing):
            message = "Resuming session — move to where you were when the session was interrupted."
            
        case .limited(.initializing):
            message = "Initializing AR session."
            
        default:
            // No feedback needed when tracking is normal and planes are visible.
            // (Nor when in unreachable limited-tracking states.)
            message = ""
            
        }
        
        sessionInfoLabel.text = message
        sessionInfoView.isHidden = message.isEmpty
    }

    
    
    
    // MARK: - Load player model
    
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
    
    
    // load monster model
    private func loadPlayerModel() -> SCNNode {
        
        // -- Load the monster from the collada scene
        
        let tempNode:SCNNode = SCNNode()
        let monsterScene:SCNScene = SCNScene(named: "Assets.scnassets/theDude.DAE")!
        let referenceNode = monsterScene.rootNode.childNode(withName: "CATRigHub001", recursively: false)! //CATRigHub001
        tempNode.addChildNode(referenceNode)
       
        
        // -- Set the anchor point to the center of the character
        let (minVec, maxVec)  = tempNode.boundingBox
        let bound = SCNVector3(x: maxVec.x - minVec.x, y: maxVec.y - minVec.y,z: maxVec.z - minVec.z)
        tempNode.pivot = SCNMatrix4MakeTranslation(bound.x * 1.1, 0 , 0)
        
        // -- Set the scale and name of the current class
        tempNode.scale = SCNVector3(0.1/100.0, 0.1/100.0, 0.1/100.0)
        
        
        // -- Get the animation keys and store it in the anims
        let animKeys = referenceNode.animationKeys.first
        let animPlayer = referenceNode.animationPlayer(forKey: animKeys!)
        let anims = CAAnimation(scnAnimation: (animPlayer?.animation)!)
        
        
        // -- Get the run animation from the animations
        let runAnimation = ViewController.animation(from: anims, startingAtFrame: 31, endingAtFrame: 50)
        runAnimation.repeatCount = .greatestFiniteMagnitude
        runAnimation.fadeInDuration = 0.0
        runAnimation.fadeOutDuration = 0.0
        
        // -- Remove all the animations from the character
        referenceNode.removeAllAnimations()
        
        // -- Set the run animation to the player
        let runPlayer = SCNAnimationPlayer(animation: SCNAnimation(caAnimation: runAnimation))
        tempNode.addAnimationPlayer(runPlayer, forKey: "run")
        
        // -- Play the run animation at start
        tempNode.animationPlayer(forKey: "run")?.play()
        
        return tempNode
    }
    
    
}


extension ARFrame.WorldMappingStatus: CustomStringConvertible {
    public var description: String {
        switch self {
        case .notAvailable:
            return "Not Available"
        case .limited:
            return "Limited"
        case .extending:
            return "Extending"
        case .mapped:
            return "Mapped"
        }
    }
}

