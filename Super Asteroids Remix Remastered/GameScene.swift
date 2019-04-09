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
    var player: Player?

    override func didMove(to view: SKView) {
        self.physicsWorld.gravity = CGVector.zero
        self.physicsWorld.contactDelegate = self
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)

        self.setupControllerObservers()

        run(SKAction.repeatForever(SKAction.sequence([SKAction.run(addAsteroids), SKAction.wait(forDuration: 1.0)])))
    }


    // Called before each frame is rendered
    override func update(_ currentTime: TimeInterval) {
        var deltaTime: TimeInterval!
        
        if let lastTime = lastTime {
            deltaTime = currentTime - lastTime
        } else {
            deltaTime = 0
        }

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
    
    func addAsteroids() {
        
        let asteroid = SKSpriteNode(imageNamed: "asteroid")
        asteroid.setScale(0.3)
        let actualY = random(min: -size.height/2, max: size.height/2)
        asteroid.position = CGPoint(x: size.width + asteroid.size.width/2, y: actualY)
        addChild(asteroid)
        let actualDuration = random(min: CGFloat(3.0), max: CGFloat(6.0))
        let actionMove = SKAction.move(to: CGPoint(x: -frame.width, y: asteroid.size.width/2), duration: TimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        asteroid.run(SKAction.sequence([actionMove, actionMoveDone]))
        
    }
    
    func BulletDidCollideWithAsteroid(bullet: SKSpriteNode, asteroid: SKSpriteNode) {
        asteroid.removeFromParent()
        bullet.removeFromParent()
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
        }
    }

    deinit {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self, name: .GCControllerDidConnect, object: nil)
        notificationCenter.removeObserver(self, name: .GCControllerDidDisconnect, object: nil)
        GCController.stopWirelessControllerDiscovery()
    }

}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        if secondBody.node?.entity is Bullet {
            
        } else if secondBody.node?.entity is Player {
            
        }
//        if ((firstBody.collisionBitMask & PhysicsCategory.girl != 0) && (secondBody.collisionBitMask & PhysicsCategory.obstacle != 0)) {
//            if let spaceShip = firstBody.node as? SKSpriteNode, let asteroide = secondBody.node as? SKSpriteNode {
////                girlDidCollideWithObstacle(girl: girl, obstacle: obstacle)
//
//            }
//        }
    }
    
}



