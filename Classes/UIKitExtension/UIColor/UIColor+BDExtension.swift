//
//  UIColor+BDExtension.swift
//  Parkinson
//
//  Created by 诸葛游 on 2017/4/12.
//  Copyright © 2017年 品驰医疗. All rights reserved.
//

import Foundation
import UIKit

public extension UIColor {
    
    /// 十六进制色值和不透明度创建 UIColor
    ///
    /// - Parameters:
    ///   - hex: 十六进制整形 例如：0xDECEB5
    ///   - alpha: 不透明度 【0，1.0】 默认为1.0
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        self.init(red: CGFloat(hex>>16)/255.0, green: CGFloat((hex>>8)&0xff)/255.0, blue: CGFloat(hex&0xff)/255.0, alpha: alpha)
    }
    
    static var random: UIColor {
        get {
            let r = CGFloat(Int(arc4random_uniform(255)))/255.0
            let g = CGFloat(Int(arc4random_uniform(255)))/255.0
            let b = CGFloat(Int(arc4random_uniform(255)))/255.0
            return UIColor(red: r, green: g, blue: b, alpha: 1.0)
        }
    }
    
    
}
