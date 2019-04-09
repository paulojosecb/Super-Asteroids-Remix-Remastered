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
    var impulseIntensity: CGFloat = 0.0002
    
    var delegate: AsteroidDelegate?
    
    override init() {
        super.init()
    }
    
    convenience init(with size: AsteroidSize, and position: CGPoint, directionToTravel: CGPoint, delegate: AsteroidDelegate) {
        self.init()
        self.size = size
        self.sprite.setScale(0.2)
        self.sprite.position = position
        self.directionToTravel = directionToTravel
        self.delegate = delegate
        self.sprite.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 0.2, height: 0.2))
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
