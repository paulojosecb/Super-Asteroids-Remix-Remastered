//
//  GameController.swift
//  Super Asteroids Remix Remastered
//
//  Created by Matheus Costa on 08/04/19.
//  Copyright © 2019 Paulo José. All rights reserved.
//

import GameController

class InputController {
    
    private (set) var controller: GCMicroGamepad
    private (set) weak var scene: GameScene
    private (set) var player: Player

    init(controller: GCMicroGamepad, scene: GameScene) {
        self.player = Player()
        self.scene = scene
        self.controller = controller

        self.setupController()
        self.scene.addChild(self.player.sprite)
    }

    func setupController() {
        self.controller.buttonA.valueChangedHandler = {
            [weak self] (_, _, isPressed) in
            self?.player.isShooting = isPressed
        }

        self.controller.buttonX.valueChangedHandler = {
            [weak self] (_, _, isPressed) in
            self?.player.isMoving = isPressed
        }

        self.controller.reportsAbsoluteDpadValues = true
        self.controller.dpad.valueChangedHandler = {
            [weak self] (_, x, y) in

            let thresold: CGFloat = 0.2

            let tempDirection = CGPoint(x: CGFloat(x), y: CGFloat(y))

            if tempDirection.magnitude() > thresold {
                self?.player.analogDirection = CGPoint(x: CGFloat(x), y: CGFloat(y))
            } else {
                self?.player.analogDirection = CGPoint.zero
            }
        }
    }

}

extension CGPoint {

    func magnitude() -> CGFloat {
        return sqrt(x * x + y * y)
    }

}
