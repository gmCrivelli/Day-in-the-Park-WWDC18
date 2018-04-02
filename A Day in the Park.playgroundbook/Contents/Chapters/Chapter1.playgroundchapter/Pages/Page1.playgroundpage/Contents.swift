/*:
 It seems like I'm early again... But that's okay, the others should be here any time now.
 
 Oh, *hey there!* You're new around here, aren't you? Come on, no reason to be shy. I'm **Barney**, pleased to meet ya!
 
 ![Barney](barneyHappy.png)
 
 I was just waiting for a few friends, **Hector, Gooey** and **Frank**. We usually meet to play around here, but they are always late! Why don't you help me call them?
 
 Here's how to call someone:
 
     callFriend("Barney")
 
 This is me! To call the others, just add the rest of the lines below, using their names instead of mine. Then tap "Run My Code" when you're done!
 */
//#-hidden-code
//#-code-completion(everything, hide)
//#-code-completion(identifier, show, callFriend(_:))
//#-code-completion(literal, show, string)
import PlaygroundSupport

public var barneyIsHere:Bool = false
public var frankIsHere :Bool = false
public var gooeyIsHere :Bool = false
public var hectorIsHere:Bool = false

public func callFriend(_ name: String) {
    
    switch name.lowercased() {
    case "barney":
        gameScene.addCharacter(.barney)
        barneyIsHere = true
    case "hector":
        gameScene.addCharacter(.hector)
        hectorIsHere = true
    case "gooey":
        gameScene.addCharacter(.gooey)
        gooeyIsHere = true
    case "frank":
        gameScene.addCharacter(.frank)
        frankIsHere = true
    default:
        break
    }
}
//#-end-hidden-code

public func callEveryone() {
    callFriend("Barney")
    //#-editable-code Tap to write your own code!
    
    
    
    //#-end-editable-code
}


//#-hidden-code
public func initAndCheckCharacters() {
    callEveryone()
    validateCharacters()
    gameScene.startGame(isIntro: true)
}

public func validateCharacters() {
    PlaygroundValidator.reset()
    
    if gameScene.gameCharacterCount != 4 {
        
        if !frankIsHere {
            PlaygroundValidator.hints.append("**Frank** is still not here. Try calling them!")
        }
        else if !gooeyIsHere {
            PlaygroundValidator.hints.append("**Gooey** is still not here. Try calling them!")
        }
        else if !hectorIsHere {
            PlaygroundValidator.hints.append("**Hector** is still not here. Try calling them!")
        }
        else {
            // This one shouldn't happen though
            PlaygroundValidator.hints.append("**Barney** is still not here. Try calling them!")
        }
        PlaygroundValidator.validate(hasPassed: false)
    }
    else {
        PlaygroundValidator.message = "**Well done!** Everyone is here, now [let's play!](@next)"
        PlaygroundValidator.validate(hasPassed: true)
    }
}

loadScene()
initAndCheckCharacters()
//#-end-hidden-code
