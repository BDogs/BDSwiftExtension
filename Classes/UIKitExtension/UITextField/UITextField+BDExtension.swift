//
//  UITextField+BDExtension.swift
//  Parkinson
//
//  Created by 诸葛游 on 2017/5/2.
//  Copyright © 2017年 品驰医疗. All rights reserved.
//

import Foundation
import UIKit


extension UITextField {
    static let BDTextFieldLimitKey = UnsafeRawPointer.init(bitPattern: "BDTextFieldLimitKey".hashValue)
    static let BDTextFieldInputHandleKey = UnsafeRawPointer.init(bitPattern: "BDTextFieldInputHandleKey".hashValue)
    
    @IBInspectable
    var limit: Int {
        get {
            guard let key = UITextField.BDTextFieldLimitKey else { return 0 }
            return objc_getAssociatedObject(self, key) as? Int ?? 0
        }
        
        set {
            guard let key = UITextField.BDTextFieldLimitKey else { return }
            objc_setAssociatedObject(self, key, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            NotificationCenter.default.addObserver(self, selector: #selector(bd_recieveDidChangeNotification(notif:)), name: UITextField.textDidChangeNotification, object: nil)
        }
    }
    
    var inputHandle: ((_ residue: Int) -> Void)? {
        get {
            guard let key = UITextField.BDTextFieldInputHandleKey else { return nil }
            return objc_getAssociatedObject(self, key) as? ((_ residue: Int) -> Void) ?? nil
        }
        set {
            guard let key = UITextField.BDTextFieldInputHandleKey else { return }
            objc_setAssociatedObject(self, key, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }

    //residue
    public func inputWords(handle: @escaping (_ residue: Int) -> Void) -> Void {
        self.inputHandle = handle
    }

   
    @objc private func bd_recieveDidChangeNotification(notif: Notification) -> Void {
        
        guard self.text != placeholder else {
            return
        }
        
        guard self.text != nil else {
            return
        }
        
        let text = self.text! as NSString
        var residue = limit - text.length
        
        if residue <= 0 {
            self.text = text.substring(to: limit)
            residue = 0
        }
        if self.inputHandle != nil {
            self.inputHandle!(residue)
        }
    }
}
