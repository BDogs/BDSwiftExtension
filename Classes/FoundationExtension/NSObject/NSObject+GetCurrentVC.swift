//
//  NSObject+GetCurrentVC.swift
//  Example
//
//  Created by 诸葛游 on 2019/6/19.
//  Copyright © 2019 品驰医疗. All rights reserved.
//

import Foundation
import UIKit

extension NSObject {
    public func showInputAlert(title: String?,
                               message: String?,
                               fields: [(text: String?, placeHolder: String, borderStyle: UITextField.BorderStyle, UIKeyboardType)],
                               confirmTitle: String = "确定",
                               confirmTitleColor: UIColor = UIColor.black,
                               cancelTitle: String = "取消",
                               cancelTitleColor: UIColor = UIColor.lightGray,
                               confirmHandler: ((_ textFields: [UITextField]?) -> Void)?,
                               cancelHandler: (() -> Void)?) -> Void {
        
        let theTitle = title ?? ""
        let theMessage = message ?? ""
        if theTitle.isEmpty && theMessage.isEmpty {
            return
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        for (text, holder, style, keyboardType) in fields {
            alert.addTextField(configurationHandler: { (textField) in
                textField.placeholder = holder
                textField.text = text
                textField.borderStyle = style
                textField.keyboardType = keyboardType
            })
        }
        
        let confirm = UIAlertAction(title: confirmTitle, style: .default) { (action) in
            confirmHandler?(alert.textFields)
        }
        let cancel = UIAlertAction(title: cancelTitle, style: .cancel) { (action) in
            cancelHandler?()
        }
        
        confirm.setValue(confirmTitleColor, forKey: "titleTextColor")
        cancel.setValue(cancelTitleColor, forKey: "titleTextColor")
        
        alert.addAction(cancel)
        alert.addAction(confirm)
        
        getCurrentViewController()?.present(alert, animated: true, completion: nil)
        
        
    }
    
    public func showConfirmAlert(
        title: String?,
        message: String?,
        tintColor: UIColor = UIColor.black,
        confirmTitle: String = "确定",
        from: UIViewController? = nil,
        handler: (() -> Void)?) -> Void {
        
        let theTitle = title ?? ""
        let theMessage = message ?? ""
        if theTitle.isEmpty && theMessage.isEmpty {
            return
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirm = UIAlertAction(title: confirmTitle, style: .default) { (action) in
            handler?()
        }
        confirm.setValue(tintColor, forKey: "titleTextColor")
        alert.addAction(confirm)
        if let from = from {
            from.present(alert, animated: true, completion: nil)
        } else {
            getCurrentViewController()?.present(alert, animated: true, completion: nil)
        }
    }
    
    public func showEnquireAlert(
        title: String?,
        message: String?,
        confirmTitle: String = "确定",
        confirmTitleColor: UIColor = UIColor.black,
        cancelTitleColor: UIColor = UIColor.lightGray,
        cancelTitle: String = "取消",
        confirmHandler: (() -> Void)?,
        cancelHandler: (() -> Void)?) -> Void {
        
        let theTitle = title ?? ""
        let theMessage = message ?? ""
        if theTitle.isEmpty && theMessage.isEmpty {
            return
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirm = UIAlertAction(title: confirmTitle, style: .default) { (action) in
            confirmHandler?()
        }
        let cancel = UIAlertAction(title: cancelTitle, style: .cancel) { (action) in
            cancelHandler?()
        }
        
        confirm.setValue(confirmTitleColor, forKey: "titleTextColor")
        cancel.setValue(cancelTitleColor, forKey: "titleTextColor")
        
        alert.addAction(cancel)
        alert.addAction(confirm)
        
        getCurrentViewController()?.present(alert, animated: true, completion: nil)
    }
    
    public func getCurrentViewController() -> UIViewController? {
        var window = UIApplication.shared.keyWindow
        if window?.windowLevel != UIWindow.Level.normal {
            for tmpWin in UIApplication.shared.windows {
                if tmpWin.windowLevel == UIWindow.Level.normal {
                    window = tmpWin
                    break
                }
            }
        }
        
        let frontView = window?.subviews.first
        let nextResponder = frontView?.next
        var rootVC: UIViewController?
        
        if let temp = nextResponder as? UIViewController {
            rootVC = temp
        } else {
            rootVC = window?.rootViewController
        }
        
        let result = findTopViewController(inController: rootVC)
        return result
    }
    
    func findTopViewController(inController: UIViewController?) -> UIViewController? {
        if let flag = inController?.isKind(of: UITabBarController.self), flag {
            return findTopViewController(inController: (inController as? UITabBarController)?.selectedViewController)
        } else if let flag = inController?.isKind(of: UINavigationController.self), flag {
            return findTopViewController(inController: (inController as? UINavigationController)?.visibleViewController)
        } else if let flag = inController?.isKind(of: UIViewController.self), flag {
            return inController
        } else {
            return nil
        }
    }

}
