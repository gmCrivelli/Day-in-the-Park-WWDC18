// Class for playground validation. Allows for easy integration with the playground book
// by isolating the iPad specific methods, so this can run on Xcode as well

import PlaygroundSupport

public class PlaygroundValidator {
    
    public static var isValidating:Int = 0
    
    public static var hints:[String] = []
    public static var message: String? = nil
    public static var solution:String? = nil
    
    public static func validate(hasPassed:Bool) {
        if hasPassed {
//            print("ok!")
//            print(message ?? "")
            PlaygroundPage.current.assessmentStatus = .pass(message: message)
        }
        else {
//            print("failed!")
//            print(hints)
//            print(solution ?? "")
            PlaygroundPage.current.assessmentStatus = .fail(hints: hints, solution: solution)
        }
    }
    
    public static func reset() {
        PlaygroundValidator.hints = []
        PlaygroundValidator.message = nil
        PlaygroundValidator.solution = nil
    }
}
