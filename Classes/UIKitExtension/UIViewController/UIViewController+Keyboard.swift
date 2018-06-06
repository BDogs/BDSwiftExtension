//
//  UIViewController+Keyboard.swift
//  Unit
//
//  Created by 诸葛游 on 2017/10/11.
//  Copyright © 2017年 品驰医疗. All rights reserved.
//

import Foundation
import UIKit

@objc public enum KeyboardStatus: Int {
    case awakening
    case closed
    case transformational
}

public protocol PLLSControllerKeyboardProtocol {
    func addObserverForKeyboardWillChangeFrame(observer: PLLSControllerKeyboardProtocol) -> Void
    func removeObserverForKeyboardWillChangeFrame(observer: PLLSControllerKeyboardProtocol) -> Void
    //    func didReceiveNotificationOfKeyboardWillChangeFrame(notify: Notification) -> Void
    func willShowKeyboard(from beginFrame: CGRect, to endFrame: CGRect, duration: TimeInterval, status: KeyboardStatus, bottom: CGFloat, options: UIView.AnimationOptions, responder: UIView?) -> Void
}

extension UIViewController {
    
    static let BDInputFirstResponderKey = UnsafeRawPointer.init(bitPattern: "BDInputFirstResponderKey".hashValue)
    
    var inputFirstResponder: UIView? {
        set {
            guard let key = UIViewController.BDInputFirstResponderKey else { return }
            objc_setAssociatedObject(self, key, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
        
        get {
            guard let key = UIViewController.BDInputFirstResponderKey else { return nil }
            return objc_getAssociatedObject(self, key) as? UIView
        }
    }
    
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    public func addObserverForKeyboardWillChangeFrame(observer: PLLSControllerKeyboardProtocol) -> Void {
        let sel = #selector(didReceiveNotificationOfKeyboardWillChangeFrame(notify:))
        NotificationCenter.default.addObserver(observer, selector: sel, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        NotificationCenter.default.addObserver(observer, selector: #selector(self.textFieldDidBeginEditing(notify:)), name: UITextField.textDidBeginEditingNotification, object: nil)
        
        NotificationCenter.default.addObserver(observer, selector: #selector(textViewDidBeginEditing(notify:)), name: UITextView.textDidBeginEditingNotification, object: nil)
        
        
        
//        let sel2 = #selector(didReceiveNotificationOfKeyboardDidChangeFrame(notify:))
//        NotificationCenter.default.addObserver(observer, selector: sel2, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)

    }
    
    public func removeObserverForKeyboardWillChangeFrame(observer: PLLSControllerKeyboardProtocol) -> Void {
        
        NotificationCenter.default.removeObserver(observer, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.removeObserver(observer, name: UITextField.textDidBeginEditingNotification, object: nil)
        NotificationCenter.default.removeObserver(observer, name: UITextView.textDidBeginEditingNotification, object: nil)
        NotificationCenter.default.removeObserver(observer)
    }
    
    @objc func textFieldDidBeginEditing(notify: Notification) {
        inputFirstResponder = notify.object as? UIView
    }
    
    @objc func textViewDidBeginEditing(notify: Notification) {
        inputFirstResponder = notify.object as? UIView
    }
    
    @objc func didReceiveNotificationOfKeyboardWillChangeFrame(notify: Notification) -> Void {
        let responder = inputFirstResponder
        guard let userInfo = notify.userInfo else { return }
        guard let endFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        guard let beginFrame = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? CGRect else { return }
        guard let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
        
        guard let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int else { return }
        
        var status: KeyboardStatus = .closed
        var bottom: CGFloat = 0
        print("begin: \(beginFrame)")
        print("end: \(endFrame)")
        if beginFrame.minY == UIScreen.main.bounds.height && beginFrame.height == 0 {
            // 键盘唤起
            status = .awakening
            bottom = endFrame.height
        } else if endFrame.minY == UIScreen.main.bounds.height {
            // 键盘关闭
            status = .closed
            bottom = 0
        } else {
            // 键盘切换
            status = .transformational
            bottom = endFrame.height
        }
        
        if let controller = self as? PLLSControllerKeyboardProtocol {
            controller.willShowKeyboard(from: beginFrame, to: endFrame, duration: duration, status: status, bottom: bottom, options: [UIView.AnimationOptions(rawValue: UInt(curve<<16)), UIView.AnimationOptions.beginFromCurrentState], responder: responder)
        }
        
    }
    
    
    @objc func didReceiveNotificationOfKeyboardDidChangeFrame(notify: Notification) -> Void {
        guard let userInfo = notify.userInfo else { return }
        print(userInfo)
    }
}




