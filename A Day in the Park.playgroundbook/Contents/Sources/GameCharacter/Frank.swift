// Frank! This inherits from the GameCharacter class, and mostly just sets up the character animations.

import Foundation
import SpriteKit

class Frank : GameCharacter {
    
    init(at pos: CGPoint) {
        super.init(characterName: .frank)
        self.sprite.anchorPoint = CGPoint(x: 0.5, y: 0.85)
        self.sprite.position = pos + CGPoint(x: 0.0, y: self.sprite.frame.height * 0.85)
        self.shadow.position = pos + CGPoint(x: 0, y: -19)
        self.initialPos = self.sprite.position
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func runStandbyActions() {
        
        // Character animation
        let floatUp = SKAction.move(to: self.initialPos + CGPoint(x: 0.0, y: 15.0), duration: 1.0)
        let bounceUp = SKAction.scaleX(to: 1.05, y: 0.96, duration: 1.0)
        let floatUpGroup = SKAction.group([floatUp, bounceUp])
        floatUpGroup.timingMode = .easeInEaseOut
        
        let floatDown = SKAction.move(to: self.initialPos, duration: 1.0)
        let bounceDown = SKAction.scaleX(to: 1.0, y: 1.0, duration: 1.0)
        let floatDownGroup = SKAction.group([floatDown, bounceDown])
        floatDownGroup.timingMode = .easeInEaseOut
        
        let floatAction = SKAction.repeatForever(SKAction.sequence([floatUpGroup, floatDownGroup]))
        self.sprite.run(floatAction, withKey: "standby")
        
        // Shadow animation
        let fadeOut = SKAction.fadeAlpha(to: 0.5, duration: 1.0)
        fadeOut.timingMode = .easeInEaseOut
        let fadeIn = SKAction.fadeAlpha(to: 1.0, duration: 1.0)
        fadeIn.timingMode = .easeInEaseOut
        
        let fadeAction = SKAction.repeatForever(SKAction.sequence([fadeOut, fadeIn]))
        self.shadow.run(fadeAction, withKey: "standby")
    }
}
