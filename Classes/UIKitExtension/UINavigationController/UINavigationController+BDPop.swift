//
//  UINavigationController+BDPop.swift
//  Unit
//
//  Created by 诸葛游 on 2017/11/29.
//  Copyright © 2017年 品驰医疗. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController {
    public func popTo(index: Int, animated: Bool) -> Void {
        guard viewControllers.count > 0 else {
            return
        }
        
        guard index >= 0,  index < viewControllers.count  else {
            return
        }
        
        let controller = viewControllers[index]
        popToViewController(controller, animated: animated)
    }
    
    public func popToTheControllerBeforeLast(animated: Bool) -> Void {
        print(viewControllers.count)
        guard viewControllers.count - 2 - 1 >= 0 else {
            return
        }
        let index = viewControllers.count - 2 - 1
        popTo(index: index, animated: animated)
    }
    
    
    
}
