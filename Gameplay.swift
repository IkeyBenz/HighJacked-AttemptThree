//
//  Gameplay.swift
//  HighJacked_AttemptThree
//
//  Created by Ikey Benzaken on 7/27/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation
import AudioToolbox

class Gameplay: CCNode, CCPhysicsCollisionDelegate {
    
    var gamePhysicsNode: CCPhysicsNode!
    
    // LABELS
    var scoreLabel: CCLabelTTF!
    var playerScoreLabel: CCLabelTTF!
    var highScoreLabel: CCLabelTTF!
    
    // HEALTH AND SCORE PROPERTIES
    var lifeBar: CCSprite!
    var health: Float = 400 {
        didSet {
            health = max(min(health, 400),0)
            lifeBar.scaleX = health / 400
        }
    }
    var score: Int = 0 {
        didSet {
            scoreLabel.string = "\(score)"
            
            if score < 20 {
                randomHeliSpawn = 5
                randomBlackHeliSpawn = 0
                heliScale = 3.0
                heliSpeed = 5
            } else if score < 100 && score >= 20 {
                randomHeliSpawn = 6
                randomBlackHeliSpawn = 0
                heliScale = 2.5
                heliSpeed = 4
            } else if score < 150 && score >= 100 {
                randomHeliSpawn = 7
                randomBlackHeliSpawn = 0
                heliScale = 2.3
                heliSpeed = 4
            } else if score < 200 && score >= 150 {
                randomHeliSpawn = 7
                randomBlackHeliSpawn = 1
                heliScale = 2.0
                heliSpeed = 3.7
            } else if score < 250 && score >= 200 {
                randomHeliSpawn = 6
                randomBlackHeliSpawn = 2
                heliScale = 2.0
                heliSpeed = 3.5
            } else if score < 300 && score >= 250 {
                randomHeliSpawn = 4
                randomBlackHeliSpawn = 4
                heliScale = 1.7
                heliSpeed = 3.5
            } else if score < 400 && score >= 300 {
                randomHeliSpawn = 2
                randomBlackHeliSpawn = 6
                heliScale = 1.7
                heliSpeed = 3.4
            } else if score < 450 && score >= 400 {
                randomHeliSpawn = 0
                randomBlackHeliSpawn = 8
                heliScale = 1.5
                heliSpeed = 3.2
            } else if score >= 450 {
                randomHeliSpawn = 0
                randomBlackHeliSpawn = 10
                heliScale = 1.5
                heliSpeed = 3
            }
        }
    }
    // HELICOPTER PROPERTIES
    var newBlackHeli: Helicopter!
    var heliScale: Double = 3.0
    var heliSpeed: Double = 5
    var randomHeliSpawn: UInt32 = 5
    var randomBlackHeliSpawn: UInt32 = 0
    
    func didLoadFromCCB(){
        gamePhysicsNode.collisionDelegate = self
    }
    
    // HELICOPTERS SPWAN
    func spawnHeli() {
        var heli = CCBReader.load("Helicopter") as! Helicopter
        heli.enemy.delegate = self
        heli.scale = Float(heliScale)
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
        if arc4random_uniform(2) == 1 {
            blackHeli.side = .Right
        } else {
            blackHeli.side = .Left
        }
        gamePhysicsNode.addChild(blackHeli)
        blackHeli.move(heliSpeed)
    }
    
    // WHEN BLACK HELICOPTER PASSES MIDDLE OF SCREEN
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, gunActivator: CCNode!, blackHelicopter: Helicopter!) -> Bool {
        if blackHelicopter.enemy != nil {
            blackHelicopter.enemy.animationManager.runAnimationsForSequenceNamed("Shooting")
            blackHelicopter.enemy.isShooting = true
            newBlackHeli = blackHelicopter
        }
        return true
    }
    
    // WHEN BLACK HELICOPTER SHOOTS
    func updateHealthAndVibrate() {
        if newBlackHeli != nil {
            if newBlackHeli.enemy != nil {
                if newBlackHeli.enemy.isShooting {
                    health -= 1
                    AudioServicesPlayAlertSound(1352)
                }
            }
        }
    }
    
    // WHEN HELICOPTER LEAVES SCREEN
    func whenHelisLeaveScreen(heli: Helicopter!) {
        if heli.stoppedMoving {
            
        }
    }
    
    
    // UPDATE
    override func update(delta: CCTime) {
        updateHealthAndVibrate()
        
        // Spawn Black Helis
        var randomBlackSpawn = arc4random_uniform(1000)
        if randomBlackSpawn < randomBlackHeliSpawn {
            spawnBlackHeli()
        }
        // Spawn Regular Helis
        var randomSpawn = arc4random_uniform(1000)
        if randomSpawn < randomHeliSpawn {
            spawnHeli()
        }
    }
    

    
}

extension Gameplay: EnemyDelegate{
    func enemyKilled(score: Int) {
        self.score += score
    }
}