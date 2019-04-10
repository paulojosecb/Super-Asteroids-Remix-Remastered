//
//  CGPoint.swift
//  Super Asteroids Remix Remastered
//
//  Created by Paulo José on 09/04/19.
//  Copyright © 2019 Paulo José. All rights reserved.
//

import Foundation
import CoreGraphics

extension CGPoint {
    
    func magnitude() -> CGFloat {
        return sqrt(x * x + y * y)
    }
    
    func normalized() -> CGPoint {
        
        let normalizedX = self.x / self.magnitude()
        let normalizedY = self.y / self.magnitude()
        
        return CGPoint(x: normalizedX, y: normalizedY)
        
    }
    
    func subtract(_ point: CGPoint) -> CGPoint {
        
        return CGPoint(x: self.x - point.x, y: self.y - point.y)
        
    }
}
