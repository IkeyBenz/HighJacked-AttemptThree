//
//  File.swift
//  HighJacked_AttemptThree
//
//  Created by Ikey Benzaken on 7/27/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class Helicopter: CCSprite {
    
    weak var enemy: Enemy!
    var screenWidth = UIScreen.mainScreen().bounds.width
    var stoppedMoving: Bool = false
    
    enum State {
        case Right, Left
    }
    
    var side: State! {
        didSet {
            var randomHeight = Int(arc4random_uniform(180)) + Int(85)
            if side == .Right {
                position = ccp(CGFloat(Double(screenWidth) + Double(contentSizeInPoints.width / 2) * Double(scale)), CGFloat(randomHeight))
                animationManager.runAnimationsForSequenceNamed("LeftHeli")
                enemy.position = ccp(40.0, 0.5)
            } else if side == .Left {
                position = ccp(CGFloat(-Double(contentSizeInPoints.width) * 0.5 * Double(scale)), CGFloat(randomHeight))
                flipX = true
                animationManager.runAnimationsForSequenceNamed("RightHeli")
                enemy.position = ccp(108, 0.5)
            }
            
        }
    }
    
    func move(speed: Double) {
        var callblock = CCActionCallBlock(block: {self.stoppedMoving = true})
        var move: CCActionMoveTo
        if side == .Right {
            move = CCActionMoveTo(duration: speed, position: ccp(CGFloat(-Double(contentSizeInPoints.width) * 0.5 * Double(scale)), position.y))
        } else {
            move = CCActionMoveTo(duration: speed, position: ccp(CGFloat(Double(screenWidth) + Double(contentSizeInPoints.width / 2) * Double(scale)), position.y))
        }
        runAction(CCActionSequence(array: [move, callblock]))
    }
    
    
    
    
    
}