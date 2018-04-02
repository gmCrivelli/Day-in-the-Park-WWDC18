// Spawns clouds for a lively background!

import Foundation
import SpriteKit

class CloudSpawner : SKNode {
    
    // On init, it creates a couple of clouds already in view, then kickstars the rest of the cloud creation
    init(pos: CGPoint) {
        super.init()
        self.position = pos
        
        self.createSingleCloud(at: CGPoint(x: -600, y: 60))
        self.createSingleCloud(at: CGPoint(x: -250, y: 0))
        self.createCloudRepeat()
    }
    
    // Create one single cloud at the given CGPoint
    private func createSingleCloud(at pos: CGPoint) {
        // Random cloud type
        let cloudName = "cloud" + String(arc4random_uniform(4) + 1)
        let cloud = SKSpriteNode(imageNamed: cloudName)
        cloud.anchorPoint = CGPoint(x: 0, y: 0.5)
        cloud.position = pos
        
        // Add the cloud into the node
        self.addChild(cloud)
        
        // Random color (very ligth tones)
        let randomHue = CGFloat(arc4random_uniform(360)) / 360.0
        cloud.run(SKAction.colorize(with: UIColor(hue: randomHue, saturation: 1.0, brightness: 0.97, alpha: 1.0), colorBlendFactor: 0.05, duration: 0.0))
        
        // Cloud movement action
        let moveAction = SKAction.moveBy(x: -1300, y: 0.0, duration: 50.0 + TimeInterval(arc4random_uniform(20)))
        let removeAction = SKAction.removeFromParent()
        cloud.run(SKAction.sequence([moveAction, removeAction]))
    }
    
    // Creates clouds indefinitely
    private func createCloudRepeat() {
        // Vertical displacement
        let yDisplacement = CGFloat(arc4random_uniform(120)) - 60.0
        createSingleCloud(at: CGPoint(x: 0, y: yDisplacement))
        
        // Next cloud spawning action
        let waitDuration = TimeInterval(arc4random_uniform(8) + 8)
        let waitAction = SKAction.wait(forDuration: waitDuration)
        let spawnCloudAction = SKAction.run { [weak self] in
            // Recursion!
            self?.createCloudRepeat()
        }
        self.run(SKAction.sequence([waitAction, spawnCloudAction]))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
