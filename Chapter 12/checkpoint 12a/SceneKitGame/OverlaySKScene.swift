//
//  GameScene.swift
//  spriteKitTest
//
//  Created by siddharthshekar on 11/6/14.
//  Copyright (c) 2014 siddharthshekar. All rights reserved.
//

import SpriteKit


import UIKit
import StoreKit

class OverlaySKScene: SKScene,SKPaymentTransactionObserver, SKProductsRequestDelegate {
    
    
    var _gameScene: GameSCNScene!
    var myLabel: SKLabelNode!
    var gameOverLabel: SKLabelNode!
    var jumpBtn: SKSpriteNode!
    var playBtn: SKSpriteNode!
    var noAdsBtn:SKSpriteNode!
    
    var request : SKProductsRequest!
    var products : [SKProduct] = []
    var noAdsPurchased = false
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(size: CGSize, gameScene: GameSCNScene){
        super.init(size: size)
        
        _gameScene = gameScene
        
        myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Score: 0";
        myLabel.fontColor = UIColor.white
        myLabel.fontSize = 65;
        myLabel.setScale(0.75)
        myLabel.position = CGPoint(x: size.width * 0.5, y: size.height * 0.8)
        self.addChild(myLabel)
        
        playBtn = SKSpriteNode(imageNamed: "playBtn")
        playBtn.position = CGPoint(x: size.width * 0.15, y: size.height * 0.2)
        playBtn.setScale(0.5)
        self.addChild(playBtn)
        playBtn.name = "playBtn"
        
        jumpBtn = SKSpriteNode(imageNamed: "jumpBtn")
        jumpBtn.position = CGPoint(x: size.width * 0.9, y: size.height * 0.15)
        jumpBtn.setScale(0.75)
        self.addChild(jumpBtn)
        jumpBtn.name = "jumpBtn"
        jumpBtn.isHidden = true
        
        gameOverLabel = SKLabelNode(fontNamed:"Chalkduster")
        gameOverLabel.text = "GAMEOVER";
        gameOverLabel.fontSize = 100;
        gameOverLabel.setScale(0.75)
        gameOverLabel.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        gameOverLabel.fontColor = UIColor.white
        self.addChild(gameOverLabel)
        gameOverLabel.isHidden = true
        
        if(!UserDefaults.standard.bool(forKey: "removeAdsKey")){
            
            initInAppPurchases()
            
            noAdsBtn = SKSpriteNode(imageNamed: "noAdsBtn")
            noAdsBtn.position = CGPoint(x: size.width * 0.9, y: size.height * 0.8)
            noAdsBtn.setScale(0.75)
            self.addChild(noAdsBtn)
            noAdsBtn.name = "noAdsBtn"
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            
            let _node:SKNode = self.atPoint(location);
            
            if(_gameScene.gameOver == false){
                if(_node.name == "jumpBtn"){
                    _gameScene.heroJump()
                }
            }else{
                if(_node.name == "playBtn"){
                    _gameScene.startGame()
                }else if (_node.name == "noAdsBtn"){
                    inAppPurchase()
                }
            }
        }
    }
    

    //++++++++++++++++++++++++++++++
    //++++++ inApp purhchase ++++++
    //++++++++++++++++++++++++++++++
    

    func inAppPurchase(){
        
        let alert = UIAlertController(title: "In App Purchases", message: "", preferredStyle: UIAlertController.Style.alert)
        
        for i in 0 ..< products.count{
            let currentProduct = products[i]
            
            if(currentProduct.productIdentifier == "removead" && noAdsPurchased == false){
                
                print("removead found")
                
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .currency
                numberFormatter.locale = currentProduct.priceLocale
                
                alert.addAction(UIAlertAction(title:currentProduct.localizedTitle + " : " + numberFormatter.string(from:           currentProduct.price)!,style:UIAlertAction.Style.default){_ in
                    
                    self.buyProduct(product: currentProduct)
                    
                })
            }
        }
        
        if(noAdsPurchased == false){
            alert.addAction(UIAlertAction(title:"Restore", style:UIAlertAction.Style.default){_ in
                self.restorePurchaseProducts()
            })
        }
        
        
        alert.addAction(UIAlertAction(title:"Cancel",style:UIAlertAction.Style.default){_ in
            print("cancelled purchase")
        })
        
        _gameScene.scnView?.window?.rootViewController?.present(alert, animated: true, completion: nil)
        
    }//inapppurchase
    
    
    // Buy the product
    func buyProduct(product: SKProduct) {
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    

    //Called when processing the purchase
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction in transactions {
            
            switch(transaction.transactionState){
                
            case .purchasing:
                print("Transaction State: Purchasing")
            case .purchased:
                if transaction.payment.productIdentifier == "removead" {
                    print("Transaction State: Purchased")
                    handleNoAdsPurchased()
                }
                queue.finishTransaction(transaction)
            case .failed:
                print("Payment Error: %@", transaction.error!)
                queue.finishTransaction(transaction)
            case .restored:
                if transaction.payment.productIdentifier == "removead" {
                    print("Transaction State: Restored")
                    handleNoAdsPurchased()
                }
                queue.finishTransaction(transaction)
            case .deferred:
                print("Transaction State: %@", transaction.transactionState)
            }//switch
        }//for loop
    }//payment queue
    
    func handleNoAdsPurchased(){
        noAdsPurchased = true
    
        noAdsBtn.isHidden = true
        
        UserDefaults.standard.set(true, forKey: "removeAdsKey")
        
        let controller = _gameScene.scnView?.window?.rootViewController as! GameViewController
        controller.removeAd()

    }

    // Initialize the App Purchases
    func initInAppPurchases() {
        print("In App Purchases Initialized")
        
        SKPaymentQueue.default().add(self)
        
        // Get the list of possible purchases
        if self.request == nil {
            self.request = SKProductsRequest(productIdentifiers: Set(["removead"]))
            self.request.delegate = self
            self.request.start()
        }
    }
    
    
    
    //Called when appstore responds and populates the products array
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
        print("products request received")
        
        self.products = response.products
        self.request = nil
        
        print("products count: ", products.count)
        
        if(response.invalidProductIdentifiers.count != 0){
            print(" *** products request not received ***")
            print(response.invalidProductIdentifiers.description)
        }
    }
    
    //Restore purchases
    func restorePurchaseProducts() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    //Called when an error happens in communication
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print(error)
        self.request = nil
    }
    

}//class end
