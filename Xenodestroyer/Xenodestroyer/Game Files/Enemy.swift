//
//  Enemy.swift
//  TheGreatestGameOfAllTime
//
//  Created by Jonathan SAYSAY on 12/9/17.
//  Copyright © 2017 jsaysay. All rights reserved.
//

import Foundation
import SpriteKit

class Enemy: SKSpriteNode{
    private var enemyType: Int8
    var hitpoints: Int8
    init(enemyType: Int8){
        self.enemyType = enemyType
        hitpoints = 3
        let enemyTexture = SKTexture(imageNamed: "enemy" + String(enemyType))
        super.init(texture: enemyTexture, color: .clear, size: enemyTexture.size())
        
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.categoryBitMask = contactCategory.enemy
        self.physicsBody?.contactTestBitMask = contactCategory.projectile | contactCategory.ship
        self.physicsBody?.collisionBitMask = contactCategory.none
    }
    
    func didGetHit(damage: Int8){
        hitpoints -= damage
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
