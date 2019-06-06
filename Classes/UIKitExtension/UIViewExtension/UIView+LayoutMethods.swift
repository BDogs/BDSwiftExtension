//
//  UIView+LayoutMethods.swift
//  BDSwiftExtension
//
//  Created by 诸葛游 on 2017/3/24.
//  Copyright © 2017年 品驰医疗. All rights reserved.
//

import Foundation
import UIKit

let BD_IS_IPHONEX = UIScreen.main.bounds.height == 812
let BD_NAVIGATIONBAR_HEIGHT: CGFloat = (UIScreen.main.bounds.height == 812 || UIScreen.main.bounds.height == 896) ? 88 : 64
let BD_TabBAR_HEIGHT: CGFloat = (UIScreen.main.bounds.height == 812 || UIScreen.main.bounds.height == 896) ? 83 : 49
let BD_SAFE_BOTTOM: CGFloat = (UIScreen.main.bounds.height == 812 || UIScreen.main.bounds.height == 896) ? 34 : 0
let BD_SAFE_TOP: CGFloat = (UIScreen.main.bounds.height == 812 || UIScreen.main.bounds.height == 896) ? 44 : 20

let BD_SCREEN_WIDTH = UIScreen.main.bounds.width
let BD_SCREEN_HEIGHT = UIScreen.main.bounds.height
let BD_SCREEN_HEIGHT_WITHOUT_STATUSBAR = BD_SCREEN_HEIGHT-UIApplication.shared.statusBarFrame.height
let BD_SCREEN_HEIGHT_WITHOUT_NAVIGATIONBAR = BD_SCREEN_HEIGHT-BD_NAVIGATIONBAR_HEIGHT

let BD_SYSTEM_VERSION = UIDevice.current.systemVersion
fileprivate var kTopSuperView = "kTopSuperView"


/// 判断当前系统的版本号是否大于 target
///
/// - Parameter v: target version
/// - Returns: 是否大于
func BD_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v: Double) -> Bool {
    return rint(Double(BD_SYSTEM_VERSION)!) > rint(v)
}


public extension UIView {
    
    
    static let BDUIViewCornerRadiusKey = UnsafeRawPointer.init(bitPattern: "BDUIViewCornerRadiusKey".hashValue)
    
    
    // MARK: - coordinate
    var height: CGFloat {
        get {
            return self.frame.height
        }
        set {
            var newFrame = self.frame
            newFrame.size.height = newValue
            self.frame = newFrame
        }
    }
    
    var width: CGFloat {
        get {
            return self.frame.width
        }
        set {
            var newFrame = self.frame
            newFrame.size.width = newValue
            self.frame = newFrame
        }
    }
    
    var minX : CGFloat {
        get {
            return self.frame.minX
        }
        set {
            var newFrame = self.frame
            newFrame.origin.x = newValue
            self.frame = newFrame
        }
    }
    
    var minY : CGFloat {
        get {
            return self.frame.minY
        }
        set {
            var newFrame = self.frame
            newFrame.origin.y = newValue
            self.frame = newFrame
        }
    }
    
    var maxX: CGFloat {
        return self.frame.maxX
    }
    
    var maxY: CGFloat {
        return self.frame.maxY
    }
    
    var size: CGSize {
        get {
            return self.frame.size
        }
        set {
            var newFrame = self.frame
            newFrame.size = newValue
            self.frame = newFrame
        }
    }
    
    var origin: CGPoint {
        get {
            return self.frame.origin
        }
        set {
            var newFrame = self.frame
            newFrame.origin = newValue
            self.frame = newFrame
        }
    }
    
    var midX: CGFloat {
        get {
            return self.frame.midX
        }
        set {
            var newCenter = self.center
            newCenter.x = newValue
            self.center = newCenter
        }
    }
    
    var midY: CGFloat {
        get {
            return self.frame.midY
        }
        set {
            var newCenter = self.center
            newCenter.y = newValue
            self.center = newCenter
        }
    }
    
