//
//  UIImage+Modify.swift
//  BDSwiftExtension
//
//  Created by 诸葛游 on 2017/3/27.
//  Copyright © 2017年 品驰医疗. All rights reserved.
//  Decription 图片的圆角、旋转和剪切等修改

import Foundation
import UIKit
import CoreGraphics
import Accelerate


/// 将角度转为弧度
///
/// - Parameter degrees: 角度
/// - Returns: 弧度
public func bd_degreesToRadians(degrees: CGFloat) -> CGFloat {
    return degrees*CGFloat.pi/180
}

extension UIImage {
    
    /// Draws the entire image in the specified rectangle, content changed with the contentMode.
    ///
    /// This method draws the entire image in the current graphics context,
    /// respecting the image's orientation setting. In the default coordinate system,
    /// images are situated down and to the right of the origin of the specified
    /// rectangle. This method respects any transforms applied to the current graphics
    /// context, however.
    ///
    /// - Parameters:
    ///   - rect: The rectangle in which to draw the image.
    ///   - contentMode: Draw content mode.
    ///   - clipsToBounds: A Boolean value that determines whether content are confined to the rect.
    
    public func bd_drawInRect(rect: CGRect, contentMode: UIView.ContentMode, clipsToBounds: Bool) -> Void {
        let drawRect = bd_CGRectFitWithContentMode(rect: rect, size: self.size, mode: contentMode)
        guard drawRect.width == 0 || drawRect.height == 0 else {
            return
        }
        
        if clipsToBounds {
            let context = UIGraphicsGetCurrentContext()
            if context != nil {
                context?.saveGState()
                context?.addRect(rect)
                context?.clip()
                self.draw(in: drawRect)
                context?.restoreGState()
            }
        } else {
            self.draw(in: drawRect)
        }
    }
    
    
    /// Resize rect to fit the size using a given contentMode.
    ///
    /// - Parameters:
    ///   - rect: The draw rect
    ///   - size: The original content size
    ///   - mode: The content mode
    /// - Returns: A resized rect for the given content mode.
    /// - Discussions: UIViewContentModeRedraw is same as UIViewContentModeScaleToFill.
    public func bd_CGRectFitWithContentMode(rect: CGRect, size: CGSize, mode: UIView.ContentMode) -> CGRect {
        var contentRect = rect.standardized
        let originalSize = size.standardized()
        let centerP = CGPoint(x: contentRect.midX, y: contentRect.midY)
        
        switch mode {
        case .scaleAspectFit,
             .scaleAspectFill:
            if contentRect.width < 0.01 || contentRect.height < 0.01 || originalSize.width < 0.01 || originalSize.height < 0.01 {
                contentRect.origin = centerP
                contentRect.size = CGSize.zero
            } else {
                var scale: CGFloat?
                let originalRatio: CGFloat = originalSize.width/originalSize.height
                let contentRatio: CGFloat = contentRect.width/contentRect.height
                if mode == .scaleAspectFit {
                    scale = originalRatio<contentRatio ?contentRect.height/originalSize.height: contentRect.width/originalSize.width
                } else {
                    scale = originalRatio<contentRatio ?contentRect.width/originalSize.width: contentRect.height/originalSize.height
                }
                
                let newWidth = originalSize.width*scale!
                let newHeight = originalSize.height*scale!
                contentRect = CGRect(x: centerP.x-newWidth*0.5, y: centerP.y-newHeight*0.5, width: newWidth, height: newHeight)
                
            }
            break
            
        case .center:
            contentRect.size = originalSize
            contentRect.origin = CGPoint(x: centerP.x-originalSize.width*0.5, y: centerP.y-originalSize.height*0.5)
            break
            
        case .top:
            contentRect.origin.x = centerP.x-originalSize.width*0.5
            contentRect.size = originalSize
            break
        
        case .bottom:
            contentRect.origin.x = centerP.x-originalSize.width*0.5
            contentRect.origin.y += contentRect.height-originalSize.height
            contentRect.size = originalSize
            break
        
        case .left:
            contentRect.origin.y = centerP.y-originalSize.height*0.5
            contentRect.size = originalSize
            break
        
        case .right:
            contentRect.origin.y = centerP.y-originalSize.height*0.5
            contentRect.origin.x += contentRect.width-originalSize.width
            contentRect.size = originalSize
        case .topRight:
            contentRect.origin.x += contentRect.width-originalSize.width
            contentRect.size = originalSize
            break
        case .topLeft:
            contentRect.size = originalSize
            break
        case .bottomLeft:
            contentRect.origin.y += contentRect.height-originalSize.height
            contentRect.size = originalSize
            break
        case .bottomRight:
            contentRect.origin.y += contentRect.height-originalSize.height
            contentRect.origin.x += contentRect.width-originalSize.width
            contentRect.size = originalSize
            break
        case .scaleToFill, .redraw:
            break
        @unknown default:
            break
        }
        
        return contentRect
    }
    
