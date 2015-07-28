//
//  Gameplay.swift
//  HighJacked_AttemptThree
//
//  Created by Ikey Benzaken on 7/27/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation
import AudioToolbox

class Gameplay: CCNode, CCPhysicsCollisionDelegate, helicopterDelegate {
    
    // GAMEPLAY PROPERTIES
    var gamePhysicsNode: CCPhysicsNode!
    var gameover: Bool = false
    var gameoverWasTriggered: Bool = false
    let defaults = NSUserDefaults.standardUserDefaults()
    
    
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
            
            if health <= 0 {
                if !gameoverWasTriggered {
                    animationManager.runAnimationsForSequenceNamed("Game Over Label")
                    gameoverWasTriggered = true
                    gameover = true
                    scoreLabel.visible = false
                    playerScoreLabel.string = "Your Score: \(score)"
                }
            }
        }
    }
    
    var score: Int = 0 {
        didSet {
            scoreLabel.string = "\(score)"
            if score < 10 {
                randomHeliSpawn = 10
                randomBlackHeliSpawn = 0
                heliScale = 3.0
                heliSpeed = 4
            } else if score < 60 && score >= 10 {
                randomHeliSpawn = 12
                randomBlackHeliSpawn = 0
                heliScale = 2.5
                heliSpeed = 4
            } else if score < 100 && score >= 60 {
                randomHeliSpawn = 14
                randomBlackHeliSpawn = 0
                heliScale = 2.5
                heliSpeed = 4
            } else if score < 150 && score >= 100 {
                randomHeliSpawn = 12
                randomBlackHeliSpawn = 2
                heliScale = 2.3
                heliSpeed = 4
            } else if score < 200 && score >= 150 {
                randomHeliSpawn = 12
                randomBlackHeliSpawn = 4
                heliScale = 2.0
                heliSpeed = 3.7
            } else if score < 250 && score >= 200 {
                randomHeliSpawn = 10
                randomBlackHeliSpawn = 6
                heliScale = 2.0
                heliSpeed = 3.5
            } else if score < 300 && score >= 250 {
                randomHeliSpawn = 8
                randomBlackHeliSpawn = 8
                heliScale = 1.7
                heliSpeed = 3.5
            } else if score < 400 && score >= 300 {
                randomHeliSpawn = 6
                randomBlackHeliSpawn = 10
                heliScale = 1.7
                heliSpeed = 3.4
            } else if score < 450 && score >= 400 {
                randomHeliSpawn = 4
                randomBlackHeliSpawn = 12
                heliScale = 1.5
                heliSpeed = 3
            } else if score >= 450 {
                randomHeliSpawn = 1
                randomBlackHeliSpawn = 14
                heliScale = 1.7
                heliSpeed = 2.5
            }
            
           
        }
    }
    // HELICOPTER PROPERTIES
    var newBlackHeli: Helicopter!
    var helicopters: [Helicopter!] = []
    var heliScale: Double = 3.0
    var heliSpeed: Double = 5
    var randomHeliSpawn: UInt32 = 10
    var randomBlackHeliSpawn: UInt32 = 0
    
    func didLoadFromCCB(){
        gamePhysicsNode.collisionDelegate = self
    }
    
    // HELICOPTERS SPWAN
    func spawnHeli() {
        var heli = CCBReader.load("Helicopter") as! Helicopter
        heli.enemy.delegate = self
        heli.delegate = self
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
        var blackHeli = CCBReader.load("BlackHelicopter") as! Helicopter
        blackHeli.enemy.delegate = self
        blackHeli.delegate = self
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
    func lowerHealth(doesHaveEnemies: Bool) {
        if doesHaveEnemies {
           health -= 100  
        }
    }
    
    
    // UPDATE
    override func update(delta: CCTime) {
        if !gameover {
            
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
        var currentHighscore = defaults.integerForKey("highScore")
        
        if score > currentHighscore {
            defaults.setInteger(score, forKey: "highScore")
        }
        
        highScoreLabel.string = "High Score: \(currentHighscore)"
    }
    
    func restart() {
        CCDirector.sharedDirector().presentScene(CCBReader.loadAsScene("MainScene"))
    }
    
    

    
}

extension Gameplay: EnemyDelegate {
    func enemyKilled(score: Int) {
        self.score += score
    }
}