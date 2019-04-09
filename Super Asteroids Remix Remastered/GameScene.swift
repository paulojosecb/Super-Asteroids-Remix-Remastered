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
    var hud: HUD?
    var controllers = [InputController]()
    var asteroidController: AsteroidsController!
    var player: Player?

    override func didMove(to view: SKView) {
        self.physicsWorld.gravity = CGVector.zero
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        asteroidController = AsteroidsController(with: self)
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run(asteroidController.createAsteroid), SKAction.wait(forDuration: 2.0)])))

        self.hud = HUD(on: self)

        self.setupControllerObservers()
    }


    // Called before each frame is rendered
    override func update(_ currentTime: TimeInterval) {
        var deltaTime: TimeInterval!
        
        if let lastTime = lastTime {
            deltaTime = currentTime - lastTime
        } else {
            deltaTime = 0
        }

        self.asteroidController.updateAsteroids()
        self.hud?.update(deltaTime: deltaTime)

        if let player = self.player {
            player.update(deltaTime: deltaTime)
        }
        
        lastTime = currentTime
                
    }

    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    func setupControllerObservers() {
        let notificationCenter = NotificationCenter.default

        notificationCenter.addObserver(self, selector: #selector(setupController(_:)), name: .GCControllerDidConnect, object: nil)
        notificationCenter.addObserver(self, selector: #selector(setupController(_:)), name: .GCControllerDidDisconnect, object: nil)

        GCController.startWirelessControllerDiscovery(completionHandler: nil)
    }

    @objc func setupController(_ notification: NSNotification) {
        print(notification.description)

        guard let controller = GCController.controllers().last,
            let microGamepad = controller.microGamepad else {
                print("Connect a controller to continue")
                return
        }

        if let player = self.player {
            player.inputController = InputController(controller: microGamepad)
            player.setupControllerCallbacks()
        } else {
            self.player = Player(scene: self, microGamepad: microGamepad)
            self.hud?.thermometerDelegate = self.player
        }
    }

    deinit {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self, name: .GCControllerDidConnect, object: nil)
        notificationCenter.removeObserver(self, name: .GCControllerDidDisconnect, object: nil)
        GCController.stopWirelessControllerDiscovery()
    }

}
