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
    
    public var url: URL? {
        return URL(string: self)
    }
    
    public var fileUrl: URL {
        return URL(fileURLWithPath: self)
    }
    
    public var isWhitespace: Bool {
        return self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    /// Check if string contains one or more emojis.
    /// eg: "Hello 😀".containEmoji -> true
    public var containEmoji: Bool {
        // unicodeScalars: Unicode标量值的集合
        for scalar in unicodeScalars {
            switch scalar.value {
            case 0x3030, 0x00AE, 0x00A9, // Special Characters
            0x1D000...0x1F77F, // Emoticons
            0x2100...0x27BF, // Misc symbols and Dingbats
            0xFE00...0xFE0F, // Variation Selectors
            0x1F900...0x1F9FF: // Supplemental Symbols and Pictographs
                return true
            default:
                continue
            }
        }
        return false
    }
    
    /// Check if string contains one or more instance of substring.
    ///
    ///        "Hello World!".contain("O") -> false
    ///        "Hello World!".contain("o", caseSensitive: false) -> true
    ///
    /// - Parameters:
    ///   - string: substring to search for.
    ///   - caseSensitive: set true for case sensitive search (default is true).
    /// - Returns: true if string contains one or more instance of substring.
    public func contains(_ string: String, caseSensitive: Bool = true) -> Bool {
        if !caseSensitive {
            return range(of: string, options: .caseInsensitive) != nil
        }
        return range(of: string) != nil
    }

    // MARK: - transform
    
    /// 去掉字符串中空格
    /// eg：" 2 123 \n" -> "2123"
    public func stringByRemovedWhitespacesAndNewlines() -> String {
        var temp = self.components(separatedBy: .whitespacesAndNewlines)
        temp = temp.filter{ $0 != "" }
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
    ///        "Swift is amazing".wordsCount() -> 3
    ///
    /// - Returns: The count of words contained in a string.
    public func wordCount() -> Int {
        // https://stackoverflow.com/questions/42822838
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
    
    /// 字符串倒序
    public func reverseString() -> String {
        return String(reversed())
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

    /// Verify if string matches the regex pattern.
    ///
    /// - Parameter pattern: Pattern to verify.
    /// - Returns: true if string matches the pattern.
    public func matches(pattern: String) -> Bool {
        return range(of: pattern, options: .regularExpression, range: nil, locale: nil) != nil
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

}


// MARK: - Initializers
public extension String {
    
    #if canImport(Foundation)
    /// Create a new string from a base64 string (if applicable).
    ///
    ///        String(base64: "SGVsbG8gV29ybGQh") = "Hello World!"
    ///        String(base64: "hello") = nil
    ///
    /// - Parameter base64: base64 string.
    public init?(base64: String) {
        guard let decodedData = Data(base64Encoded: base64) else { return nil }
        guard let str = String(data: decodedData, encoding: .utf8) else { return nil }
        self.init(str)
    }
    #endif
    
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
        return NSMutableAttributedString(string: self, attributes: [.font: Font.boldSystemFont(ofSize: Font.systemFontSize)])
    }
    #endif
    
    #if canImport(Foundation)
    /// Underlined string
    public var underline: NSAttributedString {
        return NSAttributedString(string: self, attributes: [.underlineStyle: NSUnderlineStyle.styleSingle.rawValue])
    }
    #endif
    
    #if canImport(Foundation)
    /// Strikethrough string.
    public var strikethrough: NSAttributedString {
        return NSAttributedString(string: self, attributes: [.strikethroughStyle: NSNumber(value: NSUnderlineStyle.styleSingle.rawValue as Int)])
    }
    #endif
    
    #if os(iOS)
    /// Italic string.
    public var italic: NSAttributedString {
        return NSMutableAttributedString(string: self, attributes: [.font: UIFont.italicSystemFont(ofSize: UIFont.systemFontSize)])
    }
    #endif
    
    #if canImport(UIKit)
    /// Add color to string.
    ///
    /// - Parameter color: text color.
    /// - Returns: a NSAttributedString versions of string colored with given color.
    public func colored(with color: UIColor) -> NSAttributedString {
        return NSMutableAttributedString(string: self, attributes: [.foregroundColor: color])
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


