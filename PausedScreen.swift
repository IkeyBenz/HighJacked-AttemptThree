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
    // BUTTONS
    func restart() {
        CCDirector.sharedDirector().presentScene(CCBReader.loadAsScene("Gameplay"))
        isPaused = false
    }
    
    func home() {
        CCDirector.sharedDirector().presentScene(CCBReader.loadAsScene("MainScene"))
        isPaused = false
    }
    
    //LEADERBOARD BUTTON!!!!
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
