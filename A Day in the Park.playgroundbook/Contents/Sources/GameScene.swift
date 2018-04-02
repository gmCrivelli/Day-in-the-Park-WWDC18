// Methods for the GameScene. Bridges the user interaction and the game model, as well as controls the nodes displayed.

import SpriteKit
import GameplayKit

// Delegate for other classes to comunicate with the game scene
protocol GameSceneDelegate : class {
    func animate(characterName: GameCharacterName, with mood: GameCharacterMood)
    func displayScore(score: Int)
    func displayInstruction(message: String, animated: Bool, withSound: Bool)
    func congratulations(completion: @escaping () -> Void)
    func gameOver(completion: @escaping () -> Void)
}

// GameScene
public class GameScene: SKScene {
    
    // This holds the game variables
    private var geniusGame : Genius!
    
    // This is the game logic. Called every time the player does a move, very important!
    public var gameLogic : (() -> Void)?
    
    // This manages the references to game characters and their methods
    var gameCharacterManager:GameCharacterManager = GameCharacterManager()
    
    // These are the characters currently in the game
    private var availableGameCharacters = [GameCharacterName]()
    public var gameCharacterCount : Int {
        get {
            return availableGameCharacters.count
        }
    }
    
    // Keep a reference to the game arbiter, Crowley
    var crowley : Crowley!
    
    // This controls the clouds
    private var cloudSpawner : CloudSpawner!
    
    // Flag to know if this is just an introduction
    private var isIntro:Bool = false
    
    // References to the score labels
    public var scoreTitleLabel:SKLabelNode!
    public var scoreValueLabel:SKLabelNode!
    
    // Overriding the default implementation to treat touches
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            self.touchDown(atPoint: t.location(in: self))
        }
    }
    
    // Checks if there is anything to do when the user taps the scene
    func touchDown(atPoint pos : CGPoint) {
        let nodes = self.nodes(at: pos)
        if nodes.count > 0 {
            
            // If we are in intro mode, there is no game, so we just animate any characters the user taps
            if isIntro {
                if nodes[0].name == "gcharacter" {
                    let character = nodes[0].parent as! GameCharacter
                    character.animate(mood: .happy)
                }
                else if nodes[0].name == "crowley" {
                    let character = nodes[0].parent as! Crowley
                    character.animate(mood: .pickMe, withSound: true)
                }
            }
                
            // Otherwise, we check the game state and proceed accordingly
            else {
                switch self.geniusGame.gameState {
                case .waitingToStart:
                    self.geniusGame.startMoves()
                case .userTurn:
                    if nodes[0].name == "gcharacter" {
                        let character = nodes[0].parent as! GameCharacter
                        if self.geniusGame.check(move: character.characterName) {
                            character.animate(mood: .pickMe)
                        }
                        else {
                            character.animate(mood: .sad)
                        }
                        
                        // In the playground, this will be defined by the user.
                        self.gameLogic?()
                    }
                default:
                    break
                }
            }
        }
    }
    
    // Adds a single character to the scene. In practice, this fills out a GameCharacterName array, which is later used to instantiate the characters. See GameCharacterManager for more info.
    public func addCharacter(_ name: GameCharacterName) {
        if !self.availableGameCharacters.contains(name) {
            self.availableGameCharacters.append(name)
        }
    }
    
    // Starts the scene. Parameters allow you to choose if it starts in introduction mode or not, and the active game rule
    public func startGame(isIntro:Bool = false, ruleID: GameRuleID = .normal) {
        
        self.scoreTitleLabel = childNode(withName: "ScoreTitleLabel") as! SKLabelNode
        self.scoreValueLabel = childNode(withName: "ScoreValueLabel") as! SKLabelNode
        
        self.isIntro = isIntro
        self.scoreTitleLabel?.isHidden = isIntro
        self.scoreValueLabel?.isHidden = isIntro
        self.scoreValueLabel?.text = "0"
        
        // Init characters
        self.gameCharacterManager.createCharacters(self.availableGameCharacters)
        for (_, character) in gameCharacterManager.gameCharacterDict {
            self.addChild(character)
            character.runStandbyActions()
        }
        
        // Init crowley
        self.crowley = Crowley(pos: CGPoint(x: -175, y: 26))
        self.addChild(self.crowley!)
        
        // Init clouds
        self.cloudSpawner = CloudSpawner(pos: CGPoint(x: 600, y: 220))
        self.addChild(self.cloudSpawner)
        
        // Init game
        self.geniusGame = Genius(delegate: self, ruleID: ruleID)
        self.geniusGame.availableGameCharacters = self.availableGameCharacters
        self.geniusGame.restartGame(isIntro: isIntro)
        
        if isIntro {
            self.crowley.silence()
            self.gameCharacterManager.animateAll(with: .happy)
        }
    }
    
    /// MARK: user methods to bridge the user coding from Page 2
    public func hasPlayerCompletedSequence() -> Bool {
        return self.geniusGame.sequenceStatus == 1
    }
    
    public func hasPlayerFailedSequence() -> Bool {
        return self.geniusGame.sequenceStatus == -1
    }
    
    public func incrementSequence() {
        self.geniusGame.incrementSequence(by: 1)
    }
    
    public func scorePoint() {
        self.geniusGame.incrementScore(by: 1)
    }
    
    public func toggleRestart(to value: Bool) {
        self.geniusGame.restarts = value
    }
}

// Implementation of the GameSceneDelegate protocol
extension GameScene : GameSceneDelegate {
    
    // Animates a single GameCharacter
    func animate(characterName: GameCharacterName, with mood: GameCharacterMood) {
        self.gameCharacterManager.animate(characterName: characterName, with: mood)
    }
    
    // Displays the current game score
    func displayScore(score: Int) {
        self.scoreValueLabel?.text = "\(score)"
    }
    
    // Tells Crowley to say something. Can be animated or not, with sound or not.
    func displayInstruction(message: String, animated: Bool, withSound: Bool) {
        self.crowley.speak(message: message, animated: animated, withSound: withSound)
    }
    
    // You win! Animates all characters with a happy mood, and displays a nice message :)
    // It also waits a bit before running the given completion code block
    func congratulations(completion: @escaping () -> Void) {
        
        let waitAction = SKAction.wait(forDuration: 0.7)
        let reactionAction = SKAction.run{ [weak self] in
            self?.crowley.speak(message: "Well done!", animated: true, withSound: false)
            self?.gameCharacterManager.animateAll(with: .happy)
        }
        
        self.run(SKAction.sequence([waitAction, reactionAction, waitAction, waitAction]), completion: completion)
    }
    
    // You lose... Animates all characters with a sad mood, and displays a message to tell the user they messed up :(
    // It also waits a bit before running the given completion code block
    func gameOver(completion: @escaping () -> Void) {
        
        let waitAction = SKAction.wait(forDuration: 0.7)
        let reactionAction = SKAction.run { [weak self] in
            self?.crowley.speak(message: "Whoops...", animated: false, withSound: false)
            self?.gameCharacterManager.animateAll(with: .sad)
        }
        
        self.run(SKAction.sequence([reactionAction, waitAction, waitAction]), completion: completion)
    }
}

