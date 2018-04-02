// Hector! This inherits from the GameCharacter class, and mostly just sets up the character animations.

import Foundation
import SpriteKit

class Hector : GameCharacter {
    
    init(at pos: CGPoint) {
        super.init(characterName: .hector)
        self.initialPos = pos
        self.sprite.position = pos
        self.shadow.position = pos + CGPoint(x: 0, y: -30)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func runStandbyActions() {
        
        // Character animation
        let floatUp = SKAction.move(to: self.initialPos + CGPoint(x: 0.0, y: 15.0), duration: 1.5)
        floatUp.timingMode = .easeInEaseOut
        let floatDown = SKAction.move(to: self.initialPos, duration: 1.5)
        floatDown.timingMode = .easeInEaseOut
        
        let floatAction = SKAction.repeatForever(SKAction.sequence([floatUp, floatDown]))
        self.sprite.run(floatAction, withKey: "standby")
        
        // Shadow animation
        let fadeOut = SKAction.fadeAlpha(to: 0.5, duration: 1.5)
        fadeOut.timingMode = .easeInEaseOut
        let fadeIn = SKAction.fadeAlpha(to: 1.0, duration: 1.5)
        fadeIn.timingMode = .easeInEaseOut
        
        let fadeAction = SKAction.repeatForever(SKAction.sequence([fadeOut, fadeIn]))
        self.shadow.run(fadeAction, withKey: "standby")
    }
}
