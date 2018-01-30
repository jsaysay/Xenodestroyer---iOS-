//
//  Projectile.swift
//  TheGreatestGameOfAllTime
//
//  Created by Jonathan SAYSAY on 12/9/17.
//  Copyright © 2017 jsaysay. All rights reserved.
//

import Foundation
import SpriteKit

class Projectile: SKSpriteNode {
    var bulletType: Int8
    var bulletAmt: Int8
    
    init(bulletType: Int8, bulletAmt: Int8){
        self.bulletType = bulletType
        self.bulletAmt = bulletAmt
        let bulletTexture = SKTexture(imageNamed: String(bulletType) + "bullet")
        super.init(texture: bulletTexture, color: .clear, size: CGSize(width: bulletTexture.size().width*2, height: bulletTexture.size().height*2))
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width/2)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.categoryBitMask = contactCategory.projectile
        self.physicsBody?.contactTestBitMask = contactCategory.enemy
        self.physicsBody?.collisionBitMask = contactCategory.none
        self.setGlow()
    }
    
    func fireProjectile(){
        if bulletAmt == 1 {
            let moveBullet = SKAction.moveBy(x: 0, y: self.scene!.frame.height + self.size.height, duration: 2)
            self.run(moveBullet, completion: {
                self.removeFromParent()
            })
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
