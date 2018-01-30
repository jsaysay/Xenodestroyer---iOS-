//
//  GameOver.swift
//  TheGreatestGameOfAllTime
//
//  Created by Jonathan SAYSAY on 12/17/17.
//  Copyright © 2017 jsaysay. All rights reserved.
//

import Foundation
import SpriteKit

class GameOver: SKScene {
    let gameOverLabel = SKLabelNode(text: "You died...try again?")
    let tryAgainButton = SKLabelNode(text: "Try Again")
    let mainMenuButton = SKLabelNode(text: "Main Menu")
    var playerScore: SKLabelNode!
    var enemyTimer: Timer!
    
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "space_background")
        background.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
        background.zPosition = -2
        addChild(background)
        
        gameOverLabel.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 1.5)
        gameOverLabel.fontName = "CourierNewPS-BoldMT"
        gameOverLabel.fontColor = UIColor.white
        gameOverLabel.fontSize = 40
        addChild(gameOverLabel)
        
        playerScore = SKLabelNode(text: "Score: " + String(UserDefaults.standard.integer(forKey: "currentscore")))
        playerScore.position = CGPoint(x: frame.size.width/2, y: frame.size.height/1.7)
        playerScore.fontSize = 40
        playerScore.fontName =  "CourierNewPS-BoldMT"
        playerScore.fontColor = UIColor.yellow
        addChild(playerScore)
        
        
        tryAgainButton.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2.2)
        tryAgainButton.fontName = "CourierNewPS-BoldMT"
        tryAgainButton.fontColor = UIColor.white
        tryAgainButton.fontSize = 40
        addChild(tryAgainButton)
        
        mainMenuButton.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 3)
        mainMenuButton.fontName = "CourierNewPS-BoldMT"
        mainMenuButton.fontColor = UIColor.white
        mainMenuButton.fontSize = 40
        addChild(mainMenuButton)
        
        let wait = SKAction.wait(forDuration: 1)
        run(wait, completion: {
            self.enemyTimer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(self.spawnEnemy), userInfo: nil, repeats: true)
            })
        
    }
    
    @objc func spawnEnemy(){
        let enemy = Enemy(enemyType: 1)
        let upperBound = self.frame.width - enemy.size.width
        let lowerBound = 2*enemy.size.width
        let enemyXLocation = CGFloat(arc4random_uniform(UInt32((upperBound - lowerBound)))+UInt32(lowerBound))
        enemy.position = CGPoint(x: enemyXLocation, y: self.frame.height)
        enemy.zPosition = -1
        self.addChild(enemy)
        
        let moveEnemy = SKAction.moveTo(y: -frame.size.height, duration: 2)
        enemy.run(moveEnemy, completion: {
            enemy.removeFromParent()
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let location = touch?.location(in: self)
        let touchedButton = atPoint(location!)
        
        switch touchedButton{
        case tryAgainButton:
            self.run(SKAction.playSoundFileNamed("MenuClick.wav", waitForCompletion: false))
            enemyTimer?.invalidate()
            let gameScene = GameScene(size: self.size)
            gameScene.scaleMode = .aspectFill
            let transition = SKTransition.fade(withDuration: 2)
            self.view?.presentScene(gameScene, transition: transition)
        case mainMenuButton:
            self.run(SKAction.playSoundFileNamed("MenuClick.wav", waitForCompletion: false))
            enemyTimer?.invalidate() 
            let menuScene = MainMenu(size: self.size)
            menuScene.scaleMode = .aspectFill
            let transition = SKTransition.fade(withDuration: 2)
            self.view?.presentScene(menuScene, transition: transition)
        default:
            print("n/a")
        }
        
    }
}
