//
//  Player.swift
//  Super Asteroids Remix Remastered
//
//  Created by Matheus Costa on 08/04/19.
//  Copyright © 2019 Paulo José. All rights reserved.
//

import SpriteKit
import GameplayKit
import GameController

class Player: GKEntity {

    // MARK: - Properties

//    var bullet: SKSpriteNode!
    var bulletReference: Bullet!
    var sprite: SKSpriteNode
    var scene: GameScene
    var inputController: InputController

    var speedPerSecond: CGFloat = 50.0

    var isMoving: Bool = false
    var isShooting: Bool = false

    // MARK: - Life Cycle

    init(scene: GameScene, microGamepad: GCMicroGamepad) {
        self.scene = scene

        self.sprite = SKSpriteNode(imageNamed: "spaceship")
        self.sprite.setScale(0.3)
        self.sprite.position = CGPoint.zero
        self.sprite.physicsBody = SKPhysicsBody(rectangleOf: self.sprite.size)
        self.sprite.physicsBody?.categoryBitMask = 0b00100
        self.sprite.physicsBody?.collisionBitMask = 0b00001
        self.sprite.physicsBody?.contactTestBitMask = 0b00010

        self.inputController = InputController(controller: microGamepad)

        super.init()

        self.setupControllerCallbacks()
        self.scene.addChild(self.sprite)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func update(deltaTime seconds: TimeInterval) {
        if self.isMoving {
            self.move(deltaTime: seconds)
        }
        if self.isShooting {
            self.shoot(deltaTime: seconds)
        }
    }

    func setupControllerCallbacks() {
        self.inputController.onPushButtonValueChange = { [weak self] isPressed in
            self?.isMoving = isPressed
        }

        self.inputController.onShootButtonValueChange = { [weak self] isPressed in

            self?.isShooting = isPressed
        }
    }

    func move(deltaTime: TimeInterval) {
        let currentDirection = self.inputController.analogDirection

        let speedOnThisFrame = CGFloat(deltaTime) * self.speedPerSecond
        let directionToMove = CGVector(dx: currentDirection.x * speedOnThisFrame,
                                       dy: currentDirection.y * speedOnThisFrame)

        self.sprite.physicsBody?.applyImpulse(directionToMove)
    }
    
    func shoot(deltaTime: TimeInterval) {
        let bullet = Bullet(player: self)
        bullet.shoot()
        
        self.scene.addChild(bullet.bullet)
    }
    
//    func shoot() {
//        bulletReference.zRotation = player.sprite.zRotation
//        bulletReference.position = player.sprite.position
//        let actionMove = SKAction.move(to: CGPoint(
//            x: 400 * -cos(bulletReference.zRotation - 1.57079633) + bulletReference.position.x,
//            y: 400 * -sin(bulletReference.zRotation - 1.57079633) + bulletReference.position.y
//        ), duration: 2.0)
//        let actionMoveDone = SKAction.removeFromParent()
//        bulletReference.run(SKAction.sequence([actionMove, actionMoveDone]))
//        bulletReference.physicsBody = SKPhysicsBody(rectangleOf: self.bullet.size)
//        bulletReference.physicsBody?.affectedByGravity = false
//        bulletReference.physicsBody?.isDynamic = false
//        
//        //        self.scene.addChild(self.player.bullet)
//    }


}
