//
//  Float+Normal.swift
//  Example
//
//  Created by 诸葛游 on 2018/9/4.
//  Copyright © 2018年 品驰医疗. All rights reserved.
//

import Foundation

// MARK: - Properties
public extension FloatingPoint {
    
    /// Absolute value of integer number.
    var abs: Self {
        return Swift.abs(self)
    }
    
    /// Check if integer is positive.
    var isPositive: Bool {
        return self > 0
    }
    
    /// Check if integer is negative.
    var isNegative: Bool {
        return self < 0
    }
    
    /// Ceil of number.
    var ceil: Self {
        return Foundation.ceil(self)
    }
    
    /// Radian value of degree input.
    var degreesToRadians: Self {
        return Self.pi * self / Self(180)
    }
    
    /// Floor of number.
    var floor: Self {
        return Foundation.floor(self)
    }
    
    /// Degree value of radian input.
    var radiansToDegrees: Self {
        return self * Self(180) / Self.pi
    }
    
}

// MARK: - Methods
public extension FloatingPoint {
    
    /// Random number between two number.
    ///
    /// - Parameters:
    ///   - min: minimum number to start random from.
    ///   - max: maximum number random number end before.
    /// - Returns: random number between two numbers.
    static func random(between min: Self, and max: Self) -> Self {
        let aMin = Self.minimum(min, max)
        let aMax = Self.maximum(min, max)
        let delta = aMax - aMin
        return Self(arc4random()) / Self(UInt64(UINT32_MAX)) * delta + aMin
    }
    
    /// Random number in a closed interval range.
    ///
    /// - Parameter range: closed interval range.
    /// - Returns: random number in the given closed range.
    static func random(inRange range: ClosedRange<Self>) -> Self {
        let delta = range.upperBound - range.lowerBound
        return Self(arc4random()) / Self(UInt64(UINT32_MAX)) * delta + range.lowerBound
    }
    
}

// MARK: - Initializers
public extension FloatingPoint {
    
    /// Created a random number between two numbers.
    ///
    /// - Parameters:
    ///   - min: minimum number to start random from.
    ///   - max: maximum number random number end before.
    init(randomBetween min: Self, and max: Self) {
        let aMin = Self.minimum(min, max)
        let aMax = Self.maximum(min, max)
        let delta = aMax - aMin
        self = Self(arc4random()) / Self(UInt64(UINT32_MAX)) * delta + aMin
    }
    
    /// Create a random number in a closed interval range.
    ///
    /// - Parameter range: closed interval range.
    init(randomInRange range: ClosedRange<Self>) {
        let delta = range.upperBound - range.lowerBound
        self = Self(arc4random()) / Self(UInt64(UINT32_MAX)) * delta + range.lowerBound
    }
    
}


// MARK: - Operators

precedencegroup PowerPrecedence { higherThan: MultiplicationPrecedence }
infix operator ** : PowerPrecedence
/// Value of exponentiation.
///
/// - Parameters:
///   - lhs: base float.
///   - rhs: exponent float.
/// - Returns: exponentiation result (4.4 ** 0.5 = 2.0976176963).
public func ** (lhs: Float, rhs: Float) -> Float {
    // http://nshipster.com/swift-operators/
    return pow(lhs, rhs)
}

// swiftlint:disable next identifier_name
prefix operator √
/// Square root of float.
///
/// - Parameter float: float value to find square root for
/// - Returns: square root of given float.
public prefix func √ (float: Float) -> Float {
    // http://nshipster.com/swift-operators/
    return sqrt(float)
}

// swiftlint:disable next identifier_name
infix operator ±
/// Tuple of plus-minus operation.
///
/// - Parameters:
///   - lhs: number
///   - rhs: number
/// - Returns: tuple of plus-minus operation ( 2.5 ± 1.5 -> (4, 1)).
public func ±<T: FloatingPoint> (lhs: T, rhs: T) -> (T, T) {
    // http://nshipster.com/swift-operators/
    return (lhs + rhs, lhs - rhs)
}

// swiftlint:disable next identifier_name
prefix operator ±
/// Tuple of plus-minus operation.
///
/// - Parameter int: number
/// - Returns: tuple of plus-minus operation (± 2.5 -> (2.5, -2.5)).
public prefix func ±<T: FloatingPoint> (number: T) -> (T, T) {
    // http://nshipster.com/swift-operators/
    return 0 ± number
}
