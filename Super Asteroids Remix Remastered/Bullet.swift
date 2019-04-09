//
//  Bullet.swift
//  Super Asteroids Remix Remastered
//
//  Created by Thalia Freitas on 09/04/19.
//  Copyright © 2019 Paulo José. All rights reserved.
//

import GameplayKit
import SpriteKit

class Bullet: GKEntity {
    
    var bullet: SKSpriteNode!
    var player: Player!
    
    
    init(player: Player) {
        super.init()
        self.player = player
        self.bullet = SKSpriteNode(imageNamed: "bullet")
        self.bullet.setScale(0.09)
        self.bullet.zPosition = -5
        //self.sprite = SKSpriteNode(color: .clear, size: CGSize(width: 50, height: 50))
        self.bullet.position = CGPoint.zero
        self.bullet.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 50, height: 50))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func shoot() {
        self.bullet.zRotation = player.sprite.zRotation
        self.bullet.position = player.sprite.position
        let actionMove = SKAction.move(to: CGPoint(
            x: 400 * -cos(self.bullet.zRotation - 1.57079633) + self.bullet.position.x,
            y: 400 * -sin(self.bullet.zRotation - 1.57079633) + self.bullet.position.y
        ), duration: 2.0)
        let actionMoveDone = SKAction.removeFromParent()
        self.bullet.run(SKAction.sequence([actionMove, actionMoveDone]))
        self.bullet.physicsBody = SKPhysicsBody(rectangleOf: self.bullet.size)
        self.bullet.physicsBody?.affectedByGravity = false
        self.bullet.physicsBody?.isDynamic = false
        
        //        self.scene.addChild(self.player.bullet)
    }

}
