//
//  Asteroid.swift
//  Super Asteroids Remix Remastered
//
//  Created by Paulo José on 09/04/19.
//  Copyright © 2019 Paulo José. All rights reserved.
//

import SpriteKit
import GameplayKit

enum AsteroidSize {
    case large
    case medium
    case small
}

class Asteroid: GKEntity {
    
    var sprite: SKSpriteNode = SKSpriteNode(imageNamed: "asteroid")
    var size: AsteroidSize!
    var directionToTravel: CGPoint!
    var impulseIntensity: CGFloat = 100
    
    override init() {
        super.init()
    }
    
    convenience init(with size: AsteroidSize, and position: CGPoint, directionToTravel: CGPoint) {
        self.init()
        self.size = size
        self.sprite.setScale(0.2)
        self.sprite.position = position
        self.directionToTravel = directionToTravel
    
        self.sprite.entity = self
        self.sprite.physicsBody = SKPhysicsBody(rectangleOf: self.sprite.size)
        self.sprite.physicsBody?.categoryBitMask = 0b00100
        self.sprite.physicsBody?.collisionBitMask = 0b00001
        self.sprite.physicsBody?.contactTestBitMask = 0b00000
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        
    }

    func applyImpulse() {
        let impulse = CGVector(dx: directionToTravel.x * impulseIntensity , dy: directionToTravel.y * impulseIntensity)
        self.sprite.physicsBody?.applyImpulse(impulse)
        self.sprite.physicsBody?.linearDamping = 0
    }
    
    
}

