//
//  CGSize+BDExtension.swift
//  BDSwiftExtension
//
//  Created by 诸葛游 on 2017/3/27.
//  Copyright © 2017年 品驰医疗. All rights reserved.
//

import Foundation
import UIKit

extension CGSize {
    
    /// Returns a size with a positive width and height.
    ///
    /// - Returns: A size that represents the source size, but with positive width and height values.
    func standardized() -> CGSize {
        return CGSize(width: self.width < 0 ? -self.width : self.width, height: self.height < 0 ? -self.height : self.height) 
    }
    
    func isStandardized() -> Bool {
        guard self.width <= 0 || self.height <= 0 else {
            return true
        }
        return false
    }
}
