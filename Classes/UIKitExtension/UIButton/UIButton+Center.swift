//
//  UIButton+Center.swift
//  PinsLife_Swift
//
//  Created by Junyan Wu on 16/2/25.
//  Copyright © 2016年 清华大学. All rights reserved.
//

import UIKit
extension UIButton {
    public func centerContent() {
        let spacing: CGFloat = 6.0
        let imageSize: CGSize = self.imageView!.image!.size
        self.titleEdgeInsets = UIEdgeInsetsMake(0.0, -imageSize.width, -(imageSize.height + spacing), 0.0);
        let labelString = NSString(string: self.titleLabel!.text!)
        let titleSize = labelString.size(withAttributes: [NSAttributedStringKey.font: self.titleLabel!.font])
        self.imageEdgeInsets = UIEdgeInsetsMake(-(titleSize.height + spacing), 0.0, 0.0, -titleSize.width);
    }
    
    public func spreadBothSides(left: CGFloat, right: CGFloat) {
        let imageSize: CGSize = self.imageView!.image!.size
        let labelString = NSString(string: self.titleLabel!.text!)
        let titleSize = labelString.size(withAttributes: [NSAttributedStringKey.font: self.titleLabel!.font])
        let leftMove = self.frame.size.width / 2 - (imageSize.width + titleSize.width) / 2 - left
        let rightMove = self.frame.size.width / 2 - (imageSize.width + titleSize.width) / 2 - right
        self.imageEdgeInsets = UIEdgeInsetsMake(0, -leftMove, 0, leftMove)
        self.titleEdgeInsets = UIEdgeInsetsMake(0, rightMove, 0, -rightMove)
    }
    
    public func reverseTextAndImage() {
        self.transform = CGAffineTransform(scaleX: -1.0, y: 1.0);
        self.titleLabel!.transform = CGAffineTransform(scaleX: -1.0, y: 1.0);
        self.imageView!.transform = CGAffineTransform(scaleX: -1.0, y: 1.0);
    }
}
