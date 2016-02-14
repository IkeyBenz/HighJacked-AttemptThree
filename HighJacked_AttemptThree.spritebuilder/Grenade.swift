//
//  Grenade.swift
//  HighJacked_AttemptThree
//
//  Created by Ikey Benzaken on 8/4/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

protocol GrenadeDelegate {
    func addGrenades(addedGrenade: Int)
}

class Grenade: CCSprite {
    var delegate: GrenadeDelegate!
    func move() {
        let move = CCActionMoveBy(duration: 3, position:  ccp(CGFloat(0), -CGFloat(400)))
        let callblock = CCActionCallBlock(block: {self.removeFromParent()})
        runAction(CCActionSequence(array: [move, callblock]))
    }
    
    func didLoadFromCCB() {
        userInteractionEnabled = true
    }
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        delegate.addGrenades(1)
        self.removeFromParent()
    }
    
}