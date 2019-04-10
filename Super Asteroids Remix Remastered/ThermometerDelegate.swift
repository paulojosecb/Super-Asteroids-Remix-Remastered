//
//  ThermometerDelegate.swift
//  Super Asteroids Remix Remastered
//
//  Created by Martônio Júnior on 09/04/19.
//  Copyright © 2019 Paulo José. All rights reserved.
//

import Foundation

protocol ThermometerDelegate {
    func currentThermo() -> Int
    func limitThermo() -> Int
    func isCoolingDown() -> Bool
}
