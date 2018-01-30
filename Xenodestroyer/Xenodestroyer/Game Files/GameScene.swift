//
//  GameScene.swift
//  TheGreatestGameOfAllTime
//
//  Created by Jonathan SAYSAY on 11/28/17.
//  Copyright © 2017 jsaysay. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene,SKPhysicsContactDelegate {
    var playerShip: Ship!
    var projectileTimer: Timer!
    var enemyTimer: Timer!
    var scoreLabel: SKLabelNode!
    var shipFlame: SKEmitterNode!
    var currentScore = 0{
        didSet{
            scoreLabel.text = "score: \(currentScore)"
        }
    }
   
    override func didMove(to view: SKView) {
        //background image
        let spaceImage = SKSpriteNode(imageNamed: "space_background")
        spaceImage.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        spaceImage.zPosition = -2
        self.addChild(spaceImage)
        
        //star emitter node
        let stars = SKEmitterNode(fileNamed: "starEmitter.sks")
        stars?.position = CGPoint(x: self.frame.width/2 ,y: self.frame.height)
        self.addChild(stars!)
        
        //score label
        scoreLabel = SKLabelNode(text: "score: 0")
        scoreLabel.fontSize = CGFloat(32)
        scoreLabel.fontColor = UIColor.white
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        scoreLabel.fontName = "Arial-BoldMT"
        scoreLabel.position = CGPoint(x: scoreLabel.frame.size.width, y: frame.size.height - 100)
        scoreLabel.zPosition = spaceImage.zPosition + 1
        addChild(scoreLabel)
        
        //no gravity
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
        
        //ship node
        playerShip = Ship(gameScene: self,shipType: 1)
        self.addChild(playerShip)
        
        //ship flame node
        shipFlame = SKEmitterNode(fileNamed: "shipFlame.sks")
        shipFlame?.zPosition = playerShip.zPosition - 1
        shipFlame.position.y = -30
        playerShip.addChild(shipFlame!)
        
        let moveShip = SKAction.move(to: CGPoint(x: frame.width/2, y: playerShip.size.height), duration: 2)
        playerShip.run(moveShip){
            
            //handle enemy and projectile spawning
            self.projectileTimer = Timer.scheduledTimer(timeInterval: 0.15, target: self, selector: #selector(self.spawnProjectile), userInfo: nil, repeats: true)
            self.enemyTimer = Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(self.spawnEnemy), userInfo: nil, repeats: true)
            
          /*  let powerUpNode = SKSpriteNode(imageNamed: "powerUP")
            powerUpNode.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/3)
            powerUpNode.physicsBody = SKPhysicsBody(rectangleOf: powerUpNode.size)
            powerUpNode.physicsBody?.isDynamic = true
            powerUpNode.physicsBody?.categoryBitMask = contactCategory.powerUp
            powerUpNode.physicsBody?.contactTestBitMask = contactCategory.ship
            powerUpNode.physicsBody?.collisionBitMask = contactCategory.none
            powerUpNode.setGlow()
            self.addChild(powerUpNode)*/
        }
    }
    
    @objc func spawnProjectile(){
        self.run(SKAction.playSoundFileNamed("laser7.wav", waitForCompletion: false))
        let projectile = Projectile(bulletType: playerShip.getBulletPower(), bulletAmt: 1)
        projectile.position = CGPoint(x: playerShip.position.x, y: playerShip.position.y + 40)
        projectile.zPosition = playerShip.zPosition - 1
        self.addChild(projectile)
        projectile.fireProjectile()
    }
    
    @objc func spawnEnemy(){
        let enemy = Enemy(enemyType: 1)
        let upperBound = self.frame.width - enemy.size.width
        let lowerBound = 2*enemy.size.width
        let enemyXLocation = CGFloat(arc4random_uniform(UInt32((upperBound - lowerBound)))+UInt32(lowerBound))
        enemy.position = CGPoint(x: enemyXLocation, y: self.frame.height)
        enemy.zPosition = -1
        self.addChild(enemy)
        
        let moveEnemy = SKAction.moveTo(y: -playerShip.size.height, duration: 2)
        enemy.run(moveEnemy, completion: {
            enemy.removeFromParent()
            })
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var body1: SKPhysicsBody
        var body2: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask > contact.bodyB.categoryBitMask{
            body2 = contact.bodyA
            body1 = contact.bodyB
        } else {
            body1 = contact.bodyA
            body2 = contact.bodyB
        }
        
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if collision == (contactCategory.enemy | contactCategory.projectile){
            enemyHit(enemy: body2.node as! SKSpriteNode, projectile: body1.node as! SKSpriteNode)
        }
        
        if collision == (contactCategory.enemy | contactCategory.ship){
            playerDestroyed(enemy: body2.node as! SKSpriteNode)
        }
        
        if collision == (contactCategory.ship | contactCategory.powerUp){
            grantPowerUp(powerUpNode: body1.node as! SKSpriteNode)
        }
        
    }
    
    func grantPowerUp(powerUpNode: SKSpriteNode){
        if playerShip.getBulletPower() < 4 {
            playerShip.increaseBulletPower()
        }
        powerUpNode.removeFromParent()
    }
    
    func enemyHit(enemy:SKSpriteNode, projectile:SKSpriteNode){
        
        let enemyNode = enemy as! Enemy
        enemyNode.didGetHit(damage: playerShip.getBulletPower())
        projectile.removeFromParent()
        if enemyNode.hitpoints <= 0{
            self.run(SKAction.playSoundFileNamed("explosionSound.wav", waitForCompletion: false))
            let explosionEmitter = SKEmitterNode(fileNamed: "enemyExplosion.sks")
            explosionEmitter?.position = enemy.position
            self.addChild(explosionEmitter!)
            enemyNode.removeFromParent()
            currentScore += 100
            self.run(SKAction.wait(forDuration: 2)){
                explosionEmitter?.removeFromParent()
            }
        }
        
    }
    
    func playerDestroyed(enemy: SKSpriteNode){
        let explosion = SKEmitterNode(fileNamed: "enemyExplosion.sks")
        explosion?.position = enemy.position
        self.addChild(explosion!)
        
        let explosion2 = SKEmitterNode(fileNamed: "enemyExplosion.sks")
        explosion2?.position = playerShip.position
        self.addChild(explosion2!)
        
        //remove ship and its flame from the scene.
        self.playerShip.removeFromParent()
        self.shipFlame.removeFromParent()
        
        //stop projectiles and enemies from spawning.
        projectileTimer.invalidate()
        enemyTimer.invalidate()
        
        //save score if highscore
        if currentScore > UserDefaults.standard.integer(forKey: "highscore"){
            UserDefaults.standard.set(currentScore, forKey: "highscore")
        }
        
        //remove explosions and transition to game over scene.
        self.run(SKAction.wait(forDuration: 2)){
            //save current score for game over scene
            UserDefaults.standard.set(self.currentScore, forKey: "currentscore")
            explosion?.removeFromParent()
            explosion2?.removeFromParent()
            let gameScene = GameOver(size: self.size)
            gameScene.scaleMode = .aspectFill
            let transition = SKTransition.fade(with: UIColor.black, duration: 2)
            self.view!.presentScene(gameScene, transition: transition)
        }
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       /* for touch in touches{
            let location = touch.location(in: self)
            let move = SKAction.move(to: location, duration: 0.2)
            playerShip.run(move)
        }*/
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let location = touch.location(in: self)
            if playerShip.contains(location){
                playerShip.position = location
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {

    }
}
