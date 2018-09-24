//
//  HUD.swift
//  Pierre The Penguin
//
//  Created by Siddharth Shekar on 22/11/17.
//  Copyright © 2017 Growl Games Studio. All rights reserved.
//

import SpriteKit

class HUD: SKNode {
    var textureAtlas = SKTextureAtlas(named:"HUD")
    var coinAtlas = SKTextureAtlas(named: "Environment")
    // An array to keep track of the hearts:
    var heartNodes:[SKSpriteNode] = []
    // An SKLabelNode to print the coin score:
    let coinCountText = SKLabelNode(text: "000000")
    
    let restartButton = SKSpriteNode()
    let menuButton = SKSpriteNode()

    
    
    
    func createHudNodes(screenSize:CGSize) {
        let cameraOrigin = CGPoint(
            x: screenSize.width / 2,
            y: screenSize.height / 2)
        // --- Create the coin counter ---
        // First, create and position a bronze coin icon:
        let coinIcon = SKSpriteNode(texture:
            coinAtlas.textureNamed("coin-bronze"))
        // Size and position the coin icon:
        let coinPosition = CGPoint(x:
            -cameraOrigin.x + 23, y: cameraOrigin.y - 23)
        coinIcon.size = CGSize(width: 26, height: 26)
        coinIcon.position = coinPosition
        // Configure the coin text label:
        coinCountText.fontName = "AvenirNext-HeavyItalic"
        let coinTextPosition = CGPoint(x:
            -cameraOrigin.x + 41, y: coinPosition.y)
        coinCountText.position = coinTextPosition
        // These two properties allow you to align the
        // text relative to the SKLabelNode's position:
        coinCountText.horizontalAlignmentMode =
            SKLabelHorizontalAlignmentMode.left
        coinCountText.verticalAlignmentMode =
            SKLabelVerticalAlignmentMode.center
        // Add the text label and coin icon to the HUD:
        self.addChild(coinCountText)
        self.addChild(coinIcon)
        
        // Create three heart nodes for the life meter:
        for index in 0 ..< 3 {
            let newHeartNode = SKSpriteNode(texture:
                textureAtlas.textureNamed("heart-full"))
            newHeartNode.size = CGSize (width: 46,
                                        height: 40)
            // Position the hearts below the coins:
            let xPos = -cameraOrigin.x +
                CGFloat(index * 58) + 33
            let yPos = cameraOrigin.y - 66
            newHeartNode.position = CGPoint(x: xPos,
                                            y: yPos)
            // Keep track of nodes in an array property:
            heartNodes.append(newHeartNode)
            // Add the heart nodes to the HUD:
            self.addChild(newHeartNode)
            
            // Add the restart and menu button textures to the nodes:
            restartButton.texture = textureAtlas.textureNamed("button-restart")
            menuButton.texture = textureAtlas.textureNamed("button-menu")
            // Assign node names to the buttons:
            restartButton.name = "restartGame"
            menuButton.name = "returnToMenu"
            menuButton.position = CGPoint(x: -140, y: 0)
            // Size the button nodes:
            restartButton.size = CGSize(width: 140, height: 140)
            menuButton.size = CGSize(width: 70, height: 70)

        }
    }
    
    func showButtons() {
        // Set the button alpha to 0:
        restartButton.alpha = 0
        menuButton.alpha = 0
        // Add the button nodes to the HUD:
        self.addChild(restartButton)
        self.addChild(menuButton)
        // Fade in the buttons:
        let fadeAnimation =
            SKAction.fadeAlpha(to: 1, duration: 0.4)
        restartButton.run(fadeAnimation)
        menuButton.run(fadeAnimation)
    }


    func setCoinCountDisplay(newCoinCount:Int) {
        // We can use the NSNumberFormatter class to pad
        // leading 0's onto the coin count:
        let formatter = NumberFormatter()
        let number = NSNumber(value: newCoinCount)
        formatter.minimumIntegerDigits = 6
        if let coinStr =
            formatter.string(from: number) {
            // Update the label node with the new count:
            coinCountText.text = coinStr
        }
    }
    
    func setHealthDisplay(newHealth:Int) {
        // Create a fade SKAction to fade lost hearts:
        let fadeAction = SKAction.fadeAlpha(to: 0.2,
                                            duration: 0.3)
        // Loop through each heart and update its status:
        for index in 0 ..< heartNodes.count {
            if index < newHealth {
                // This heart should be full red:
                heartNodes[index].alpha = 1
            }
            else {
                // This heart should be faded:
                heartNodes[index].run(fadeAction)
            }
        }
    }

    
    
    
}//HUD



