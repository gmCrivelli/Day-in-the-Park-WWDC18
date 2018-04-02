// Animated label in which each letter moves vertically in a sinusoidal fashion.
// Built on SpriteKit as a node composed of several child SKLabelNodes.
// Note that this can hold a maximum of 20 characters!

import Foundation
import SpriteKit

class AnimatedLabel : SKNode {
    
    // Each letter is a separate SKLabelNode
    private var letterArray : [SKLabelNode]!
    
    // This array keeps the kerning information so we can properly space the letters
    // These are the spaces needed for font size 40.
    // For other sizes, divide by 40 and multiply by the desired font size.
    private let letterWidth:[Character:CGFloat] = ["A":26,"B":25,"C":24,"D":25,"E":24,"F":21,"O":23,"R":22, "T":15, "W":24,
                                                   "a":18, "c":17, "d":17, "e":15, "f":14, "g": 16, "h":16, "i": 12, "k": 19,
                                                   "l": 8, "o":20, "p":17, "r":14, "s":16, "t":14, "u":15, "w": 20, "y":17,
                                                   ".":8, " ": 11]
    // The font size
    public var fontSize : CGFloat = 30.0
    
    // The label center, for horizontal alignment
    public var center : CGPoint!
    
    // Total label width
    public var width : CGFloat = 0
    
    init(center : CGPoint, fontSize: CGFloat) {
        super.init()
        
        self.center = center
        self.letterArray = [SKLabelNode]()
        self.fontSize = fontSize
        
        // The letters rise and fall with the following amplitude and period as parameters
        let amplitude : Double = 5.0
        let period : CGFloat = 2.0
        
        // Configures and starts the movement for each of the 20 letters
        for i in 0 ..< 20 {
            let label = SKLabelNode(fontNamed: "Noteworthy-Light")
            label.fontSize = self.fontSize
            label.fontColor = #colorLiteral(red: 0.207816124, green: 0.2078586519, blue: 0.2078134418, alpha: 1)
            label.position = self.center
            letterArray.append(label)
            self.addChild(label)
        
            let originalYPosition = self.center.y
            let phase = -0.2 * Double.pi * Double(i) / Double(period)
            let customMoveAction = SKAction.customAction(withDuration: TimeInterval(period)) { (node, elapsedTime) in
                let percentage:Double = Double(elapsedTime / period)
                node.position = CGPoint(x: node.position.x, y: originalYPosition + CGFloat(sin(2 * Double.pi * percentage + phase) * amplitude))
            }
            label.run(SKAction.repeatForever(customMoveAction))
        }
    }
    
    // Given a string parameter (of up to 20 characters), displays that text using the already moving SKLabelNodes
    public func displayText(_ text: String) {
        
        var i = 0
        self.width = 0.0
        
        let scaleFactor:CGFloat = self.fontSize / 40.0
        
        for c in text {
            letterArray[i].text = "\(c)"
            letterArray[i].position = CGPoint(x: self.center.x + self.width, y: letterArray[i].position.y)
            self.width += (letterWidth[c] ?? 17) * scaleFactor
            i += 1
        }
        
        while i < 20 {
            letterArray[i].text = ""
            i += 1
        }
        
        self.position = CGPoint(x: -self.width / 2, y: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
