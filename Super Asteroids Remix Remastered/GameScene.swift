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

enum MovementState {
    case moving
    case idle
}

enum ShootingState {
    case shooting
    case idle
}

class GameScene: SKScene {
    var microGamePad: GCMicroGamepad?

    var playerSpeedPerSecond: CGFloat = 50.0
    
    var analogDirection: CGPoint = CGPoint.zero

    private var movementState: MovementState = .idle
    private var shootingState: ShootingState = .idle
    
    var player: SKSpriteNode!
    
    var lastTime: TimeInterval!
    
    override func didMove(to view: SKView) {
        setupScene()
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run(addAsteroids), SKAction.wait(forDuration: 1.0)])))
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        var deltaTime: TimeInterval!
        
        if let lastTime = lastTime {
            deltaTime = currentTime - lastTime
        } else {
            deltaTime = 0
        }
        
        if movementState == .moving {
            move(player, deltaTime: deltaTime)
            print("Moving")
        }
    
        lastTime = currentTime
        
    }
    
    func setupScene() {
        
        setupControllerNotification()
        
        self.physicsWorld.gravity = CGVector.zero
        
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        let player = SKSpriteNode(imageNamed: "spaceship")
        player.position = CGPoint.zero
        player.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 50, height: 50))
        player.setScale(0.3)
        addChild(player)
        
    }

    
    func move(_ sprite: SKSpriteNode, deltaTime: TimeInterval) {
        
        let speedOnThisFrame = CGFloat(deltaTime) * playerSpeedPerSecond
        let directionToMove = CGVector(dx: analogDirection.x * speedOnThisFrame, dy: analogDirection.y * speedOnThisFrame)
        player.physicsBody?.applyImpulse(directionToMove)

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
        let actualY = random(min: asteroid.size.height/2, max: size.height - asteroid.size.height/2)
        asteroid.position = CGPoint(x: size.width + asteroid.size.width/2, y: actualY)
        addChild(asteroid)
        let actualDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))
        let actionMove = SKAction.move(to: CGPoint(x: -asteroid.size.width/2, y: asteroid.size.width/2), duration: TimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        asteroid.run(SKAction.sequence([actionMove, actionMoveDone]))
    }
    
    @objc func setupDirectionalPad(_ notification: NSNotification) {
        guard let controller = GCController.controllers().first else {
            return
            
        }
        self.microGamePad = controller.microGamepad
        
        microGamePad!.buttonA.valueChangedHandler = {
            [weak self] (button, pressure, isPressed) in
            self?.shootingState = isPressed ? .shooting : .idle
        }
        
        microGamePad!.buttonX.valueChangedHandler = {
            [weak self] (button, pressure, isPressed) in
            self?.movementState = isPressed ? .moving : .idle
        }
        
        microGamePad!.reportsAbsoluteDpadValues = true
        microGamePad!.dpad.valueChangedHandler = {
            [weak self] (pad, x, y) in
            
            let thresold: CGFloat = 0.2
            
            let tempDirection = CGPoint(x: CGFloat(x), y: CGFloat(y))
            
            if tempDirection.magnitude() > thresold {
                self?.analogDirection = CGPoint(x: CGFloat(x), y: CGFloat(y))
            } else {
                self?.analogDirection = CGPoint.zero
            }
            
        }
    }
    
    func setupControllerNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(setupDirectionalPad(_:)), name: NSNotification.Name.GCControllerDidConnect, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setupDirectionalPad(_:)), name: NSNotification.Name.GCControllerDidDisconnect, object: nil)
        
        GCController.startWirelessControllerDiscovery(completionHandler: nil)
    }
        
}

extension CGPoint {
    
    func magnitude() -> CGFloat {
    
        return sqrt(x * x + y * y)
    
    }
    
}
