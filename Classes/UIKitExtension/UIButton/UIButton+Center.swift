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
        self.titleEdgeInsets = UIEdgeInsets.init(top: 0.0, left: -imageSize.width, bottom: -(imageSize.height + spacing), right: 0.0);
        let labelString = NSString(string: self.titleLabel!.text!)
        let titleSize = labelString.size(withAttributes: [NSAttributedString.Key.font: self.titleLabel!.font])
        self.imageEdgeInsets = UIEdgeInsets.init(top: -(titleSize.height + spacing), left: 0.0, bottom: 0.0, right: -titleSize.width);
    }
    
    public func spreadBothSides(left: CGFloat, right: CGFloat) {
        let imageSize: CGSize = self.imageView!.image!.size
        let labelString = NSString(string: self.titleLabel!.text!)
        let titleSize = labelString.size(withAttributes: [NSAttributedString.Key.font: self.titleLabel!.font])
        let leftMove = self.frame.size.width / 2 - (imageSize.width + titleSize.width) / 2 - left
        let rightMove = self.frame.size.width / 2 - (imageSize.width + titleSize.width) / 2 - right
        self.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: -leftMove, bottom: 0, right: leftMove)
        self.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: rightMove, bottom: 0, right: -rightMove)
    }
    
    public func reverseTextAndImage() {
        self.transform = CGAffineTransform(scaleX: -1.0, y: 1.0);
        self.titleLabel!.transform = CGAffineTransform(scaleX: -1.0, y: 1.0);
        self.imageView!.transform = CGAffineTransform(scaleX: -1.0, y: 1.0);
    }
}
