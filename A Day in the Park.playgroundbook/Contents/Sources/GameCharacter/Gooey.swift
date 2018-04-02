// Gooey! This inherits from the GameCharacter class, and mostly just sets up the character animations.

import Foundation
import SpriteKit

class Gooey : GameCharacter {
    
    init(at pos: CGPoint) {
        super.init(characterName: .gooey)
        self.initialPos = pos
        self.sprite.position = pos
        self.shadow.position = pos + CGPoint(x: 0, y: 3)
        self.shadow.xScale = 1.5
        self.shadow.yScale = 0.78
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func runStandbyActions() {
        
        // Character animation
        let bounceDown = SKAction.scaleX(to: 1.08, y: 0.9, duration: 1.2)
        bounceDown.timingMode = .easeInEaseOut
        let bounceUp = SKAction.scaleX(to: 1.0, y: 1.0, duration: 1.2)
        bounceUp.timingMode = .easeInEaseOut
        
        let bounceAction = SKAction.repeatForever(SKAction.sequence([bounceDown, bounceUp]))
        self.sprite.run(bounceAction, withKey: "standby")
    }
}
