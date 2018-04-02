// Game model. This holds all of the logic, so we can isolate the model from the views.

import Foundation
import UIKit

// Game states enumeration
public enum GameState {
    case waitingToStart
    case userTurn
    case computerTurn
    case gameOver
}

// Game rules (only normal and backwards were implemented)
public enum GameRuleID {
    case normal
    case backwards
    case custom
}

class Genius {

    // Delegate to the game controller
    weak var gameSceneDelegate : GameSceneDelegate!
    
    // These are the characters in the current game
    public var availableGameCharacters : [GameCharacterName] = [.hector, .gooey, .frank, .barney]
    
    // Game rules that will be used to check the user input.
    private var gameRules : [GameRules]!
    private var selectedRule : GameRules!
    
    // Sequence status. -1: player failed, 0: ongoing, 1: player completed succesfully
    public var sequenceStatus : Int = 0
    
    // Sequence of moves that the AI will perform, and the user will repeat.
    // It will first be transformed according to the game rules.
    private var moveSequence:[GameCharacterName] = [GameCharacterName]()
    
    // Indexes for the current move being done by the user/AI
    private var userMoveIndex : Int = 0
    private var aiMoveIndex : Int = 0
    
    // Game state
    public var gameState : GameState = .waitingToStart
    
    // Game score
    private var score:Int = 0
    
    // Handy variable to control the number of moves added between each level
    private var movesPerIncrement : Int = 1
    
    // Asynchronous timer to execute the AI moves
    private var gameTimer: BackgroundTimer!
    
    // Time between two AI moves.
    // The minimum interval between two moves is 400 milliseconds,
    // anything less than that gets kinda crazy.
    private var _timeBetweenMoves: Int = 800
    private var timeBetweenMoves: Int {
        get {
            return _timeBetweenMoves
        }
        set (newValue) {
            _timeBetweenMoves = newValue < 400 ? 400 : newValue
        }
    }
    
    // How fast the game speeds up.
    // p = 1.0 means the speed does not change
    // p < 1.0 means the speed will increase (as the interval between moves gets smaller)
    // p > 1.0 means the speed will decrease (as the interval between moves gets larger)
    private var speedUpPercentage : Double = 0.95
    
    // Flag to determine if the game should restart correctly (this is for the penultimate playground page)
    public var restarts : Bool = true
    
    // Initializes the game using the given rule ID
    init(delegate: GameSceneDelegate, ruleID: GameRuleID = .normal) {
        self.gameSceneDelegate = delegate
        
        let normalRules = GameRules(ruleName: "Normal",
                                    ruleInstructions: "Repeat!",
                                    gameRules: { inputArray in
                                        return inputArray
        })
        
        let backwardsRules = GameRules(ruleName: "Backwards",
                                       ruleInstructions: "Repeat backwards!",
                                       gameRules: { inputArray in
                                        return inputArray.reversed()
        })
    
        self.gameRules = [normalRules, backwardsRules]
        switch ruleID {
            case .backwards:
                self.selectedRule = backwardsRules
            default:
                self.selectedRule = normalRules
        }
        
        self.moveSequence = []
        incrementSequence(by: 3)
        self.score = 0
    }
    
    // Game actually starts. Initializes the timer and sets the game state
    public func startMoves() {
        self.gameState = .computerTurn
        self.gameSceneDelegate.displayInstruction(message: "Watch carefully!", animated: false, withSound: true)
        
        initTimer()
    }
    
    // Restarts the game into the initial configuration (everything on zero, at least if the 'restarts' flag is on, otherwise the score and the sequence are not reset)
    public func restartGame(isIntro: Bool) {
        
        // Sets the game state into standby mode
        self.gameState = .waitingToStart
        
        // The rest does not happen in introduction mode
        if !isIntro {
            self.userMoveIndex = 0
            self.aiMoveIndex = 0
            self.movesPerIncrement = 1
            self.timeBetweenMoves = 800
            
            // Resets the sequence and the score, if allowed
            if self.restarts {
                self.moveSequence = []
                incrementSequence(by: 3)
                self.score = 0
            }
            
            self.gameSceneDelegate.displayInstruction(message: "Tap to begin!",  animated: true, withSound: true)
            self.gameSceneDelegate.displayScore(score: score)
        }
    }
    
    // Initialize and configure the timer
    private func initTimer() {
        self.gameTimer = nil
        self.gameTimer = BackgroundTimer(intervalInMilliseconds: timeBetweenMoves) { [weak self] in
            self?.timerHandler()
        }
        self.gameTimer.start()
    }
    
    // Actions to run on every timer trigger. That means, telling the game scene to update accordingly
    @objc func timerHandler() {
        
        // If the sequence is done, we pass the ball to the user
        if self.aiMoveIndex >= self.moveSequence.count {
            self.gameState = .userTurn
            
            // Do UI updates in the main thread
            DispatchQueue.main.async { [weak self] in
                if let instructions = self?.selectedRule.ruleInstructions {
                    self?.gameSceneDelegate.displayInstruction(message: instructions, animated: false, withSound: false)
                }
            }
            
            self.gameTimer.stop()
            return
        }
        
        // Update UI in the main thread, using a copy of the element index to dodge asynchronous writes
        let characterToMove = self.moveSequence[self.aiMoveIndex]
        DispatchQueue.main.async { [weak self] in
            self?.gameSceneDelegate.animate(characterName: characterToMove, with: .pickMe)
        }
        
        // Update the AI move index
        self.aiMoveIndex += 1
    }
    
    // Increments the movement sequence by the given number of moves
    public func incrementSequence(by numberOfNewMoves:Int) {
        
        for _ in 0 ..< numberOfNewMoves {
            self.moveSequence.append(randomElement(availableGameCharacters))
        }
    }
    
    // Increments the score by the given number of points
    public func incrementScore(by points:Int) {
        self.score += points
    }
    
    // Applies the given rules to a movement array, and returns a new transformed array
    private func applyRules(_ rules: Rule, to sequence: [GameCharacterName]) -> [GameCharacterName] {
        return rules(sequence)
    }
    
    // Checks if the user move was correct.
    func check(move: GameCharacterName) -> Bool {
        
        // Apply the game rules
        let moveSequenceByRules = self.applyRules(self.selectedRule.gameRules, to: self.moveSequence)
        
        let index = self.userMoveIndex
        if moveSequenceByRules[index] != move {
            // User did wrong move
            self.gameState = .gameOver
            self.sequenceStatus = -1
            self.gameSceneDelegate.gameOver(completion: { [weak self] in
                self?.gameOver()
            })
            return false
        }
        
        // User did correct move
        self.userMoveIndex += 1
        
        // If the user won this level, increment sequence and start count again
        if self.userMoveIndex == moveSequenceByRules.count {
            self.sequenceStatus = 1
            self.gameState = .computerTurn
            self.gameSceneDelegate.congratulations(completion: { [weak self] in
                self?.nextLevel()
            })
            
        }
        return true
    }
    
    // User completed the sequence successfully, now update game state and internal variables accordingly
    public func nextLevel() {
        self.gameState = .computerTurn
        self.sequenceStatus = 0
        self.aiMoveIndex = 0
        self.userMoveIndex = 0
        self.timeBetweenMoves = Int(Double(self.timeBetweenMoves) * self.speedUpPercentage)
        self.gameSceneDelegate.displayScore(score: score)
        self.gameSceneDelegate.displayInstruction(message: "Watch carefully!", animated: false, withSound: true)
        self.initTimer()
    }
    
    // User missed the sequence
    public func gameOver() {
        self.restartGame(isIntro: false)
    }
}

