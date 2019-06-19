//
//  Base64Image.swift
//  Parkinson
//
//  Created by 诸葛游 on 2017/5/5.
//  Copyright © 2017年 品驰医疗. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    public func base64String(compressionQuality: CGFloat) -> String? {
        let data = self.jpegData(compressionQuality: compressionQuality)
            
        let result = data?.base64EncodedString()
        return result
    }
    
    public convenience init?(base64String: String) {
        guard let data = Data(base64Encoded: base64String) else { return nil }
        self.init(data: data)
    }
    
}
