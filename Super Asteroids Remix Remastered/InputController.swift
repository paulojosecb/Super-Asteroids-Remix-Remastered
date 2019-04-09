//
//  GameController.swift
//  Super Asteroids Remix Remastered
//
//  Created by Matheus Costa on 08/04/19.
//  Copyright © 2019 Paulo José. All rights reserved.
//

import GameController

class InputController {

    // MARK: - Properties

    private (set) var controller: GCMicroGamepad
    
    private (set) var analogDirection: CGPoint

    // MARK: - Callbacks

    var onShootButtonValueChange: ((Bool) -> Void)?
    var onPushButtonValueChange: ((Bool) -> Void)?

    // MARK: - Life cycle

    init(controller: GCMicroGamepad) {
        self.controller = controller
        self.analogDirection = CGPoint.zero

        self.setupController()
    }

    func setupController() {
        self.controller.buttonA.valueChangedHandler = {
            [weak self] (_, _, isPressed) in
            
            if let onShootButtonValueChange = self?.onShootButtonValueChange {
                onShootButtonValueChange(isPressed)
            }
        }

        self.controller.buttonX.valueChangedHandler = {
            [weak self] (_, _, isPressed) in

            if let onPushButtonValueChange = self?.onPushButtonValueChange {
                onPushButtonValueChange(isPressed)
            }
        }

        self.controller.reportsAbsoluteDpadValues = true
        self.controller.dpad.valueChangedHandler = {
            [weak self] (_, x, y) in

            let thresold: CGFloat = 0.2

            let tempDirection = CGPoint(x: CGFloat(x), y: CGFloat(y))

            if tempDirection.magnitude() > thresold {
                self?.analogDirection = CGPoint(x: CGFloat(x), y: CGFloat(y))
            } else {
                self?.analogDirection = CGPoint.zero
            }

        }
    }

}

extension CGPoint {

    func magnitude() -> CGFloat {
        return sqrt(x * x + y * y)
    }

}
