//
//  GameScene.swift
//  Super Asteroids Remix Remastered
//
//  Created by Paulo José on 05/04/19.
//  Copyright © 2019 Paulo José. All rights reserved.
//

import SpriteKit
import GameplayKit
import GameController

class GameScene: SKScene {

    var lastTime: TimeInterval!

    var controllers = [InputController]()
    var asteroidController: AsteroidsController!

    override func didMove(to view: SKView) {
        setupControllerNotification()

        self.physicsWorld.gravity = CGVector.zero
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        setupScene()
        asteroidController = AsteroidsController(with: self)
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run(asteroidController.createAsteroid), SKAction.wait(forDuration: 2.0)])))
    }


    // Called before each frame is rendered
    override func update(_ currentTime: TimeInterval) {
        var deltaTime: TimeInterval!
        
        if let lastTime = lastTime {
            deltaTime = currentTime - lastTime
        } else {
            deltaTime = 0
        }

        self.controllers.forEach { $0.player.update(deltaTime: deltaTime) }
        self.asteroidController.updateAsteroids()
        
        lastTime = currentTime
                
    }
    
    func setupScene() {
        
        setupControllerNotification()
        
        self.physicsWorld.gravity = CGVector.zero
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)

        
    }

    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    func setupControllerNotification() {
        let notificationCenter = NotificationCenter.default

        notificationCenter.addObserver(forName: .GCControllerDidConnect, object: nil, queue: .main) {
            [weak self] notification in

            guard let controller = notification.object as? GCController else { return }

            if let microGamepad = controller.microGamepad {
                let inputController = InputController(controller: microGamepad, scene: self!)
                self?.controllers.append(inputController)
            }
        }

        notificationCenter.addObserver(forName: .GCControllerDidDisconnect, object: nil, queue: .main) {
            [weak self] notification in

            guard let controller = notification.object as? GCController else { return }

            if let microGamepad = controller.microGamepad {
                self?.controllers.removeAll(where: { $0.controller == microGamepad })
            }
        }

        GCController.startWirelessControllerDiscovery(completionHandler: nil)
    }

    deinit {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self, name: .GCControllerDidConnect, object: nil)
        notificationCenter.removeObserver(self, name: .GCControllerDidDisconnect, object: nil)
        GCController.stopWirelessControllerDiscovery()
    }

}
