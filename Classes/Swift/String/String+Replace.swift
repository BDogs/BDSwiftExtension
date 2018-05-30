//
//  String+3DES.swift
//  PinsLife
//
//  Created by 诸葛游 on 2017/7/24.
//  Copyright © 2017年 品驰医疗. All rights reserved.
//

import Foundation

extension String {
    
   public func bd_replacingCharacters(pre: Int, suf: Int, fillers: String) -> String? {
    let length = lengthOfBytes(using: .utf8)
    guard length > pre+suf else {
        return nil
    }
    let first =  index(startIndex, offsetBy: pre)
    let last = index(endIndex, offsetBy: -suf)
    let c = Array(repeating: "*", count: length-pre-suf)
    return replacingCharacters(in: first..<last, with: c.joined())
    }
    
    
}
