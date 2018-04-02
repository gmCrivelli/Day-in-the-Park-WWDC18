// Public methods for live view initialization

import SpriteKit
import PlaygroundSupport

public let gameScene:GameScene = GameScene(fileNamed: "GameScene")!

public func loadScene() {
    
    // Load the SKScene from 'GameScene.sks'
    let sceneView = SKView(frame: CGRect(x:0 , y:0, width: 686, height: 686))
    
    // Set the scale mode to scale to fit the window
    gameScene.scaleMode = .aspectFit
    
    // Present the scene
    sceneView.presentScene(gameScene)
    
    PlaygroundPage.current.liveView = sceneView
}
