//
//  PausedScreen.swift
//  HighJacked_AttemptThree
//
//  Created by Ikey Benzaken on 7/30/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import Foundation
import GameKit

class PausedScreen: CCNode {
    weak var vibrateLabel: CCLabelTTF!
    
    override func onEnter() {
        updateLabel()
    }
    
    func updateLabel () {
        if GameStateSingleton.sharedInstance.vibrationEnabled == true {
            vibrateLabel.string = "Vibration: On"
            shouldVibrate = true
        } else if GameStateSingleton.sharedInstance.vibrationEnabled == false {
            vibrateLabel.string = "Vibration: Off"
            shouldVibrate = false
        }
    }
    
    // BUTTONS
    func restart() {
        CCDirector.sharedDirector().presentScene(CCBReader.loadAsScene("Gameplay"))
        isPaused = false
    }
    
    func home() {
        CCDirector.sharedDirector().presentScene(CCBReader.loadAsScene("MainScene"))
        isPaused = false
    }
 
    func vibrateSelector() {
        if GameStateSingleton.sharedInstance.vibrationEnabled == true {
            GameStateSingleton.sharedInstance.vibrationEnabled = false
            
        } else if GameStateSingleton.sharedInstance.vibrationEnabled == false {
            GameStateSingleton.sharedInstance.vibrationEnabled = true
        }
        
        updateLabel()
    }

    
    
}

extension PausedScreen: GKGameCenterControllerDelegate {
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
