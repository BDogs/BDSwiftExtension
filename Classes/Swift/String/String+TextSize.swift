//
//  String+TextSize.swift
//  Parkinson
//
//  Created by 诸葛游 on 2017/4/24.
//  Copyright © 2017年 品驰医疗. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    
    public func sizeForText(font: UIFont, maxSize: CGSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude), lineBreakMode: NSLineBreakMode = .byWordWrapping) -> CGSize {
        var result: CGSize = CGSize.zero
        let str = self as NSString
        
//        if str.responds(to: #selector(NSString.size(attributes:))) {
//            var attr: [String: Any] = [NSFontAttributeName: font]
//            if lineBreakMode != .byWordWrapping {
//                let style = NSMutableParagraphStyle()
//                style.lineBreakMode = lineBreakMode
//                attr[NSParagraphStyleAttributeName] = style
//            }
//            print(str.size(attributes: attr))
//            
//        }
        
        
        if str.responds(to: #selector(NSString.boundingRect(with:options:attributes:context:))) {
            var attr: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: font]
            if lineBreakMode != .byWordWrapping {
                let style = NSMutableParagraphStyle()
                style.lineBreakMode = lineBreakMode
                attr[NSAttributedStringKey.paragraphStyle] = style
            }

            let rect =  str.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: attr, context: nil)
            result = rect.size
            
        } else {
//            result = str.size
        }
        
        let width = result.width.rounded(.up)
        let height = result.height.rounded(.up)
        
        return CGSize(width: width, height: height)
    }
    
    
    
    
}