    // MARK: - equal to
    func topSuperView() -> UIView {
        let ret = objc_getAssociatedObject(self, &kTopSuperView)
        print(ret ?? "nil")
        if ret != nil {
            return ret as! UIView
        }
    
        var topSuperView = self.superview
        if topSuperView == nil {
            topSuperView = self
        } else {
            while ((topSuperView?.superview) != nil) {
                topSuperView = topSuperView?.superview!
            }
        }
        objc_setAssociatedObject(self, &kTopSuperView, topSuperView, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return topSuperView!
    }
    
    private func bd_superView(view: UIView) -> UIView {
        var superView = view.superview
        if superView == nil {
            superView = view
        }
        return superView!
    }
    
    func heightEqualTo(view: UIView) -> Void {
        self.height = view.height
    }
    
    func widthEqualTo(view: UIView) -> Void {
        self.width = view.width
    }
    
    func midXEqualTo(view: UIView) -> Void {
        let superView = bd_superView(view: view)
        let viewCenterPoint = superView.convert(view.center, to: self.topSuperView())
        let centerPoint = self.topSuperView().convert(viewCenterPoint, to: self.superview)
        self.midX = centerPoint.x
    }
    
    func midYEqualTo(view: UIView) -> Void {
        let superView = bd_superView(view: view)
        let viewCenterPoint = superView.convert(view.center, to: self.topSuperView())
        let centerPoint = self.topSuperView().convert(viewCenterPoint, to: self.superview)
        self.midY = centerPoint.y
    }
    
    func centerEqualTo(view: UIView) -> Void {
        let superView = bd_superView(view: view)
        let viewCenterPoint = superView.convert(view.center, to: self.topSuperView())
        let centerPoint = self.topSuperView().convert(viewCenterPoint, to: self.superview)
        self.midX = centerPoint.x
        self.midY = centerPoint.y
    }
    
    // MARK: - top, bottom, leading, trailing -- Version 1.0.0
    func bottomTo(view: UIView, space: CGFloat) -> Void {
        let superView = bd_superView(view: view)
        let viewOrigin = superView.convert(view.origin, to: topSuperView())
        let newOrigin = topSuperView().convert(viewOrigin, to: self.superview)
        self.minY = newOrigin.y - space - self.height
    }
    
    func topTo(view: UIView, space: CGFloat) -> Void {
        let superView = bd_superView(view: view)
        let viewOrigin = superView.convert(view.origin, to: topSuperView())
        let newOrigin = topSuperView().convert(viewOrigin, to: self.superview)
        self.minY = newOrigin.y + view.height + space
    }
    
    func trailingTo(view: UIView, space: CGFloat) -> Void {
        let superView = bd_superView(view: view)
        let viewOrigin = superView.convert(view.origin, to: topSuperView())
        let newOrigin = topSuperView().convert(viewOrigin, to: self.superview)
        self.minX = newOrigin.x - space - self.width
    }
    
    func leadingTo(view: UIView, space: CGFloat) -> Void {
        let superView = bd_superView(view: view)
        let viewOrigin = superView.convert(view.origin, to: topSuperView())
        let newOrigin = topSuperView().convert(viewOrigin, to: self.superview)
        self.minX = newOrigin.x + view.width + space
    }
    
    // MARK: - corner setting
    private static let kCornerLayerName = "kCornerLayerName"
    func bd_removeCorner() -> Void {
        guard layer.sublayers != nil else {
            return
        }
        
        for layer in self.layer.sublayers! {
            if layer.name == UIView.kCornerLayerName {
                layer.removeFromSuperlayer()
            }
        }
    }
    
//    func bd_corner(
//        radius: CGFloat,
//        corners: UIRectCorner = .allCorners,
//        bgColor: UIColor,
//        borderWidth: CGFloat = 0,
//        borderColor: UIColor? = nil,
//        borderLineJoin: CGLineJoin = .round) -> Void {
//        bd_removeCorner()
//        
//        let cornerBounds = self.bounds
//        let width = cornerBounds.width
//        let height = cornerBounds.height
//        
//        let path = UIBezierPath(rect: cornerBounds)
//        let cornerPath = UIBezierPath(roundedRect: cornerBounds, cornerRadius: radius)
////        path.append(cornerPath)
//        
//        let shapeLayer = CAShapeLayer()
//        shapeLayer.name = UIView.kCornerLayerName
//        shapeLayer.path = cornerPath.cgPath
//        shapeLayer.fillColor = bgColor.cgColor
////        shapeLayer.fillRule = kCAFillRuleEvenOdd
//        
//        if borderWidth != 0 && borderColor != nil {
////            let strokeInset = (borderWidth.rounded(.down)+0.5)
////            let strokeRect = cornerBounds.insetBy(dx: strokeInset, dy: strokeInset)
////            let strokeRadius = radius > scale/2 ? radius-scale/2 : 0
////            let path = UIBezierPath(roundedRect: strokeRect, byRoundingCorners: corners, cornerRadii: CGSize(width: strokeRadius, height: borderWidth))
////            path.close()
////            path.lineWidth = borderWidth
////            path.lineJoinStyle = borderLineJoin
////            borderColor?.setStroke()
////            path.stroke()
//
//        }
//        
////        if self is UILabel {
////            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: { 
////                self.layer.addSublayer(shapeLayer)
////                return
////            })
////        }
//        self.layer.addSublayer(shapeLayer)
//    }
    
    func bd_setCorner(radius: CGFloat) -> Void {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
//        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: radius, height: radius))
//        let maskLayer = CAShapeLayer()
//        maskLayer.frame = self.bounds
//        maskLayer.path = maskPath.cgPath
//        self.layer.mask = maskLayer
    }

    @IBInspectable
    
    var bd_cornerRadius: CGFloat {
        get {
          return 0
        }
        
        set {
            guard newValue != 0 else {
                return
            }
            bd_setCorner(radius: newValue)
        }
    }

    @IBInspectable
    
    /// 设置View的边框颜色
    /// SwifterSwift: Border color of view; also inspectable from Storyboard.
    var borderColor: UIColor? {
        get {
            guard let color = layer.borderColor else {
                return nil
            }
            return UIColor(cgColor: color)
        }
        set {
            guard let color = newValue else {
                layer.borderColor = nil
                return
            }
            layer.borderColor = color.cgColor
        }
    }
    
    @IBInspectable
    /// 设置变的宽度
    /// SwifterSwift: Border width of view; also inspectable from Storyboard.
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            
            layer.borderWidth = newValue
        }
    }
}
