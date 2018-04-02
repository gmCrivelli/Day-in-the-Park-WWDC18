//
//  GameCharacter.swift
//  TestActions
//
//  Created by Gustavo De Mello Crivelli on 21/03/18.
//  Copyright © 2018 Gustavo De Mello Crivelli. All rights reserved.
//

import Foundation
import SpriteKit

public enum GameCharacterName {
    case barney
    case gooey
    case frank
    case hector
}

public enum GameCharacterMood {
    //case standby
    case happy
    case sad
    case pickMe
}

/// Base class for the game characters, this should hold everything a character will need.
/// Inheriting classes will be able to override the methods and specify the SKActions to be played.
class GameCharacter : SKNode {
    
    // Child nodes
    var sprite: SKSpriteNode!
    var shadow: SKSpriteNode!
    
    // Character identification
    var characterName: GameCharacterName!
    
    // Initial position, this will keep the movement SKActions stable
    var initialPos : CGPoint!
    
    // Store this character's textures, so they can be reused
    private var happyTexture : SKTexture
    private var standbyTexture : SKTexture
    private var sadTexture : SKTexture
    private var meTexture : SKTexture
    
    // Sounds should be loaded once per character only, let's store their actions
    private var hiSoundAction : SKAction
    private var meSoundAction : SKAction
    private var awSoundAction : SKAction
    
    init(characterName: GameCharacterName) {
        
        let characterString = String(describing: characterName)
        
        // Initialize this character's textures
        self.happyTexture = SKTexture(imageNamed: characterString + "Happy.png")
        self.standbyTexture = SKTexture(imageNamed: characterString + "Standby.png")
        self.sadTexture = SKTexture(imageNamed: characterString + "Sad.png")
        self.meTexture = SKTexture(imageNamed: characterString + "Me.png")
        
        // Initialize the character's sounds
        self.hiSoundAction = SKAction.playSoundFileNamed(characterString + "HiSound.mp3", waitForCompletion: false)
        self.meSoundAction = SKAction.playSoundFileNamed(characterString + "MeSound.mp3", waitForCompletion: false)
        self.awSoundAction = SKAction.playSoundFileNamed(characterString + "AwSound.mp3", waitForCompletion: false)
        
        super.init()
        
        self.zPosition = 5
        
        self.sprite = SKSpriteNode(texture: standbyTexture)
        self.sprite.name = "gcharacter"
        self.sprite.anchorPoint = CGPoint(x: 0.5, y: 0)
        
        self.shadow = SKSpriteNode(imageNamed: "shadow.png")
        self.shadow.zPosition = -0.1
        
        self.addChild(self.sprite)
        self.addChild(self.shadow)
        
        self.characterName = characterName
        
        // Init bg music
        let bgMusicNode = SKAudioNode(fileNamed: characterString + "Song.mp3")
        self.addChild(bgMusicNode)
        bgMusicNode.isPositional = false
        bgMusicNode.run(SKAction.changeVolume(to: 0.3, duration: 0.0))
        bgMusicNode.run(SKAction.play())
    }
    
    // Animates the character for a given mood.
    func animate(mood: GameCharacterMood) {
        
        var texture = meTexture
        var soundAction = meSoundAction
        
        switch mood {
        case .happy: texture = happyTexture
            soundAction = hiSoundAction
        case .sad: texture = sadTexture
            soundAction = awSoundAction
        default: break
        }
        
        let changeSpriteAction = SKAction.setTexture(texture)
        let changeSizeAction = SKAction.resize(toWidth: texture.size().width, height: texture.size().height, duration: 0.0)
        let changeSpriteGroupAction = SKAction.group([changeSpriteAction, changeSizeAction])
        
        
        let changeSpriteBackAction = SKAction.setTexture(standbyTexture)
        let changeSizeBackAction = SKAction.resize(toWidth: standbyTexture.size().width, height: standbyTexture.size().height, duration: 0.0)
        let changeSpriteBackGroupAction = SKAction.group([changeSpriteBackAction, changeSizeBackAction])
        
        let waitDuration = mood == .pickMe ? 0.5 : 0.85
        
        let waitAction = SKAction.wait(forDuration: waitDuration)
        
        self.sprite.run(SKAction.sequence([changeSpriteGroupAction, waitAction, changeSpriteBackGroupAction]), withKey: "transition")
        self.run(soundAction)
    }
    
    // This should be overriden by the child classes
    func runStandbyActions() {
        fatalError("GameCharacter.runStandbyActions() must be overridden")
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
