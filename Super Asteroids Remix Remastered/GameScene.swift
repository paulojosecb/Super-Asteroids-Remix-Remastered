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
    
    var playerSpeedPerSecond: CGFloat = 50.0
    
    var analogDirection: CGPoint = CGPoint.zero

    private var movementState: MovementState = .idle
    private var shootingState: ShootingState = .idle
    
    var player: SKSpriteNode!
    
    var lastTime: TimeInterval!
    
    override func didMove(to view: SKView) {
        setupScene()
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
        player = SKSpriteNode(color: .white, size: CGSize(width: 50, height: 50))
        player.position = CGPoint.zero
        player.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 50, height: 50))
        addChild(player)
        
    }
    
    func move(_ sprite: SKSpriteNode, deltaTime: TimeInterval) {
        
        let speedOnThisFrame = CGFloat(deltaTime) * playerSpeedPerSecond
        let directionToMove = CGVector(dx: analogDirection.x * speedOnThisFrame, dy: analogDirection.y * speedOnThisFrame)
//        let move = SKAction.move(by: directionToMove, duration: deltaTime)
//        sprite.run(move)
        
        player.physicsBody?.applyImpulse(directionToMove)
        
    }
    
    @objc func setupDirectionalPad(_ notification: NSNotification) {
        guard let controller = GCController.controllers().first else {
            return
            
        }
        guard let micro = controller.microGamepad else {
            return
        }
        
        micro.buttonA.valueChangedHandler = {
            [weak self] (button, pressure, isPressed) in
            self?.shootingState = isPressed ? .shooting : .idle
        }
        
        micro.buttonX.valueChangedHandler = {
            [weak self] (button, pressure, isPressed) in
            self?.movementState = isPressed ? .moving : .idle
        }
        
        micro.reportsAbsoluteDpadValues = true
        micro.dpad.valueChangedHandler = {
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
