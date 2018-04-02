// Factory pattern for GameCharacter instantiation. Nothing too exciting really.

import Foundation
import CoreGraphics

class GameCharacterFactory {
    
    func createGameCharacter(_ characterName: GameCharacterName, at pos: CGPoint) -> GameCharacter {
        
        switch characterName {
            case .barney:
                return Barney(at: pos)
            case .frank:
                return Frank(at: pos)
            case .gooey:
                return Gooey(at: pos)
            default:
                return Hector(at: pos)
        }
    }
}
