//
//  Enemy.swift
//  HighJacked_AttemptThree
//
//  Created by Ikey Benzaken on 7/27/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation


protocol EnemyDelegate {
    func enemyKilled(score: Int)
}


class Enemy: CCSprite {
    var delegate: EnemyDelegate!
    var isShooting: Bool = false
    
    func didLoadFromCCB() {
        userInteractionEnabled = true
    }
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        var randomScoreIncrease = arc4random_uniform(5) + 2
        delegate.enemyKilled(Int(randomScoreIncrease))
        isShooting = false
        removeFromParent()
    }
    
   
    
}