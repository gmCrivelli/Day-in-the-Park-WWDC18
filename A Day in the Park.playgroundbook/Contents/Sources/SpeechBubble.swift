// Speech bubble for Crowley, with the option to have animated or static text.

import Foundation
import SpriteKit

class SpeechBubble : SKSpriteNode {
    
    // References to both types of label, animated and static
    private var animatedLabel : AnimatedLabel!
    private var label : SKLabelNode!
    
    // Default font size is 30.0
    init(pos: CGPoint, fontSize: CGFloat = 30.0) {
        
        // Initializes the sprite node
        let texture = SKTexture(imageNamed: "speechBubble")
        super.init(texture: texture, color: .clear, size: texture.size())
    
        self.position = pos
        self.anchorPoint = CGPoint(x: 0, y: 0)
        
        // Configures the static label
        self.label = SKLabelNode(fontNamed: "Noteworthy-Light")
        self.label.fontSize = fontSize
        self.label.fontColor = #colorLiteral(red: 0.207816124, green: 0.2078586519, blue: 0.2078134418, alpha: 1)
        self.label.horizontalAlignmentMode = .center
        self.label.position = CGPoint(x: self.size.width / 2 + self.size.width * 0.05, y: self.size.height * 4.3 / 10 )
        self.label.isHidden = true
        self.addChild(label)
        
        // Configures the animated label
        self.animatedLabel = AnimatedLabel(center: CGPoint(x: self.size.width / 2 + self.size.width * 0.07, y: self.size.height * 4.3 / 10 ), fontSize: fontSize)
        self.animatedLabel.isHidden = true
        self.addChild(animatedLabel)
    }
    
    // Displays the given text, using either the animated label or the static label
    func displayMessage(text: String, animated: Bool) {
        self.isHidden = false
        if animated {
            self.animatedLabel.displayText(text)
            self.animatedLabel.isHidden = false
            self.label.isHidden = true
        }
        else {
            self.label.text = text
            self.label.isHidden = false
            self.animatedLabel.isHidden = true
        }
    }
    
    // Hides everything
    func hide() {
        self.isHidden = true
        self.animatedLabel.isHidden = true
        self.label.isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