    /// Returns a new image which is scaled from this image. The image will be stretched as needed.
    ///
    /// - Parameter size: The new size to be scaled, values should be positive.
    /// - Returns: The new image with the given size.
    public func bd_imageByResize(toSize size: CGSize) -> UIImage? {
        guard size.isStandardized() else {
            return nil
        }
        
        UIGraphicsBeginImageContextWithOptions(size, false, self.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    /// Returns a new image which is scaled from this image.
    ///
    /// - Parameters:
    ///   - size: The new size to be scaled, values should be positive.
    ///   - contentMode: The content mode for image content.
    /// - Returns: The new image with the given size.
    public func bd_imageByResize(toSize size: CGSize, contentMode: UIView.ContentMode) -> UIImage? {
        guard size.isStandardized() else {
            return nil
        }
        
        UIGraphicsBeginImageContextWithOptions(size, false, self.scale)
        bd_drawInRect(rect: CGRect(origin: CGPoint.zero, size: size), contentMode: contentMode, clipsToBounds: false)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    /// Returns a new image which is cropped from this image.
    ///
    /// - Parameter rect: Image's inner rect.
    /// - Returns: The new image, or nil if an error occurs.
    public func bd_imageByCropToRect(rect: CGRect) -> UIImage? {
        let newRect = CGRect(x: rect.minX*self.scale, y: rect.minY*self.scale, width: rect.width*self.scale, height: rect.height*self.scale)
        guard newRect.size.isStandardized() else {
            return nil
        }
        // TODO: 这里要验证下 直接使用这个方法
        let imageRef = self.cgImage?.cropping(to: newRect)
        let image = UIImage(cgImage: imageRef!, scale: self.scale, orientation: self.imageOrientation)
        // TODO: 这里要验证下 是否需要 release
        return image
    }
    
    /// Returns a new image which is edge inset from this image.
    ///
    /// - Parameters:
    ///   - insets: Inset (positive) for each of the edges, values can be negative to 'outset'.
    ///   - fillColor: Extend edge's fill color, nil means clear color.
    /// - Returns: The new image, or nil if an error occurs.
    public func bd_imageByInsetEdge(insets: UIEdgeInsets, fillColor: UIColor?) -> UIImage? {
        var imageSize = self.size
        imageSize.width -= insets.left + insets.right
        imageSize.height -= insets.top + insets.top
        
        guard size.isStandardized() else {
            return nil
        }
    
        let outerRect = CGRect(origin: CGPoint.zero, size: imageSize)
        let innerInsets = UIEdgeInsets.init(top: abs(insets.top), left: abs(insets.left), bottom: abs(insets.bottom), right: abs(insets.right))
        let innerRect = outerRect.inset(by: innerInsets)
        // 画布大小决定 image 的大小
        UIGraphicsBeginImageContextWithOptions(imageSize, false, self.scale)
        let context = UIGraphicsGetCurrentContext()
        
        if fillColor != nil {
            context?.setFillColor((fillColor?.cgColor)!)
            let path = CGMutablePath.init()
            path.addRect(outerRect)
            path.addRect(innerRect)
            context?.addPath(path)
            context?.fillPath(using: .evenOdd)
        }
        // 画边框 所以得用 newRect
        self.draw(in: innerRect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }
    
    
    /// Rounds a new image with a given corner size.
    ///
    /// - Parameters:
    ///   - radius: The radius of each corner oval. Values larger than half the
    ///             rectangle's width or height are clamped appropriately to
    ///             half the width or height.
    ///   - corners: A bitmask value that identifies the corners that you want
    ///              rounded. You can use this parameter to round only a subset
    ///              of the corners of the rectangle.
    ///   - borderWidth: The inset border line width. Values larger than half the rectangle's
    ///                  width or height are clamped appropriately to half the width
    ///                  or height.
    ///   - borderColor: The border stroke color. nil means clear color.
    ///   - borderLineJoin: The border line join.
    /// - Returns: A round corner image
    public func bd_roundCornerImage(radius: CGFloat, corners: UIRectCorner = .allCorners, borderWidth: CGFloat = 0, borderColor: UIColor?, borderLineJoin: CGLineJoin = .round) -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let context = UIGraphicsGetCurrentContext()
        let rect = CGRect(origin: CGPoint.zero, size: size)
        context?.scaleBy(x: 1, y: -1)
        context?.translateBy(x: 0, y: -rect.height)
        
        let minSize = min(size.width, size.height)
        // 绘制 image 的圆角
        if borderWidth < minSize/2 {
            let path = UIBezierPath(roundedRect: rect.insetBy(dx: borderWidth, dy: borderWidth), byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: borderWidth))
            path.close()
            context?.saveGState()
            path.addClip()
            context?.draw(cgImage!, in: rect)
            context?.restoreGState()
        }
        // 绘制边框
        if ((borderColor != nil) && borderWidth < minSize / 2 && borderWidth > 0) {
            let strokeInset = ((borderWidth*scale).rounded(.down)+0.5)/scale
            let strokeRect = rect.insetBy(dx: strokeInset, dy: strokeInset)
            let strokeRadius = radius > scale/2 ? radius-scale/2 : 0
            let path = UIBezierPath(roundedRect: strokeRect, byRoundingCorners: corners, cornerRadii: CGSize(width: strokeRadius, height: borderWidth))
            path.close()
            path.lineWidth = borderWidth
            path.lineJoinStyle = borderLineJoin
            borderColor?.setStroke()
            path.stroke()
        }
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    /// 以一定的角度旋转图片
    ///
    /// - Parameters:
    ///   - radians: 在 iOS 中，正值为逆时针，负值为顺时针；在 macOS 中，正值是顺时针，负值是逆时针
    ///   - fitSize: true 图片的尺寸为包含图片的最小矩形
    ///              false 图片尺寸不变，多余部分会被剪切掉
    /// - Returns: 返回一个旋转后的图片
    public func bd_imageByRotate(degrees: CGFloat, fitSize: Bool = true) -> UIImage? {
        let radians = bd_degreesToRadians(degrees: degrees)
        let width = self.cgImage?.width
        let height = self.cgImage?.height
        let orignalRect = CGRect(x: 0, y: 0, width: width!, height: height!)
        let newRect = orignalRect.applying(fitSize ? CGAffineTransform(rotationAngle: radians): CGAffineTransform.identity)
        // TODO: 这里要验证下 是否需要 colorSpace release
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext.init(data: nil, width: Int(newRect.width), height: Int(newRect.height), bitsPerComponent: 8, bytesPerRow: Int(newRect.width)*4, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue)
        
        if context == nil {
            return nil
        }
        
        // 设置抗锯齿
        context?.setAllowsAntialiasing(true)
        context?.setShouldAntialias(true)
        // 设置插值图像质量
        context?.interpolationQuality = .high
        // 旋转
        context?.translateBy(x: newRect.width*0.5, y: newRect.height*0.5)
        context?.rotate(by: radians)
        // 绘制图片
        context?.draw(self.cgImage!, in: CGRect(x: -Int((Double(width!)*0.5)), y: -Int((Double(height!)*0.5)), width: width!, height: height!))
        let imgRef = context?.makeImage()
        let image = UIImage(cgImage: imgRef!, scale: scale, orientation: imageOrientation)
        return image
    }
    
    
    /// 翻转图片
    ///
    /// - Parameters:
    ///   - horizontal: 水平是否翻转
    ///   - vertical: 垂直是否翻转
    /// - Returns: 翻转后的图片
    public func bd_imageByFlip(horizontal: Bool, vertical: Bool) -> UIImage? {
        guard self.cgImage != nil else {
            return nil
        }
        
        let width = self.cgImage?.width
        let height = self.cgImage?.height
        let bytesPerRow = width!*4
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext.init(data: nil, width: width!, height: height!, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue)
        
        if context == nil {
            return nil
        }
        
        context?.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: width!, height: height!))
        let data = context?.data
        if data == nil {
            return nil
        }
        
        var src = vImage_Buffer.init(data: data, height: vImagePixelCount(height!), width: vImagePixelCount(width!), rowBytes: bytesPerRow)
        var dest = vImage_Buffer.init(data: data, height: vImagePixelCount(height!), width: vImagePixelCount(width!), rowBytes: bytesPerRow)
        
        if vertical {
            vImageVerticalReflect_ARGB8888(&src, &dest, vImage_Flags(kvImageBackgroundColorFill))
        }
        
        if horizontal {
            vImageHorizontalReflect_ARGB8888(&src, &dest, vImage_Flags(kvImageBackgroundColorFill))
        }
        
        let imageRef = context?.makeImage()
        let image = UIImage(cgImage: imageRef!, scale: scale, orientation: imageOrientation)
        
        return image
    }
    
}

