//#-hidden-code
//#-code-completion(everything, hide)
//#-code-completion(identifier, show, normal)
//#-code-completion(identifier, show, backwards)
import PlaygroundSupport

var validIncrement : Int = 0
var validScore : Int = 0
var validRestart : Int = 0

let normal:GameRuleID = .normal
let backwards:GameRuleID = .backwards
//#-end-hidden-code
/*:
 Hey, that was pretty good! I'm glad you were around to play with us!
 
 ![Frank](frankHappy.png)
 
 You can keep going if you'd like. Try to reach a really high score!
 
 Or, if you're up to a challenge, see how far you can go when you have to repeat our moves... *backwards!* If you wanna try that, just change the rules from `normal` to `backwards` below.
 */
let gameRules = /*#-editable-code*/normal/*#-end-editable-code*/
//: It was a pleasure meeting you. Come back anytime!
//#-hidden-code

public func callFriend(_ name: String) {
    
    switch name.lowercased() {
    case "barney":
        gameScene.addCharacter(.barney)
    case "hector":
        gameScene.addCharacter(.hector)
    case "gooey":
        gameScene.addCharacter(.gooey)
    case "frank":
        gameScene.addCharacter(.frank)
    default:
        break
    }
}

public func callEveryone() {
    callFriend("Barney")
    callFriend("Hector")
    callFriend("Gooey")
    callFriend("Frank")
}

public func memoryGameLogic() {
    if hasPlayerFailedSequence() {
        startOver()
    }
    if hasPlayerCompletedSequence() {
        incrementSequence()
        scorePoint()
    }
}

public func initAndCheckLogic() {
    PlaygroundValidator.isValidating = -1
    
    callEveryone()
    gameScene.gameLogic = memoryGameLogic
    gameScene.startGame(isIntro: false, ruleID: gameRules)
}

public func hasPlayerCompletedSequence() -> Bool {
    if PlaygroundValidator.isValidating >= 0 {
        PlaygroundValidator.isValidating = 1
        return true
    }
    else {
        return gameScene.hasPlayerCompletedSequence()
    }
}

public func hasPlayerFailedSequence() -> Bool {
    if PlaygroundValidator.isValidating >= 0 {
        PlaygroundValidator.isValidating = 2
        return true
    }
    else {
        return gameScene.hasPlayerFailedSequence()
    }
}

public func scorePoint() {
    // Is validation running?
    if PlaygroundValidator.isValidating != -1 {
        // Is this being called after the check for completing sequence?
        if PlaygroundValidator.isValidating == 1 {
            // Yes! User did this correctly.
            if validScore >= 0 {
                validScore += 1
            }
        }
            // If not, we must fail the assessment down the line
        else if validScore >= 0 {
            validScore -= 1000
            PlaygroundValidator.hints.append("We should score when the sequence is done.")
        }
    }
        // If not, then execute the game as normal
    else {
        gameScene.scorePoint()
    }
}

public func incrementSequence() {
    // Is validation running?
    if PlaygroundValidator.isValidating != -1 {
        // Is this being called after the check for completing sequence?
        if PlaygroundValidator.isValidating == 1 {
            // Yes! User did this correctly.
            if validIncrement >= 0 {
                validIncrement += 1
            }
        }
            // If not, we must fail the assessment down the line
        else if validIncrement >= 0 {
            validIncrement -= 1000
            PlaygroundValidator.hints.append("We should increment the sequence when the sequence was done correctly.")
        }
    }
        // If not, then execute the game as normal
    else {
        gameScene.incrementSequence()
    }
}

public func startOver() {
    // Is validation running?
    if PlaygroundValidator.isValidating != -1 {
        // Is this being called after the check for failing sequence?
        if PlaygroundValidator.isValidating == 2 {
            // Yes! User did this correctly.
            if validRestart >= 0 {
                validRestart += 1
            }
        }
            // If not, we must fail the assessment down the line
        else if validRestart >= 0 {
            validRestart -= 1000
            PlaygroundValidator.hints.append("We should restart the sequence if we mess up.")
        }
    }
        // If not, then execute the game as normal
    else {
        gameScene.toggleRestart(to: true)
    }
}

loadScene()
initAndCheckLogic()
//#-end-hidden-code


