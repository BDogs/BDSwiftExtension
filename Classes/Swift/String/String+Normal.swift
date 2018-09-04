//
//  String+Normal.swift
//  Example
//
//  Created by 诸葛游 on 2018/5/31.
//  Copyright © 2018年 品驰医疗. All rights reserved.
//

import Foundation
import UIKit

extension String {
    /// 要不要去掉空白字符呢
    public var int: Int? {
        return Int(self)
    }
    
    /// eg: "12" "12.34" "-0xFF" ".23e99"
    public var  number: NSNumber? {
        let temp = stringByRemovedWhitespacesAndNewlines()
        guard !temp.isEmpty else {
            return nil
        }
        var sign = 0
        if temp.hasPrefix("0x") {
            sign = 1
        } else if temp.hasPrefix("-0x") {
            sign = -1
        }
        
        if sign != 0 {
            // hex number
            let scan = Scanner(string: temp)
            let result = UnsafeMutablePointer<Double>.allocate(capacity: 8)
            let suc = scan.scanHexDouble(result)
            if suc {
                return NSNumber(value: result.pointee)
            } else { return nil }
        } else {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            return formatter.number(from: temp)
        }
    }
    
    public var intValueWithoutWhitespacesAndNewlines: Int? {
        let temp = self.stringByRemovedWhitespacesAndNewlines()
        return Int(temp)
    }
    
    /// Float value from string (if applicable).
    ///
    /// - Parameter locale: Locale (default is Locale.current)
    /// - Returns: Optional Float value from given string.
    public func float(locale: Locale = .current) -> Float? {
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.allowsFloats = true
        return formatter.number(from: self)?.floatValue
    }

    /// Double value from string (if applicable).
    ///
    /// - Parameter locale: Locale (default is Locale.current)
    /// - Returns: Optional Double value from given string.
    public func double(locale: Locale = .current) -> Double? {
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.allowsFloats = true
        return formatter.number(from: self)?.doubleValue
    }
    
    /// CGFloat value from string (if applicable).
    ///
    /// - Parameter locale: Locale (default is Locale.current)
    /// - Returns: Optional CGFloat value from given string.
    public func cgFloat(locale: Locale = .current) -> CGFloat? {
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.allowsFloats = true
        return formatter.number(from: self) as? CGFloat
    }
    
    /// NSString from a string.
    public var nsString: NSString {
        return NSString(string: self)
    }
    
    /// 去掉首尾空白字符
    public var trimed: String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    /// eg："1".bool -> true
    ///     "False".bool -> false
    ///     "Hello".bool -> nil
    public var bool: Bool? {
        // 去掉收尾空白字符 转小写
        let lowercased = trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if lowercased == "true" || lowercased == "1" {
            return true
        } else if lowercased == "false" || lowercased == "0" {
            return false
        }
        return nil
    }
    
    /// Create a new random string of given length.
    ///
    ///        String(randomOfLength: 10) -> "gY8r3MHvlQ"
    ///
    /// - Parameter length: number of characters in string.
    public init(randomOfLength length: Int) {
        guard length > 0 else {
            self.init()
            return
        }
        
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString = ""
        for _ in 1...length {
            let randomIndex = arc4random_uniform(UInt32(base.count))
            guard let randomCharacter = base[Int(randomIndex)] else { continue }
            randomString.append(randomCharacter)
        }
        self.init(randomString)
    }
    
    public var url: URL? {
        return URL(string: self)
    }
    
    public var fileUrl: URL {
        return URL(fileURLWithPath: self)
    }
        
    // MARK: - transform
    /// 字符串倒序
    public func reverseString() -> String {
        return String(reversed())
    }
    
    /// 获取两个字符串公共的后缀
    ///
    /// - Parameters:
    ///   - aString:
    ///   - options:
    /// - Returns: 如果有公共后缀则返回 如果没有返回空字符串
    public func commonSuffix(with aString: String, options: String.CompareOptions = []) -> String {
        let reversedSuffix = reverseString().commonPrefix(with: aString.reverseString(), options: options)
        
        return reversedSuffix.reverseString()
    }

    /// 去掉字符串中空格
    /// eg：" 2 123 \n" -> "2123"
    public func stringByRemovedWhitespacesAndNewlines() -> String {
        var temp = self.components(separatedBy: .whitespacesAndNewlines)
        temp = temp.filter { $0 != "" }
        return temp.joined()
    }
    
    /// 字符串限制长度，多余截掉
    ///
    /// - Parameter limit: 长度
    /// - Returns:
    public func stringByLimited(limit: Int) -> String {
        guard count < limit else {
            return self
        }
        return String(self[startIndex..<index(startIndex, offsetBy: limit)])
    }
    
