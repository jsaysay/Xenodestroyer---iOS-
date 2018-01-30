//
//  Ship.swift
//  TheGreatestGameOfAllTime
//
//  Created by Jonathan SAYSAY on 12/9/17.
//  Copyright © 2017 jsaysay. All rights reserved.
//

import Foundation
import SpriteKit

class Ship: SKSpriteNode {
    private var bulletPower: Int8 = 1
    private var shipType: Int8
    
    init(gameScene:SKScene,shipType: Int8) {
        self.shipType = shipType
        let shipTexture = SKTexture(imageNamed: "ship" + String(shipType))
        let shipSize = CGSize(width: shipTexture.size().width/2.3, height: shipTexture.size().height/2.3)
        
        super.init(texture: shipTexture, color: .clear, size: shipSize)
    
        self.position = CGPoint(x: gameScene.frame.width/2, y: -self.size.height)
        self.physicsBody = SKPhysicsBody(texture: shipTexture, size: shipSize)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.categoryBitMask = contactCategory.ship
        self.physicsBody?.contactTestBitMask = contactCategory.enemy
        self.physicsBody?.collisionBitMask = contactCategory.none

    }
    
    func getBulletPower() -> Int8{
        return bulletPower
    }
    
    func increaseBulletPower(){
        bulletPower += 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
