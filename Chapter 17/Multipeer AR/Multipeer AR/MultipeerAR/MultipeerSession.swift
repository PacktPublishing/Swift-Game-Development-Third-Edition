//
//  MultipeerSession.swift
//  MultipeerAR
//
//  Created by siddharthshekar on 2/09/18.
//  Copyright © 2018 siddharthshekar. All rights reserved.
//

import MultipeerConnectivity


/// - Tag: MultipeerSession
class MultipeerSession: NSObject{
   
    // Limited to 15 ASCII characters
    static let serviceType = "ar-multi-sample"
    
    // Name of current device
    private let myPeerID = MCPeerID(displayName: UIDevice.current.name)
    
    var browser:MCBrowserViewController!
    var advertiser:MCAdvertiserAssistant? = nil
    var session: MCSession!
    
    let receivedDataHandler: (Data, MCPeerID) -> Void
    
    /// - Tag: MultipeerSetup
    init(receivedDataHandler: @escaping (Data, MCPeerID) -> Void ) {
        
        self.receivedDataHandler = receivedDataHandler
        
        super.init()
        
        session = MCSession(peer: myPeerID, securityIdentity: nil, encryptionPreference: .required)
        session.delegate = self
        
    }
    
    func advertiseSelf(){
        
        advertiser = MCAdvertiserAssistant(serviceType: MultipeerSession.serviceType, discoveryInfo: nil, session: session)
        
        advertiser!.start()
    }
    
    func setupBrowser(){
    
        browser = MCBrowserViewController(serviceType: MultipeerSession.serviceType, session: session )
        browser.maximumNumberOfPeers = 1
        browser.minimumNumberOfPeers = 1
    }
    

    func sendToAllPeers(_ data: Data) {
        do {
            try session.send(data, toPeers: session.connectedPeers, with: .reliable) // TCP / UDP modes
        } catch {
            print("error sending data to peers: \(error.localizedDescription)")
        }
    }
    
    
    var connectedPeers: [MCPeerID] {
        return session.connectedPeers
    }


}



extension MultipeerSession: MCSessionDelegate {
    
    // When a user connects or disconnects from our session, the method
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        
        switch state {
            case MCSessionState.connected:
                print("Connected: \(peerID.displayName)")
            
            case MCSessionState.connecting:
                print("Connecting: \(peerID.displayName)")
            
            case MCSessionState.notConnected:
                print("Not Connected: \(peerID.displayName)")
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        
        // - Received data
        
        receivedDataHandler(data, peerID)
    }
    
    // - Used for continuesly updating player information
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        fatalError("This service does not send/receive streams.")
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        fatalError("This service does not send/receive resources.")
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        fatalError("This service does not send/receive resources.")
    }
    
}

