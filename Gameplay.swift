//
//  Gameplay.swift
//  HighJacked_AttemptThree
//
//  Created by Ikey Benzaken on 7/27/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation
import AudioToolbox
import GameKit


var isPaused: Bool = false

class Gameplay: CCNode, CCPhysicsCollisionDelegate, helicopterDelegate {
    
    // GAMEPLAY PROPERTIES
    weak var gamePhysicsNode: CCPhysicsNode!
    var gameover: Bool = false
    var gameoverWasTriggered: Bool = false
    var pauseButtonWasTouched: Bool = false
    var grenadeButtonPressed: Bool = false
    let defaults = NSUserDefaults.standardUserDefaults()
    weak var pausedScreen: CCNode!
    weak var topRedArrow: CCSprite!
    weak var leftRedArrow: CCSprite!
    var arrowAnimationIsPlaying: Bool = false
    var numberOfGrenades: Int = 3 {
        didSet {
            amountOfGrenadesLabel.string = String(numberOfGrenades)
            if numberOfGrenades == 0 {
                amountOfGrenadesLabel.color = CCColor(ccColor3b: ccColor3B(r: 225, g: 0, b: 0))
            } else if numberOfGrenades > 0 {
                amountOfGrenadesLabel.color = CCColor(ccColor3b: ccColor3B(r: 225, g: 225, b: 255))
            }
        }
    }
    weak var grenadeButton: CCButton!
    
    // LABELS
    weak var scoreLabel: CCLabelTTF!
    weak var playerScoreLabel: CCLabelTTF!
    weak var highScoreLabel: CCLabelTTF!
    weak var pausedButton: CCButton!
    weak var amountOfGrenadesLabel: CCLabelTTF!
    
    // HELICOPTER PROPERTIES
    var newBlackHeli: Helicopter!
    var heliScale: Double = 3.0
    var heliSpeed: Double = 5
    var randomHeliSpawn: UInt32 = 10
    var randomBlackHeliSpawn: UInt32 = 0
    var heliArray: [Helicopter] = []
    
    // HEALTH AND SCORE PROPERTIES
    weak var lifeBar: CCSprite!
    weak var healthBar: CCSprite!
    var health: Float = 400 {
        didSet {
            health = max(min(health, 400),0)
            lifeBar.scaleX = health / 200
            // GAMEOVER
            if health <= 0 {
                if !gameoverWasTriggered {
                    animationManager.runAnimationsForSequenceNamed("Game Over Label")
                    gameoverWasTriggered = true
                    gameover = true
                    scoreLabel.visible = false
                    pausedButton.visible = false
                    playerScoreLabel.string = "Your Score: \(score)"
                    grenadeButton.visible = false
                    amountOfGrenadesLabel.visible = false
                    topRedArrow.visible = false
                    leftRedArrow.visible = false
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
                randomHeliSpawn = 13
                randomBlackHeliSpawn = 0
                heliScale = 2.5
                heliSpeed = 4
            } else if score < 150 && score >= 100 {
                randomHeliSpawn = 11
                randomBlackHeliSpawn = 2
                heliScale = 2.3
                heliSpeed = 4
            } else if score < 200 && score >= 150 {
                randomHeliSpawn = 11
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
                heliScale = 1.9
                heliSpeed = 3.4
            } else if score < 450 && score >= 400 {
                randomHeliSpawn = 4
                randomBlackHeliSpawn = 12
                heliScale = 1.7
                heliSpeed = 3.2
            } else if score >= 450 {
                randomHeliSpawn = 1
                randomBlackHeliSpawn = 14
                heliScale = 1.5
                heliSpeed = 3
            }
            
            
        }
    }
    
    // GRENADE BUTTON ANIMATION
    var numberOfEnemiesOnScreen: Int = 0 {
        didSet {
            if numberOfGrenades > 0 {
                if numberOfEnemiesOnScreen > 4 {
                    if !grenadeButtonPressed {
                        if !arrowAnimationIsPlaying {
                            topRedArrow.visible = true
                            leftRedArrow.visible = true
                            animationManager.runAnimationsForSequenceNamed("Grenade Button Arrows")
                            arrowAnimationIsPlaying = true
                        }
                    }
                }
            }
        }
    }
    
    
    //SHOOTING FEATURE
    //    var isTouching: Bool!
    //    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
    //        isTouching = true
    //        var touchPosition = touch.locationInWorld()
    //        if isTouching == true {
    //            for var x = 0; x < 100; x++ {
    //                spawnBullets(touchPosition)
    //            }
    //        }
    //    }
    //    override func touchEnded(touch: CCTouch!, withEvent event: CCTouchEvent!) {
    //        isTouching = false
    //    }
    //
    //    func spawnBullets(touchPosition: CGPoint) {
    //        var touchPosition = touchPosition
    //        var bullet = CCBReader.load("Bullets") as! Bullets
    //        var screenWidth = UIScreen.mainScreen().bounds.width
    //        bullet.position = ccp(screenWidth / 2, CGFloat(-10))
    //        bullet.scale = 0.2
    //        addChild(bullet)
    //        bullet.move(touchPosition)
    //
    //    }
    
    func didLoadFromCCB(){
        userInteractionEnabled = true
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
        numberOfEnemiesOnScreen++
        gamePhysicsNode.addChild(heli)
        heliArray.append(heli)
        heli.move(heliSpeed)
        
        
    }
    
    func spawnBlackHeli() {
        var blackHeli = CCBReader.load("BlackHelicopter") as! Helicopter
        blackHeli.enemy.delegate = self
        blackHeli.delegate = self
        blackHeli.scale = Float(heliScale)
        if arc4random_uniform(1) == 1 {
            blackHeli.side = .Right
        } else {
            blackHeli.side = .Left
        }
        numberOfEnemiesOnScreen++
        gamePhysicsNode.addChild(blackHeli)
        heliArray.append(blackHeli)
        blackHeli.move(heliSpeed)
        
    }
    
    // SPAWN GOLD COINS
    func spawnGold(goldPosition: CGPoint) {
        var goldCoin = CCBReader.load("Gold") as! Gold
        var randomXposition = arc4random_uniform(500) + 25
        goldCoin.position = goldPosition
        goldCoin.scale = 0.7
        gamePhysicsNode.addChild(goldCoin)
        goldCoin.delegate = self
    }
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, coin: Gold!, coinDeleter: CCNode!) -> ObjCBool {
        coin.removeFromParent()
        return true
    }
    
