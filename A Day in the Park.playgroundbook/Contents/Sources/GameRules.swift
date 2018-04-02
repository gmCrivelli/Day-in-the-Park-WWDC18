// Struct for configuring and executing different and possibly complex game rules
// Originally I had thought of allowing the user to program one rule.
// This was later simplified to only have one 'normal' rule and one 'backwards' rule, interchangeable by one single line in the final Playground page. Sometimes less is more!

import Foundation

typealias Rule = ([GameCharacterName]) -> [GameCharacterName]

struct GameRules {
    var ruleName : String
    var ruleInstructions : String
    var gameRules : Rule
}
