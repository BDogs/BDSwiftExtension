//
//  UITableView+Extension.swift
//  PinsLife
//
//  Created by 诸葛游 on 2017/7/25.
//  Copyright © 2017年 品驰医疗. All rights reserved.
//

import Foundation
import UIKit


extension UITableView {
    
    @IBInspectable
    public var shouldHideNeedlessCuttingLines: Bool {
        get {
            return self.shouldHideNeedlessCuttingLines
        }
        
        set {
            self.tableFooterView = UIView()
        }
    }

    
}
