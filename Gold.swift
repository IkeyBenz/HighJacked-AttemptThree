//
//  Gold.swift
//  HighJacked_AttemptThree
//
//  Created by Ikey Benzaken on 7/30/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

protocol GoldDelegate {
    func goldTapped(healthIncrease: Float)
}

class Gold: CCSprite {
    var delegate: GoldDelegate!
    
    func didLoadFromCCB() {
        userInteractionEnabled = true
    }
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        removeFromParent()
        delegate.goldTapped(40) 
    }
}