//
//  HUD.swift
//  Super Asteroids Remix Remastered
//
//  Created by Martônio Júnior on 09/04/19.
//  Copyright © 2019 Paulo José. All rights reserved.
//

import SpriteKit
import GameplayKit

class HUD: GKEntity {
    var textNode: SKLabelNode
    var thermoBarNode: SKShapeNode
    var thermoBarBackgroundNode: SKShapeNode
    var thermometerDelegate: ThermometerDelegate?
    
    init(on scene: SKScene) {
        textNode = SKLabelNode(text: "Temperature")
        textNode.position = CGPoint(x: -100, y: 240)
        scene.addChild(textNode)
        
        thermoBarBackgroundNode = SKShapeNode(rect: CGRect(x: 0, y: 230, width: 200, height: 40))
        thermoBarBackgroundNode.fillColor = .lightGray
        thermoBarBackgroundNode.strokeColor = .black
        scene.addChild(thermoBarBackgroundNode)
        
        thermoBarNode = SKShapeNode(rect: CGRect(x: 0, y: 230, width: 200, height: 40))
        thermoBarNode.fillColor = .red
        thermoBarNode.strokeColor = .clear
        scene.addChild(thermoBarNode)
        super.init()
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        updateThermometer()
    }
    
    func updateThermometer() {
        guard let thermo = thermometerDelegate else { return }
        textNode.text = (thermo.isCoolingDown()) ? "Overheat!" : "Temperature"
        textNode.fontColor = thermo.isCoolingDown() ? .red : .lightGray
        let barScale: CGFloat = CGFloat(thermo.currentThermo()) / CGFloat(thermo.limitThermo())
        thermoBarNode.xScale = barScale
        //thermoBarBackgroundNode.xScale = -1+barScale
//        let barLength = (thermo.currentThermo() / thermo.limitThermo()) / 100
//        thermoBarNode = SKShapeNode(rect: CGRect(x: -400, y: 180, width: barLength, height: 40))
//        thermoBarNode.fillColor = .red
//        thermoBarBackgroundNode = SKShapeNode(rect: CGRect(x: -300, y: 180, width: -1*(100-barLength), height: 40))
//        thermoBarBackgroundNode.fillColor = .gray
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
