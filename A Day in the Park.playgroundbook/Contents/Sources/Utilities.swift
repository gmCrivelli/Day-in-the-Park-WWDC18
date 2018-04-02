// Convenience functions for quality of life!

import CoreGraphics
import SpriteKit

/// Convenience functions for CGPoint operations!

// Sum of two CGPoints
public func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

// Difference between two CGPoints
public func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

// Multiply a CGPoint by a scalar (CGFloat)
public func * (left: CGPoint, right: CGFloat) -> CGPoint {
    return CGPoint(x: left.x * right, y: left.y * right)
}

// Divide a CGPoint by a scalar (CGFloat)
public func / (left: CGPoint, right: CGFloat) -> CGPoint {
    return CGPoint(x: left.x / right, y: left.y / right)
}


/// Convenience function for arrays!
public func randomElement<T>(_ array: [T]) -> T {
    let randomIndex = Int(arc4random_uniform(UInt32(array.count)))
    return array[randomIndex]
}
