//
//  GameViewController.swift
//  Super Asteroids Remix Remastered
//
//  Created by Paulo José on 05/04/19.
//  Copyright © 2019 Paulo José. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import GameController


class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    
    }
    
}
