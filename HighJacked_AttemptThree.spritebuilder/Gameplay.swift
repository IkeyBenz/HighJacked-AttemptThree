//
//  Gameplay.swift
//  HighJacked_AttemptThree
//
//  Created by Ikey Benzaken on 7/27/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation

class Gameplay: CCNode, CCPhysicsCollisionDelegate {
    
    var gamePhysicsNode: CCPhysicsNode!
    var scoreLabel: CCLabelTTF!
    var playerScoreLabel: CCLabelTTF!
    var highScoreLabel: CCLabelTTF!
    var lifeBar: CCSprite!
    var score: Int = 0 {
        didSet {
            scoreLabel.string = "\(score)"
        }
    }
    
    var heliScale = 2.0
    var heliSpeed: Double!
    
    func didLoadFromCCB(){
        gamePhysicsNode.collisionDelegate = self
    }
    
    override func update(delta: CCTime) {
        var randomSpawn = arc4random_uniform(1000)
        if randomSpawn < 10 {
            spawnBlackHeli()
        }
    }
    
    func spawnHeli() {
        var heli = CCBReader.load("Helicopter") as! Helicopter
        heli.enemy.delegate = self
        heli.scale = Float(heliScale)
        heliSpeed = 4
        if arc4random_uniform(2) == 1 {
            heli.side = .Right
        } else {
            heli.side = .Left
        }
        gamePhysicsNode.addChild(heli)
        heli.move(heliSpeed)
    }
    
    func spawnBlackHeli() {
        var blackHeli = CCBReader.load("BlackHelicopter") as! BlackHelicopter
        blackHeli.enemy.delegate = self
        blackHeli.scale = Float(heliScale)
        heliSpeed = 4
        if arc4random_uniform(2) == 1 {
            blackHeli.side = .Right
        } else {
            blackHeli.side = .Left
        }
        gamePhysicsNode.addChild(blackHeli)
        blackHeli.move(heliSpeed)
    }
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, gunActivator: CCNode!, blackHelicopter: Helicopter!) -> Bool {
        if blackHelicopter.enemy != nil {
         blackHelicopter.enemy.animationManager.runAnimationsForSequenceNamed("Shooting")
        }
        
        return true
    }
    

    
    
}

extension Gameplay: EnemyDelegate{
    func enemyKilled(score: Int) {
        self.score += score
    }
}