//
//  IntroAnimation.swift
//  HighJacked_AttemptThree
//
//  Created by Ikey Benzaken on 7/29/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

var introFinished: Bool = false

class IntroAnimation: CCNode {
    weak var textBubble: CCSprite!

    func loadMainScene() {
        CCDirector.sharedDirector().presentScene(CCBReader.loadAsScene("MainScene"))
        introFinished = true
    }
    func textBubbleAppear() {
        textBubble.visible = true
    }
    func textBubbleDisappear() {
        textBubble.visible = false
    }
    func skipAnimation() {
        CCDirector.sharedDirector().presentScene(CCBReader.loadAsScene("MainScene"))
        introFinished = true
    }
}