    // WHEN BLACK HELICOPTER PASSES MIDDLE OF SCREEN
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, gunActivator: CCNode!, blackHelicopter: Helicopter!) -> ObjCBool {
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
                    health -= 0.3
                    AudioServicesPlayAlertSound(1352)
                }
            }
        }
    }
    
    // WHEN HELICOPTER LEAVES SCREEN
    func lowerHealth(doesHaveEnemies: Bool) {
        if doesHaveEnemies {
            health -= 100
            numberOfEnemiesOnScreen -= 1
            changeColor()
        }
    }
    func changeColor() {
        lifeBar.color = CCColor(ccColor3b: ccColor3B(r: 255, g: 0, b: 0))
        healthBar.scaleX = 1.4652
        healthBar.scaleY = 0.9096
        scheduleOnce("returnToYellow", delay: 0.2)
    }
    func returnToYellow() {
        lifeBar.color = CCColor(ccColor3b: ccColor3B(r: 255, g: 255, b: 127))
        healthBar.scaleX = 1.221
        healthBar.scaleY = 0.758
    }
    
    
    // UPDATE
    override func update(delta: CCTime) {
        if !gameover {
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
            
            updateHealthAndVibrate()
        }
        checkForHighScore()
    }
    
    // BUTTONS
    func restart() {
        CCDirector.sharedDirector().presentScene(CCBReader.loadAsScene("Gameplay"))
    }
    
    func pause() {
        if pausedButton.selected {
            paused = false
            pausedScreen.visible = false
            pausedButton.selected = false
            isPaused = false
            
        } else if !pausedButton.selected {
            paused = true
            pausedScreen.visible = true
            pausedButton.selected = true
            isPaused = true
            
        }
    }
    
    func home() {
        CCDirector.sharedDirector().presentScene(CCBReader.loadAsScene("MainScene"))
    }
    
    func launchGrenade() {
        if !grenadeButtonPressed {
            grenadeButtonPressed = true
            topRedArrow.visible = false
            leftRedArrow.visible = false
            if numberOfGrenades > 0 {
                animationManager.runAnimationsForSequenceNamed("Grenade Explosion")
                arrowAnimationIsPlaying = false
                numberOfGrenades -= 1
            }
        }
    }
    
    // CALLBACKS
    func lifeBarDisappear() {
        lifeBar.visible = false
        healthBar.visible = false
    }
    func removeAllHelicopters() {
        for helicopter in heliArray {
            if helicopter.enemy != nil {
                helicopter.enemy.isShooting = false
                score += Int(arc4random_uniform(3))
                numberOfEnemiesOnScreen -= 1
            }
            helicopter.removeFromParent()
        }
        grenadeButtonPressed = false
    }
    
    // HIGHSCORE & GAME CENTER
    func checkForHighScore() {
        var currentHighscore = defaults.integerForKey("highScore")
        if score > currentHighscore {
            defaults.setInteger(score, forKey: "highScore")
        }
        GameCenterInteractor.sharedInstance.reportHighScoreToGameCenter(currentHighscore)
        highScoreLabel.string = "High Score: \(currentHighscore)"
    }
}

// SCORE AND GRENADE SPAWN
extension Gameplay: EnemyDelegate {
    func enemyKilled(score: Int, grenadePosition: CGPoint) {
        numberOfEnemiesOnScreen -= 1
        self.score += score
        var rand = arc4random_uniform(20)
        var randTwo = arc4random_uniform(20)
        if rand == 1 {
            spawnGold(grenadePosition)
        } else if randTwo < 2 {
            var grenade = CCBReader.load("Grenade") as! Grenade
            grenade.delegate = self
            grenade.position = grenadePosition
            gamePhysicsNode.addChild(grenade)
            grenade.move()
        }
    }
}
// HEALTH
extension Gameplay: GoldDelegate {
    func goldTapped(healthIncrease: Float) {
        self.health += healthIncrease
    }
}
// GRENADES
extension Gameplay: GrenadeDelegate {
    func addGrenades(addedGrenade: Int) {
        numberOfGrenades += addedGrenade
    }
}

//GAME CENTER
extension Gameplay: GKGameCenterControllerDelegate {
    func showLeaderboard() {
        var viewController = CCDirector.sharedDirector().parentViewController!
        var gameCenterViewController = GKGameCenterViewController()
        gameCenterViewController.gameCenterDelegate = self
        viewController.presentViewController(gameCenterViewController, animated: true, completion: nil)
    }
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController!) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    func setUpGameCenter() {
        let gameCenterInteractor = GameCenterInteractor.sharedInstance
        gameCenterInteractor.authenticationCheck()
    }
    
}
