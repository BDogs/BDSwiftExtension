//
//  UINib+Initialization.swift
//  Unit
//
//  Created by 诸葛游 on 2017/12/1.
//  Copyright © 2017年 品驰医疗. All rights reserved.
//

import Foundation
import UIKit

extension UITableViewCell {
    public class func nib() -> UINib {
        var nibName = NSStringFromClass(self)
        if let temp = nibName.components(separatedBy: ".").last {
            nibName = temp
        }
        return UINib.init(nibName: nibName, bundle: Bundle(for: self))
    }
}

extension UICollectionViewCell {
    public class func cellNib() -> UINib {
        var nibName = NSStringFromClass(self)
        if let temp = nibName.components(separatedBy: ".").last {
            nibName = temp
        }
        return UINib.init(nibName: nibName, bundle: Bundle(for: self))
    }
}

// UICollectionReusableView
extension UICollectionReusableView {
    public class func nib() -> UINib {
        var nibName = NSStringFromClass(self)
        if let temp = nibName.components(separatedBy: ".").last {
            nibName = temp
        }
        return UINib.init(nibName: nibName, bundle: Bundle(for: self))
    }
}

