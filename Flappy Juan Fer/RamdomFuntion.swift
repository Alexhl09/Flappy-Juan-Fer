//
//  RamdomFuntion.swift
//  Flappy Juan Fer
//
//  Created by Alejandro on 02/01/17.
//  Copyright © 2017 Alejandro. All rights reserved.
//

import Foundation

import CoreGraphics

public extension CGFloat{
    public static func ramdom() -> CGFloat{
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    public static func ramdom(min : CGFloat, max : CGFloat) -> CGFloat{
        return CGFloat.ramdom() * (max - min) + min
    }
}
