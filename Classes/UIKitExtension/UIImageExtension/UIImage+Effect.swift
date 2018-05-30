//
//  UIImage+Effect.swift
//  BDSwiftExtension
//
//  Created by 诸葛游 on 2017/4/10.
//  Copyright © 2017年 品驰医疗. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics


extension UIImage {
    
    /// 给图片透明通道着色
    ///
    /// - Parameters:
    ///   - color: tint color
    ///   - blendMode: 颜色混合模式 默认 destinationIn
    ///   - alpha: 不透明度 默认 1.0
    /// - Returns: 着色后的图片
    public func bd_imageByTintColor(color: UIColor, blendMode: CGBlendMode = .destinationIn, alpha: CGFloat = 1.0) -> UIImage? {
        // 设置 opaque 为 false， 位图必须包含一个透明通道来处理部分透明像素
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        color.set()
        UIRectFill(rect)
        draw(at: CGPoint.zero, blendMode: blendMode, alpha: alpha)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }


    /// 给图片添加水印

}
