// Crowley is very similar to the rest of the GameCharacter child classes.
// However, there are some important differences, such as him not being a playable character,
// and there being extra methods and nodes for displaying messages.
// I decided to take the easy way out and just made it a separate class altogether.

import Foundation
import SpriteKit

class Crowley : SKNode {
    
    // Child nodes
    var sprite: SKSpriteNode!
    var speechBubble: SpeechBubble!
    
    // Initial position, this will keep the movement SKActions stable
    var initialPos : CGPoint!
    
    // Store this character's textures, so they can be reused
    private var happyTexture : SKTexture
    private var standbyTexture : SKTexture
    private var sadTexture : SKTexture
    private var hiTexture : SKTexture
    
    // Sounds should be loaded once per character only, let's store their actions
    private var soundActions : [SKAction] = [SKAction]()
    
    init(pos: CGPoint) {
        // Initialize this character's textures
        self.happyTexture = SKTexture(imageNamed: "crowleyHappy")
        self.standbyTexture = SKTexture(imageNamed: "crowleyStandby")
        self.sadTexture = SKTexture(imageNamed: "crowleySad")
        self.hiTexture = SKTexture(imageNamed: "crowleyHi")
        
        // Initialize the character's sounds
        self.soundActions.append(SKAction.playSoundFileNamed("crowleySound1.mp3", waitForCompletion: false))
        self.soundActions.append(SKAction.playSoundFileNamed("crowleySound2.mp3", waitForCompletion: false))
        self.soundActions.append(SKAction.playSoundFileNamed("crowleySound3.mp3", waitForCompletion: false))
        
        super.init()
        
        self.position = pos
        self.zPosition = 5
        
        // Initialize child nodes
        self.sprite = SKSpriteNode(texture: standbyTexture)
        self.sprite.name = "crowley"
        self.sprite.anchorPoint = CGPoint(x: 0.5, y: 0)
        
        let xPosition = self.sprite.size.width / 2 + 10
        let yPosition = self.sprite.size.height * 4 / 7
        
        // This is where the messages will be displayed
        self.speechBubble = SpeechBubble(pos: CGPoint(x: xPosition, y: yPosition))
        
        self.addChild(self.sprite)
        self.addChild(self.speechBubble)
    }
    
    // Animates the character with a given mood. In Crowley's case, it can be silently as well.
    func animate(mood: GameCharacterMood, withSound : Bool) {
        
        var texture = hiTexture
        
        switch mood {
        case .happy: texture = happyTexture
        case .sad: texture = sadTexture
        default: break
        }
        
        let changeSpriteAction = SKAction.setTexture(texture)
        let changeSizeAction = SKAction.resize(toWidth: texture.size().width, height: texture.size().height, duration: 0.0)
        let changeSpriteGroupAction = SKAction.group([changeSpriteAction, changeSizeAction])
        
        
        let changeSpriteBackAction = SKAction.setTexture(standbyTexture)
        let changeSizeBackAction = SKAction.resize(toWidth: standbyTexture.size().width, height: standbyTexture.size().height, duration: 0.0)
        let changeSpriteBackGroupAction = SKAction.group([changeSpriteBackAction, changeSizeBackAction])
        
        let waitAction = SKAction.wait(forDuration: 0.8)
        
        self.sprite.run(SKAction.sequence([changeSpriteGroupAction, waitAction, changeSpriteBackGroupAction]), withKey: "transition")
        if withSound {
            let randomIndex = Int(arc4random_uniform(3))
            self.run(self.soundActions[randomIndex])
        }
    }
    
    // Displays a message in Crowley's speech bubble.
    // The 'animated' parameter tells it if the string should be an AnimatedLabel or a normal label.
    func speak(message: String, animated: Bool, withSound: Bool) {
        self.animate(mood: .pickMe, withSound: withSound)
        self.speechBubble.displayMessage(text: message, animated: animated)
    }
    
    // Hides Crowley's speech bubble
    func silence() {
        self.speechBubble.hide()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
