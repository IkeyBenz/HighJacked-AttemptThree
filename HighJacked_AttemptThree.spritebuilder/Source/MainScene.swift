import Foundation
import GameKit

class MainScene: CCNode {
    weak var settings: CCNode!
    weak var settingsButton: CCButton!
    var settingsIsShown: Bool = false
    func didLoadFromCCB() {
        setUpGameCenter()
        iAdHelper.sharedHelper()
        iAdHelper.setBannerPosition(TOP)
    }
    func playButton() {
        if !settingsIsShown {
            var gameplayScene = CCBReader.loadAsScene("Gameplay")
            CCDirector.sharedDirector().presentScene(gameplayScene)
        }
        
    }
    func showSettings() {
        if !settingsButton.selected {
            settingsButton.selected = true
            settings.visible = true
            settingsIsShown = true
        } else if settingsButton.selected {
            settingsButton.selected = false
            settings.visible = false
            settingsIsShown = false
        }
    }
    
}
extension MainScene: GKGameCenterControllerDelegate {
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
