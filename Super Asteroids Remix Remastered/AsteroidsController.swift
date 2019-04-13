//
//  AsteroidsController.swift
//  Super Asteroids Remix Remastered
//
//  Created by Paulo José on 09/04/19.
//  Copyright © 2019 Paulo José. All rights reserved.
//

import SpriteKit
import GameplayKit

protocol AsteroidDelegate {
    func destroy(asteroid: SKSpriteNode)
}

class AsteroidsController: GKEntity {
    
    var scene: SKScene!
    var asteroids = [Asteroid]()
    
    override init() {
        super.init()
    }
    
    convenience init(with scene: SKScene) {
        self.init()
        self.scene = scene
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createAsteroid() {
        
        let direction = Int.random(in: 0..<4)
        var asteroidPosition = CGPoint.zero
        
        switch direction {
        case 0:
            let x = random(min: -self.scene.size.width/2, max: self.scene.size.width)
            let y = self.scene.size.height / 2 + 100
            asteroidPosition = CGPoint(x: x, y: y)
        case 1:
            let x = self.scene.size.width / 2 + 100
            let y = random(min: -self.scene.size.height/2, max: self.scene.size.height/2)
            asteroidPosition = CGPoint(x: x, y: y)
        case 2: 
            let x = random(min: -self.scene.size.width/2, max: self.scene.size.width)
            let y = -self.scene.size.height/2 - 100
            asteroidPosition = CGPoint(x: x, y: y)
        case 3:
            let x = -self.scene.size.width / 2 - 100
            let y = random(min: -self.scene.size.height/2, max: self.scene.size.height/2)
            asteroidPosition = CGPoint(x: x, y: y)
        default:
            asteroidPosition = CGPoint(x: 0, y: 0)
        }
        
        let directionToTravel = CGPoint.zero.subtract(asteroidPosition).normalized()
        let asteroid = Asteroid(with: .large, and: asteroidPosition, directionToTravel: directionToTravel)
        asteroid.applyImpulse()
        self.scene.addChild(asteroid.sprite)
        
        asteroids.append(asteroid)
    }
    
    func updateAsteroids() {
        
        asteroids.forEach { (asteroid) in
            if asteroid.sprite.physicsBody?.isResting ?? true {
                asteroid.applyImpulse()
            }
        }
        
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    func destroy(asteroidSprite: SKSpriteNode) {
        
        guard let asteroid = asteroidSprite.entity as? Asteroid,
               let size = asteroid.size else { return }
        
        switch size {
        case .small:
            
            self.scene.removeChildren(in: [asteroid.sprite])
            asteroids.removeAll { (a) -> Bool in
                a == asteroid
            }
            
        case .medium:
            
            let numberOfNewAsteroids = Int.random(in: 1...5)
            for _ in 1...numberOfNewAsteroids {
                
                let randomX = Int.random(in: 0...100)
                let randomY = Int.random(in: 0...100)
                
                let newAsteroid = Asteroid(with: .small,
                                           and: asteroid.sprite.position,
                                           directionToTravel: CGPoint(x: randomX, y: randomY).normalized())
                
                newAsteroid.sprite.setScale(0.05)
                asteroids.append(newAsteroid)
                self.scene.addChild(newAsteroid.sprite)
            }
            
        case .large:
            
            let numberOfNewAsteroids = Int.random(in: 2...3)
            for _ in 1...numberOfNewAsteroids {
                
                let randomX = Int.random(in: 0...100)
                let randomY = Int.random(in: 0...100)
                
                let newAsteroid = Asteroid(with: .medium,
                                           and: asteroid.sprite.position,
                                           directionToTravel: CGPoint(x: randomX, y: randomY).normalized())
                 newAsteroid.sprite.setScale(0.1)
                asteroids.append(newAsteroid)
                self.scene.addChild(newAsteroid.sprite)
            }
            
        }
        
    }

}

