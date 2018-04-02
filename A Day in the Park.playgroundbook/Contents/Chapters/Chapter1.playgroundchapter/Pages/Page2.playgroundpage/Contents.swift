/*:
 *Hiiiii!* Sorry to have kept y'all waiting! So what are we playing today, guys?
 
 ![Gooey](gooeyHappy.png)
 
 Oh, I know! Let's do the **Memory Game**! This way, our new friend gets to play too!
 
 What's the **Memory Game**, you ask? It's simple!
 
 First, we shout out in a sequence. Then you try and repeat what we did by tapping on us. If you get it right, you score a point, the sequence gets longer and you go again! Otherwise, we just start over with a different sequence.
 
 We just gotta set it up first. Use the code completion to fix the logic below so we can play!
 */
//#-hidden-code
//#-code-completion(everything, hide)
//#-code-completion(identifier, show, hasPlayerCompletedSequence())
//#-code-completion(identifier, show, hasPlayerFailedSequence())
//#-code-completion(identifier, show, scorePoint())
//#-code-completion(identifier, show, incrementSequence())
//#-code-completion(identifier, show, startOver())
import PlaygroundSupport

var validIncrement : Int = 0
var validScore : Int = 0
var validRestart : Int = 0

let replaceMe = true

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
//#-end-hidden-code
public func memoryGameLogic() {
    if /*#-editable-code*/replaceMe/*#-end-editable-code*/{
        //#-editable-code Tap to write your own code!
        //#-end-editable-code
    }
    if /*#-editable-code*/replaceMe/*#-end-editable-code*/{
        //#-editable-code Tap to write your own code!
        //#-end-editable-code
    }
}
//#-hidden-code
public func initAndCheckLogic() {
    callEveryone()
    
    gameScene.gameLogic = memoryGameLogic
    gameScene.startGame(isIntro: false)
    gameScene.toggleRestart(to: false)
    
    validateGameLogic()
}

public func validateGameLogic() {
    validIncrement = 0
    validScore = 0
    validRestart = 0
    
    PlaygroundValidator.reset()
    PlaygroundValidator.isValidating = 0
    
    memoryGameLogic()
    
    PlaygroundValidator.isValidating = -1
    
    if validIncrement > 0 && validScore > 0 && validRestart > 0 {
        PlaygroundValidator.message = "Nicely done! You can play if you'd like, or [move on to the last page.](@next)"
        PlaygroundValidator.validate(hasPassed: true)
    }
    else if validIncrement <= 0 || validRestart <= 0 || validScore <= 0 {
        
        if validRestart == 0 {
            PlaygroundValidator.hints.append("We should restart the sequence if we mess up.")
        }
        if validIncrement == 0 {
            PlaygroundValidator.hints.append("We should increment the sequence if it was done correctly.")
        }
        if validScore == 0 {
            PlaygroundValidator.hints.append("We should score when the sequence is done.")
        }
        
        PlaygroundValidator.validate(hasPassed: false)
    }
    
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


