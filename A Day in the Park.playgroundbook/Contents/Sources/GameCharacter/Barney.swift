// Barney! This inherits from the GameCharacter class, and mostly just sets up the character animations.

import Foundation
import SpriteKit

class Barney : GameCharacter {
    
    init(at pos: CGPoint) {
        super.init(characterName: .barney)
        self.initialPos = pos
        self.sprite.position = pos
        self.shadow.position = pos + CGPoint(x: 0, y: 1)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func runStandbyActions() {
        
        // Character animation
        let bounceDown = SKAction.scaleX(to: 1.02, y: 0.97, duration: 0.7)
        bounceDown.timingMode = .easeIn
        let bounceUp = SKAction.scaleX(to: 1.0, y: 1.0, duration: 0.7)
        bounceUp.timingMode = .easeOut
        
        let bounceAction = SKAction.repeatForever(SKAction.sequence([bounceDown, bounceUp]))
        self.sprite.run(bounceAction, withKey: "standby")
    }
}
