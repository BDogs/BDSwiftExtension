//
//  UITextView+PlaceHolder.swift
//  Parkinson
//
//  Created by 诸葛游 on 2017/4/26.
//  Copyright © 2017年 品驰医疗. All rights reserved.
//

import Foundation
import UIKit


extension UITextView {
    
    
    static let BDTextViewPlaceholderKey =  UnsafeRawPointer.init(bitPattern: "BDTextViewPlaceholderKey".hashValue)
    static let BDTextViewOriginalTextColorKey =  UnsafeRawPointer.init(bitPattern: "BDTextViewOriginalTextColorKey".hashValue)
    static let BDTextViewLimitKey = UnsafeRawPointer.init(bitPattern: "BDTextViewLimitKey".hashValue)
    static let BDTextViewInputHandleKey = UnsafeRawPointer.init(bitPattern: "BDTextViewInputHandleKey".hashValue)
    
    static let BDTextViewPlaceholderLabelKey = UnsafeRawPointer.init(bitPattern: "BDTextViewPlaceholderLabelKey".hashValue)
    
    @IBInspectable
    public var placeholder: String? {
        set {
            guard let key = UITextView.BDTextViewPlaceholderKey else { return }
            objc_setAssociatedObject(self, key, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
            
            NotificationCenter.default.addObserver(self, selector: #selector(bd_receiveDidBeginEditingNotification(notif:)), name: Notification.Name.UITextViewTextDidBeginEditing, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(bd_recieveDidChangeNotification(notif:)), name: Notification.Name.UITextViewTextDidChange, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(bd_receiveDidEndEditingNotification(notif:)), name: Notification.Name.UITextViewTextDidEndEditing, object: nil)
            
            self.addSubview(placeholderLabel)
            self.insertSubview(placeholderLabel, at: 1)
            placeholderLabel.text = placeholder
            let fitSize = placeholderLabel.sizeThatFits(CGSize(width: self.width-5*2, height: self.height-5*2))
            placeholderLabel.frame = CGRect(x: 5, y: 8, width: fitSize.width, height: fitSize.height)
        }
        
        get {
            guard let key = UITextView.BDTextViewPlaceholderKey else { return nil }
            return objc_getAssociatedObject(self, key) as? String
        }
    }
    
    open override func layoutSubviews() {
        placeholderLabel.text = placeholder
        let fitSize = placeholderLabel.sizeThatFits(CGSize(width: self.width-8*2, height: self.height-8*2))
        placeholderLabel.frame = CGRect(x: 8, y: 8, width: fitSize.width, height: fitSize.height)
        
        if self.text.isEmpty {
            placeholderLabel.isHidden = false
        } else {
            placeholderLabel.isHidden = true
        }
    }
    
    private var originalTextColor: UIColor? {
        set {
            guard let key = UITextView.BDTextViewOriginalTextColorKey else { return }
            objc_setAssociatedObject(self, key, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        
        get {
            guard let key = UITextView.BDTextViewOriginalTextColorKey else { return nil }
            return objc_getAssociatedObject(self, key) as? UIColor
        }
    }
    
    @IBInspectable
    public var limit: Int {
        get {
            guard let key = UITextView.BDTextViewLimitKey else { return 0 }
           return objc_getAssociatedObject(self, key) as? Int ?? 0
        }
        
        set {
            guard let key = UITextView.BDTextViewLimitKey else { return }
            objc_setAssociatedObject(self, key, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    public var inputHandle: ((_ residue: Int) -> Void)? {
        get {
            guard let key = UITextView.BDTextViewInputHandleKey else { return nil }
            return objc_getAssociatedObject(self, key) as? ((_ residue: Int) -> Void) ?? nil
        }
        set {
            guard let key = UITextView.BDTextViewInputHandleKey else { return }
            objc_setAssociatedObject(self, key, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    var placeholderLabel: UILabel {
        get {
            guard let result = objc_getAssociatedObject(self, UITextView.BDTextViewPlaceholderLabelKey!) as? UILabel else {
                let label = UILabel(frame: CGRect.zero)
                label.textColor = UIColor.lightGray
                label.font = UIFont.systemFont(ofSize: 14)
                label.numberOfLines = 0
                objc_setAssociatedObject(self, UITextView.BDTextViewPlaceholderLabelKey!, label, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return label }
            
            return result
        }
    }
    
    public func inputInitialText(text: String?) -> Void {
        self.text = text
        dealWithLimit()
    }
    
    func dealWithLimit() -> Void {
        guard self.text != placeholder else {
            return
        }
        if self.text.isEmpty {
            placeholderLabel.isHidden = false
        } else {
            placeholderLabel.isHidden = true
        }
        
        guard limit != 0 else {
            return
        }
        
        let text = self.text as NSString
        var residue = limit-text.length
        if residue <= 0 {
            self.text = text.substring(to: limit)
            residue = 0
        }
        if self.inputHandle != nil {
            self.inputHandle!(residue)
        }

    }
    
    //residue
    func inputWords(handle: @escaping (_ residue: Int) -> Void) -> Void {
        self.inputHandle = handle
    }
    
    @objc private func bd_receiveDidBeginEditingNotification(notif: Notification) -> Void {
        guard let current = notif.object as? UITextView, current == self else { return }
        placeholderLabel.isHidden = true
    }
    
    @objc private func bd_recieveDidChangeNotification(notif: Notification) -> Void {
        guard let current = notif.object as? UITextView, current == self else { return }
        dealWithLimit()
    }
    
    @objc private func bd_receiveDidEndEditingNotification(notif: Notification) -> Void {
        guard let current = notif.object as? UITextView, current == self else { return }
        if self.text.isEmpty {
            placeholderLabel.isHidden = false
        } else {
            placeholderLabel.isHidden = true
        }
    }
    
}
