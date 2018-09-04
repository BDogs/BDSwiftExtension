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
        
        if str.responds(to: #selector(NSString.boundingRect(with:options:attributes:context:))) {
            var attr: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font]
            if lineBreakMode != .byWordWrapping {
                let style = NSMutableParagraphStyle()
                style.lineBreakMode = lineBreakMode
                attr[NSAttributedString.Key.paragraphStyle] = style
            }

            let rect =  str.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: attr, context: nil)
            result = rect.size
            
        }
        
        let width = result.width.rounded(.up)
        let height = result.height.rounded(.up)
        
        return CGSize(width: width, height: height)
    }
    
    public func widthForText(font: UIFont, maxHeight: CGFloat, lineBreakMode: NSLineBreakMode = .byWordWrapping) -> CGFloat {
        let size = sizeForText(font: font, maxSize: CGSize(width: CGFloat.greatestFiniteMagnitude, height: maxHeight), lineBreakMode: lineBreakMode)
        return size.width
    }
    
    public func heightForText(font: UIFont, maxWidth: CGFloat, lineBreakMode: NSLineBreakMode = .byWordWrapping) -> CGFloat {
        let size = sizeForText(font: font, maxSize: CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude), lineBreakMode: lineBreakMode)
        return size.height
    }
    
    
}
