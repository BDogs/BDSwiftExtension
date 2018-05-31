//
//  UIView+NibInitalization.swift
//  Example
//
//  Created by 诸葛游 on 2018/5/31.
//  Copyright © 2018年 品驰医疗. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    public class func nib() -> UINib {
        var nibName = NSStringFromClass(self)
        if let temp = nibName.components(separatedBy: ".").last {
            nibName = temp
        }
        return UINib.init(nibName: nibName, bundle: Bundle(for: self))
    }
}
