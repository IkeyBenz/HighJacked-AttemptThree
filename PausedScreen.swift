//
//  PausedScreen.swift
//  HighJacked_AttemptThree
//
//  Created by Ikey Benzaken on 7/30/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation
class PausedScreen: CCNode {
    // BUTTONS
    func restart() {
        CCDirector.sharedDirector().presentScene(CCBReader.loadAsScene("Gameplay"))
        isPaused = false
    }
    
    func home() {
        CCDirector.sharedDirector().presentScene(CCBReader.loadAsScene("MainScene"))
    }
}