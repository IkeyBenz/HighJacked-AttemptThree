//
//  Settings.swift
//  HighJacked_AttemptThree
//
//  Created by Ikey Benzaken on 8/5/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class Settings: CCScene {
    func back() {
        CCDirector.sharedDirector().presentScene(CCBReader.loadAsScene("MainScene"))
    }
}