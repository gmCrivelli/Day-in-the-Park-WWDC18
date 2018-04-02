// Manager for the GameCharacters. Instantiates them through a GameCharacterFactory, keeps track of their references, and manages their positions so that they remain centered no matter how many characters are created.
// Also allows for easy single target/mass animation.

import Foundation
import CoreGraphics

class GameCharacterManager {
    
    // GameCharacter instantiator
    private var gameCharacterFactory : GameCharacterFactory = GameCharacterFactory()
    
    // References to the GameCharacter objects
    private(set) var gameCharacterDict = [GameCharacterName: GameCharacter]()
    
    // Creates and centers the characters given in 'gameCharacterNames'
    // This always creates a new array of characters, so all of the characters must be created in a single call.
    func createCharacters(_ gameCharacterNames: [GameCharacterName]) {
        
        var characterHeights = [GameCharacterName:CGFloat]()
        characterHeights[.hector] = -207.6
        characterHeights[.gooey] = -225.7
        characterHeights[.frank] = -216
        characterHeights[.barney] = -233.5
        
        // GameCharacter spacing and centering, assumes that the center is always in CGPoint.zero .
        let xDisplacement:CGFloat = 120
        var xPosition:CGFloat = 0.0
        
        for name in gameCharacterNames {
            let x = xPosition - xDisplacement * CGFloat(gameCharacterNames.count - 1) / 2.0
            self.gameCharacterDict[name] = gameCharacterFactory.createGameCharacter(name, at: CGPoint(x: x, y: characterHeights[name] ?? -220))
            xPosition += xDisplacement
        }
    }
    
    // Animates a single GameCharacter, if available
    func animate(characterName: GameCharacterName, with mood: GameCharacterMood) {
        if let character = self.gameCharacterDict[characterName] {
            character.animate(mood: mood)
        }
    }
    
    // Animates all available GameCharacters
    func animateAll(with mood: GameCharacterMood) {
        for (_, character) in gameCharacterDict {
            character.animate(mood: mood)
        }
    }
}
