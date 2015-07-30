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
    var screenHeight = UIScreen.mainScreen().bounds.height
    var stoppedMoving: Bool = false
    var numberOfHelis: Int = 0
    var delegate: helicopterDelegate!
    
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
        if numberOfHelis < 2 {
            var callblock = CCActionCallBlock(block: {self.delegate.lowerHealth(self.checkForEnemies())})
            var move: CCActionMoveTo
            if side == .Right {
                move = CCActionMoveTo(duration: speed, position: ccp(CGFloat(-Double(contentSizeInPoints.width) * 0.5 * Double(scale)), position.y))
            } else {
                move = CCActionMoveTo(duration: speed, position: ccp(CGFloat(Double(screenWidth) + Double(contentSizeInPoints.width / 2) * Double(scale)), position.y))
            }
            runAction(CCActionSequence(array: [move, callblock]))
            
            //MOVE UP AND DOWN
            let randomUpDistance = arc4random_uniform(30) + 25
            var swerveUp = CCActionMoveBy(duration: speed/4, position: ccp(CGFloat(0), CGFloat(randomUpDistance)))
            let randomDownDistance = arc4random_uniform(40) + 40
            var swerveDown = CCActionMoveBy(duration: speed/4, position: ccp(CGFloat(0), -CGFloat(randomDownDistance)))
            
            if self.position.y < screenHeight / 2 {
                runAction(CCActionSequence(array: [swerveUp, swerveDown, swerveUp, swerveDown]))
            } else {
                runAction(CCActionSequence(array: [swerveDown, swerveUp, swerveDown, swerveUp]))
            }
            numberOfHelis += 1
        }
        
    }
    
    func checkForEnemies() -> Bool {
        if children.count > 1 {
            enemy.isShooting = false
            numberOfHelis -= 1
            removeFromParent()
            return true
        }
        removeFromParent()
        numberOfHelis -= 1
        return false
    }
    
}

protocol helicopterDelegate {
    func lowerHealth(doesHaveEnemies:Bool)
}


