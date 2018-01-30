//
//  MainMenu.swift
//  TheGreatestGameOfAllTime
//
//  Created by Jonathan SAYSAY on 12/17/17.
//  Copyright © 2017 jsaysay. All rights reserved.
//

import Foundation
import SpriteKit

class MainMenu: SKScene {
    let startGameButton =  SKLabelNode(text:"Start Game")
    let highScoreLabel = SKLabelNode(text: "High Score")
    let highScore = SKLabelNode()
    let titleLabel = SKLabelNode(text: "Xenodestroyer")
    override func didMove(to view: SKView) {
        
        let spaceImage = SKSpriteNode(imageNamed: "space_background")
        spaceImage.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        spaceImage.zPosition = -2
        self.addChild(spaceImage)
        
        titleLabel.position = CGPoint(x: frame.size.width/2, y: frame.size.height/1.5)
        titleLabel.fontSize = 52
        titleLabel.fontName = "CourierNewPS-BoldMT"
        titleLabel.fontColor = UIColor.white
        addChild(titleLabel)
        
        startGameButton.position = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
        startGameButton.fontSize = 40
        startGameButton.fontName = "CourierNewPS-BoldMT"
        startGameButton.fontColor = UIColor.white
        addChild(startGameButton)
        
        highScoreLabel.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 3)
        highScoreLabel.fontSize = 40
        highScoreLabel.fontName = "CourierNewPS-BoldMT"
        
        highScoreLabel.fontColor = UIColor.white
        addChild(highScoreLabel)
        
        highScore.position = CGPoint(x: frame.size.width / 2, y: frame.size.height/3.5)
        highScore.fontSize = 40
        highScore.text = String(UserDefaults.standard.integer(forKey: "highscore"))
        highScore.fontName = "CourierNewPS-BoldMT"
        highScore.fontColor = UIColor.yellow
        addChild(highScore)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let location = touch?.location(in: self)
        let touchedButton = atPoint(location!)
        
        switch touchedButton{
        case startGameButton:
            self.run(SKAction.playSoundFileNamed("MenuClick.wav", waitForCompletion: false))
            let gameScene = GameScene(size: self.size)
            let transition = SKTransition.fade(withDuration: 2)
            gameScene.scaleMode = .aspectFill
            self.view?.presentScene(gameScene, transition: transition)
        default:
            print("n/a")
        }
    }
}
