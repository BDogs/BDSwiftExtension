//
//  UIView+SnapShot.swift
//  PksDoctor
//
//  Created by 诸葛游 on 2017/6/1.
//  Copyright © 2017年 品驰医疗. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    public func snapshotImage(rect: CGRect) -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, isOpaque, 0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        layer.render(in: context)
        
        guard let snap = UIGraphicsGetImageFromCurrentImageContext() else {
            UIGraphicsEndImageContext()
            return nil }
        UIGraphicsEndImageContext()
        
        
        let newRect = CGRect(x: rect.minX*snap.scale, y: rect.minY*snap.scale, width: rect.width*snap.scale, height: rect.height*snap.scale)
        guard newRect.size.isStandardized() else {
            return nil
        }
        // TODO: 这里要验证下 直接使用这个方法
        guard let imageRef = snap.cgImage?.cropping(to: newRect) else {
            return snap
        }
        let image = UIImage(cgImage: imageRef, scale: snap.scale, orientation: snap.imageOrientation)
        // TODO: 这里要验证下 是否需要 release
        return image
    
    }
    
    
    
    
}


