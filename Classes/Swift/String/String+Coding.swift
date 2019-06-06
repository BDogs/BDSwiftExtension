//
//  String+Coding.swift
//  Example
//
//  Created by 诸葛游 on 2018/9/3.
//  Copyright © 2018年 品驰医疗. All rights reserved.
//

import Foundation

// MARK: - encode and decode
public extension String {
    
    /// Create a new string from a base64 string (if applicable).
    ///
    /// eg: String(base64: "SGVsbG8gV29ybGQh") = "Hello World!"
    /// eg: String(base64: "hello") = nil
    ///
    /// - Parameter base64: base64 string.
    init?(base64: String) {
        guard let decodedData = Data(base64Encoded: base64) else { return nil }
        guard let str = String(data: decodedData, encoding: .utf8) else { return nil }
        self.init(str)
    }
    
    /// base64 字符串
    /// eg: "Hello World!".base64 = "SGVsbG8gV29ybGQh"
    var base64: String? {
        guard let orignalData = data(using: .utf8) else { return nil }
        let encodedData = orignalData.base64EncodedData(options: [])
        return String(data: encodedData, encoding: .utf8)
    }
    
    /// Readable string from a URL string.
    ///
    /// eg: "it's%20easy%20to%20decode%20strings".urlDecoded -> "it's easy to decode strings"
    /// ps: 这里是简单实现，没有YYKit上实现的复杂，个人觉得没有必要，留待验证
    var urlDecoded: String {
        return removingPercentEncoding ?? self
    }
    
    /// SwifterSwift: URL escaped string.
    ///
    /// eg: "it's easy to encode strings".urlEncoded -> "it's%20easy%20to%20encode%20strings"
    /// ps: 这里是简单实现，没有YYKit上实现的复杂，个人觉得没有必要，留待验证
    var urlEncoded: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    /// html 特殊字符转义
//    var htmlEscaping: String {
//        var ret = ""
//        for c in characters {
//            c.unicodeScalars
//            switch c {
//            
//            case 34:
//                break
//            default break
//            }
//        }
//        return ""
//    }
    
}


