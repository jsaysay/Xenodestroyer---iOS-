//
//  GameViewController.swift
//  TheGreatestGameOfAllTime
//
//  Created by Jonathan SAYSAY on 11/28/17.
//  Copyright © 2017 jsaysay. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
       
            // Load the SKScene from 'GameScene.sks'
            let scene = MainMenu(size: CGSize(width: 768, height: 1024))
            let view = self.view as! SKView
            scene.scaleMode = .aspectFill
            view.ignoresSiblingOrder = false
            view.showsFPS = false
            view.showsNodeCount = false
            // Present the scene
            view.presentScene(scene)
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
