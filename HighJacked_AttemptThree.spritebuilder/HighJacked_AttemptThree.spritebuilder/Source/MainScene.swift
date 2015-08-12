import Foundation

class MainScene: CCNode {
    func playButton() {
        var gameplayScene = CCBReader.loadAsScene("Gameplay")
        CCDirector.sharedDirector().presentScene(gameplayScene)
    }
}
