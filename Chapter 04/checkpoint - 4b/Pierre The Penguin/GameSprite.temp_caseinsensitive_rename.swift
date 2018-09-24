//
//  Gamesprite.swift
//  Pierre The Penguin
//
//  Created by Siddharth Shekar on 10/11/17.
//  Copyright © 2017 Growl Games Studio. All rights reserved.
//

import Foundation


import SpriteKit

protocol GameSprite{
    
    var textureAtlas:SKTextureAtlas{ get set }
    var intitialSize:CGSize{ get set }
    func onTap()
}