    /// Count of words in a string.
    ///
    /// eg: "Swift is amazing".wordsCount() -> 3
    ///
    /// - Returns: The count of words contained in a string.
    public func wordCount() -> Int {
        let chararacterSet = CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters)
        let comps = components(separatedBy: chararacterSet)
        let words = comps.filter { !$0.isEmpty }
        return words.count
    }
    
    /// Safely subscript string with index.
    ///
    /// eg: "Hello World!"[3] -> "l"
    /// eg: "Hello World!"[20] -> nil
    ///
    /// - Parameter i: index.
    public subscript(i: Int) -> String? {
        get {
            guard i >= 0 && i < count else { return nil }
            return String(self[index(startIndex, offsetBy: i)])
        }
    }

    /// SwifterSwift: Safely subscript string within a half-open range.
    ///
    /// eg: "Hello World!"[6..<11] -> "World"
    /// eg: "Hello World!"[21..<110] -> nil
    ///
    /// - Parameter range: Half-open range.
    public subscript(range: CountableRange<Int>) -> String? {
    
        guard let lowerIndex = index(startIndex, offsetBy: max(0, range.lowerBound), limitedBy: endIndex) else { return nil }
        guard let upperIndex = index(lowerIndex, offsetBy: range.upperBound - range.lowerBound, limitedBy: endIndex) else { return nil }
        return String(self[lowerIndex..<upperIndex])
    }
    
    /// SwifterSwift: Safely subscript string within a closed range.
    ///
    ///        "Hello World!"[6...11] -> "World!"
    ///        "Hello World!"[21...110] -> nil
    ///
    /// - Parameter range: Closed range.
    public subscript(range: ClosedRange<Int>) -> String? {
        
        guard let lowerIndex = index(startIndex, offsetBy: max(0, range.lowerBound), limitedBy: endIndex) else { return nil }
        guard let upperIndex = index(lowerIndex, offsetBy: range.upperBound - range.lowerBound + 1, limitedBy: endIndex) else { return nil }
        
        return String(self[lowerIndex..<upperIndex])
    }
    
    /// Date object from string of date format.
    ///
    ///        "2017-01-15".date(withFormat: "yyyy-MM-dd") -> Date set to Jan 15, 2017
    ///        "not date string".date(withFormat: "yyyy-MM-dd") -> nil
    ///
    /// - Parameter format: date format.
    /// - Returns: Date object from string (if applicable).
    public func date(withFormat format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)
    }

    
    /// Returns a localized string, with an optional comment for translators.
    ///
    ///        "Hello world".localized -> Hallo Welt
    ///
    public func localized(comment: String = "") -> String {
        return NSLocalizedString(self, comment: comment)
    }
    
    /// The most common character in string.
    ///
    ///        "This is a test, since e is appearing everywhere e should be the common character".mostCommonCharacter() -> "e"
    ///
    /// - Returns: The most common character.
    public func mostCommonCharacter() -> Character? {
        let mostCommon = stringByRemovedWhitespacesAndNewlines().reduce(into: [Character: Int]()) {
            let count = $0[$1] ?? 0
            $0[$1] = count + 1
            }.max { $0.1 < $1.1 }?.0
        
        return mostCommon
    }
    
    public func classType(moudelName: String) -> AnyClass? {
        return NSClassFromString("\(moudelName).ViewController")
    }

}


// MARK: - NSAttributedString extensions
public extension String {
    
    #if canImport(UIKit)
    private typealias Font = UIFont
    #endif
    
    #if canImport(Cocoa)
    private typealias Font = NSFont
    #endif
    
    #if os(iOS) || os(macOS)
    /// Bold string.
    public var bold: NSAttributedString {
        return NSMutableAttributedString(string: self, attributes: [NSAttributedString.Key.font: Font.boldSystemFont(ofSize: Font.systemFontSize)])
    }
    #endif
    
    #if canImport(Foundation)
    /// Underlined string
    public var underline: NSAttributedString {
        return NSAttributedString(string: self, attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue])
    }
    #endif
    
    #if canImport(Foundation)
    /// Strikethrough string.
    public var strikethrough: NSAttributedString {
        return NSAttributedString(string: self, attributes: [NSAttributedString.Key.strikethroughStyle: NSNumber(value: NSUnderlineStyle.single.rawValue as Int)])
    }
    #endif
    
    #if os(iOS)
    /// Italic string.
    public var italic: NSAttributedString {
        return NSMutableAttributedString(string: self, attributes: [NSAttributedString.Key.font: UIFont.italicSystemFont(ofSize: UIFont.systemFontSize)])
    }
    #endif
    
    #if canImport(UIKit)
    /// Add color to string.
    ///
    /// - Parameter color: text color.
    /// - Returns: a NSAttributedString versions of string colored with given color.
    public func colored(with color: UIColor) -> NSAttributedString {
        return NSMutableAttributedString(string: self, attributes: [NSAttributedString.Key.foregroundColor: color])
    }
    #endif
    
    #if canImport(Cocoa)
    /// Add color to string.
    ///
    /// - Parameter color: text color.
    /// - Returns: a NSAttributedString versions of string colored with given color.
    public func colored(with color: NSColor) -> NSAttributedString {
        return NSMutableAttributedString(string: self, attributes: [.foregroundColor: color])
    }
    #endif
    
}

// MARK: - Operators
public extension String {
    
    /// Repeat string multiple times.
    ///
    ///        'bar' * 3 -> "barbarbar"
    ///
    /// - Parameters:
    ///   - lhs: string to repeat.
    ///   - rhs: number of times to repeat character.
    /// - Returns: new string with given string repeated n times.
    public static func * (lhs: String, rhs: Int) -> String {
        guard rhs > 0 else { return "" }
        return String(repeating: lhs, count: rhs)
    }
}


public extension String {
    public func jsonSerialization() -> Any? {
        guard let data = data(using: .utf8) else { return nil }
        let obj = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
        return obj
    }
    
    
}



