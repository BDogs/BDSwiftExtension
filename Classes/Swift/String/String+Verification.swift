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
        let temp = self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return temp != self
    }
    
    public func isUnderLengthMaxLimit(limit: Int) -> Bool {
        return count <= limit
    }
    
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
