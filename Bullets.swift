//
//  Bullets.swift
//  HighJacked_AttemptThree
//
//  Created by Ikey Benzaken on 7/31/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class Bullets: CCParticleSystem {
    func move(touchPosition: CGPoint) {
        let move: CCActionMoveTo
        let callblock = CCActionCallBlock(block: {self.removeFromParent()})
        move = CCActionMoveTo(duration: 1, position: touchPosition)
        runAction(CCActionSequence(array: [move, callblock]))
    }
}