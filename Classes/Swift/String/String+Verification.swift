//
//  String+MD5.swift
//  Parkinson
//
//  Created by 诸葛游 on 2017/5/15.
//  Copyright © 2017年 品驰医疗. All rights reserved.
//

import Foundation
import UIKit


extension String {
    /**
     *  宽泛
     */
    public func isPhoneNumber() -> Bool {
        let regex = "^[1][0-9]{10}$"
        let regExPredicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return regExPredicate.evaluate(with:self)
    }
    
    public func hasBlankCharacter() -> Bool {
        return components(separatedBy: .whitespacesAndNewlines).count != 1
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

    
    public func isUnderLengthMaxLimit(limit: Int) -> Bool {
        return count <= limit
    }
    
    /// Verify if string matches the regex pattern.
    ///
    /// - Parameter pattern: Pattern to verify.
    /// - Returns: true if string matches the pattern.
    public func matches(pattern: String) -> Bool {
        return range(of: pattern, options: .regularExpression, range: nil, locale: nil) != nil
    }
    
    /// Check if string contains one or more letters.
    ///
    ///        "123abc".hasLetters -> true
    ///        "123".hasLetters -> false
    ///
    public var hasLetters: Bool {
        // options 似乎用 .literal 也是可以的
        // 从左向右找到第一个字母字符时返回 range，若未找到返回 nil
        return rangeOfCharacter(from: .letters, options: .numeric, range: nil) != nil
    }
    
    /// Check if string contains one or more numbers.
    ///
    ///        "abcd".hasNumbers -> false
    ///        "123abc".hasNumbers -> true
    ///
    public var hasNumbers: Bool {
        return rangeOfCharacter(from: .decimalDigits, options: .literal, range: nil) != nil
    }
    
    
    /// 字母和数字混合
    ///        "abcd".hasNumbers -> false
    ///        "123abc".hasNumbers -> true
    public var isAlphanumerics: Bool {
        let comps = components(separatedBy: .alphanumerics)
        return comps.joined(separator: "").count == 0 && hasLetters && hasNumbers
    }
    
    public var isOnlyNumbers: Bool {
        return hasNumbers && !hasLetters
    }
    
    public var isOnlyLetters: Bool {
        return hasLetters && !hasNumbers
    }
    
    public var isEmail: Bool {
        return matches(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}")
    }

    /// Check if string is a valid Swift number.
    ///
    /// Note:
    /// In North America, "." is the decimal separator,
    /// while in many parts of Europe "," is used,
    ///
    ///        "123".isNumeric -> true
    ///     "1.3".isNumeric -> true (en_US)
    ///     "1,3".isNumeric -> true (fr_FR)
    ///        "abc".isNumeric -> false
    ///
    public var isNumeric: Bool {
        let scanner = Scanner(string: self)
        scanner.locale = NSLocale.current
        return scanner.scanDecimal(nil) && scanner.isAtEnd
    }
    
    /// Check if string only contains digits.
    ///
    ///     "123".isDigits -> true
    ///     "1.3".isDigits -> false
    ///     "abc".isDigits -> false
    ///
    public var isDigits: Bool {
        return CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: self))
    }

    /// x 位数字的字符串
    ///
    /// - Parameter limt:
    /// - Returns: bool
    public func isNumbers(limt: Int) -> Bool {
        guard self.lengthOfBytes(using: .utf8) == limt else {
            return false
        }
        let regex = "^\\d{\(limt)}"
        let regExPredicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return regExPredicate.evaluate(with:self)
    }
    
    public func isStringWithNumbersAndLettersAndUnderline(min: Int, max: Int) -> Bool {
        guard max > min  else {
            return false
        }
        let regex = "^[a-zA-Z0-9_]{\(min),\(max)}$"
        let regExPredicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return regExPredicate.evaluate(with:self)
    }
    
    
    /// [min...max] 位中文字符串
    ///
    /// - Parameters:
    ///   - min:
    ///   - max:
    /// - Returns: bool
    public func isStringWithChinese(min: Int, max: Int) -> Bool {
        guard max > min  else {
            return false
        }
        let regex = "^[\\u4e00-\\u9fa5]{\(min),\(max)}$"
        let regExPredicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return regExPredicate.evaluate(with:self)

    }
    
    /// 只验证身份证18位的格式
    public func isIdCardNumberFormat() -> Bool {
        let regex = "^[0-9]{17}([0-9]{1}|x|X)$"
        let regExPredicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return regExPredicate.evaluate(with:self)
    }
    
    /// 验证身份证18位的格式和最后一位校验码是相符
    public func isIdCardNumberCheckCode() -> Bool {
        if !self.isIdCardNumberFormat() {
            return false
        }
        
        let weight = [7,9,10,5,8,4,2,1,6,3,7,9,10,5,8,4,2] //十七位数字本体码权重
        let validates = ["1","0","X","9","8","7","6","5","4","3","2"] //mode 对应校验码字符值
        var sum: Int = 0
        
        for i in 0..<17 {
            let stringValue = self[i]
            //self.substring(with: (self.index(self.startIndex, offsetBy: i)..<self.index(self.startIndex, offsetBy: i+1)))
            let intValue = stringValue?.int ?? 0
            sum += intValue*weight[i]
        }
        
        let mode = sum%11
        let origalCode = self[17]
            //self.substring(with: (self.index(self.startIndex, offsetBy: 17)..<self.index(self.startIndex, offsetBy: 18))).lowercased()
        let validateCode = validates[mode].lowercased()
        if origalCode == validateCode {
            return true
        }
        
        return false
    }
    
}
