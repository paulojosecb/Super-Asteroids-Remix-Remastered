//
//  Player.swift
//  Super Asteroids Remix Remastered
//
//  Created by Matheus Costa on 08/04/19.
//  Copyright © 2019 Paulo José. All rights reserved.
//

import SpriteKit
import GameplayKit

class Player: GKEntity {

    // MARK: - Properties

    var sprite: SKSpriteNode!
//    var bullet: SKSpriteNode!
    var bulletReference: Bullet!

    var speedPerSecond: CGFloat = 50.0

    var isMoving: Bool = false
    var isShooting: Bool = false

    var analogDirection: CGPoint = CGPoint.zero

    // MARK: - Life Cycle

    override init() {
        super.init()
        self.sprite = SKSpriteNode(imageNamed: "spaceship")
        self.sprite.setScale(0.3)
        //self.sprite = SKSpriteNode(color: .clear, size: CGSize(width: 50, height: 50))
        self.sprite.position = CGPoint.zero
        self.sprite.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 50, height: 50))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func update(deltaTime seconds: TimeInterval) {
        if self.isMoving {
            self.move(deltaTime: seconds)
        }
        if self.isShooting {
            while isShooting {
                let bullet = Bullet(player: self)
                bullet.shoot()
            }
        }
    }

    func move(deltaTime: TimeInterval) {
        let speedOnThisFrame = CGFloat(deltaTime) * self.speedPerSecond
        let directionToMove = CGVector(dx: self.analogDirection.x * speedOnThisFrame,
                                       dy: self.analogDirection.y * speedOnThisFrame)

        self.sprite.physicsBody?.applyImpulse(directionToMove)
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
