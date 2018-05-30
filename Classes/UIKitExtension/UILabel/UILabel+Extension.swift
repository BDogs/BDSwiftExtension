//
//  UILabel+Extension.swift
//  Parkinson
//
//  Created by 诸葛游 on 2017/4/28.
//  Copyright © 2017年 品驰医疗. All rights reserved.
//

import Foundation
import UIKit



extension UILabel {
    
    
//    static let BDShouldFitWidthKey = UnsafeRawPointer.init(bitPattern: "BDShouldFitWidthKey".hashValue)
//    
////    deinit {
////        // perform the deinitialization
////    }
//
//    
//    @IBInspectable
//    var shouldFitWidth: Bool {
//        
//        get {
//            return objc_getAssociatedObject(self, UILabel.BDShouldFitWidthKey) as? Bool ?? false
//        }
//        
//        set {
//            objc_setAssociatedObject(self, UILabel.BDShouldFitWidthKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
//            self.addObserver(self, forKeyPath: "text", options: .new, context: nil)
//            self.fitWidth()
//        }
//        
//    }
//    
//    func fitWidth() -> Void {
//        
//        let fitSize = self.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
//        var newFrame = self.frame
//        newFrame.size.width = fitSize.width
//        self.frame = newFrame
//        
//        for constraint in self.constraints {
//            if constraint.firstAttribute == .width {
//                constraint.constant = fitSize.width
//            }
//        }
//        
//    }
//    
//    
//    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        fitWidth()
//    }
    
}


