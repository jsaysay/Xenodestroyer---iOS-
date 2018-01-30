//
//  Glow.swift
//  TheGreatestGameOfAllTime
//
//  Created by Jonathan SAYSAY on 12/17/17.
//  Copyright © 2017 jsaysay. All rights reserved.
//

import Foundation
import SpriteKit

//creates a glow for game nodes.
extension SKSpriteNode{
    func setGlow(){
        //let effectNode = SKEffectNode()
        //effectNode.shouldRasterize = true
        //addChild(effectNode)
        //effectNode.addChild(SKSpriteNode(texture: texture))
       // effectNode.filter = CIFilter(name: "CIGaussianBlur", withInputParameters: ["inputRadius":Float(30)])
        self.alpha = 1
        self.blendMode = SKBlendMode.add
        
        let fadeOut = SKAction.fadeAlpha(by: 0, duration: 1)
        let fadeIn = SKAction.fadeAlpha(by: 1, duration: 1)
        let repeatForever = SKAction.repeatForever(SKAction.sequence([fadeOut,fadeIn]))
        self.run(repeatForever)
    }
}
