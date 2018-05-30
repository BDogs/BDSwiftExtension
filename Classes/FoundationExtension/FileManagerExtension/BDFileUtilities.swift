//
//  BDFileUtilities.swift
//  BDSwiftExtension
//
//  Created by 诸葛游 on 2017/3/29.
//  Copyright © 2017年 品驰医疗. All rights reserved.
//

import UIKit

public let BD_DocumentDirectory_Path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!


public class BDFileUtilities: NSObject {
    
    /// 将 data 保存到沙盒
    ///
    /// - Parameters:
    ///   - filePath: 文件完整路径
    ///   - data: 文件 data
    /// - Returns: 是否保存成功
    public class func saveDataToPath(filePath: String, data: Data) -> Bool {
        return FileManager.default.createFile(atPath: filePath, contents: data, attributes: nil)
    }
    
    /// 将 image 以 png 保存到沙盒 document 路径下
    /// 用于方便测试
    /// - Parameters:
    ///   - name: 图片文件名
    ///   - image: 要保存的 image
    /// - Returns: 是否保存成功
    public class func savePNGToDocumentDirectory(name: String, image: UIImage) -> Bool {
        let filePath = BD_DocumentDirectory_Path.appendingFormat("/%@.png", name)
        return saveDataToPath(filePath: filePath, data: UIImagePNGRepresentation(image)!)
    }
    
    public static func prepareForSave(path: String) -> Void {
        if !FileManager.default.fileExists(atPath: path) {
            do {
                try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            } catch let error as NSError {
                print(error)
            }
        }
    }
}



extension NSArray {
    public func save(to path: String) -> Bool {
        let floderPath = (path as NSString).deletingLastPathComponent
        BDFileUtilities.prepareForSave(path: floderPath)
        let flag = self.write(toFile: path, atomically: true)
        return flag
    }
}

extension NSDictionary {
    public func save(to path: String) -> Bool {
        let floderPath = (path as NSString).deletingLastPathComponent
        
        BDFileUtilities.prepareForSave(path: floderPath)
        let flag = self.write(toFile: path, atomically: true)
        return flag
    }
}


extension Dictionary {
    public func save(to path: String) -> Bool {
        let dic = self as NSDictionary
        return dic.save(to: path)
    }
    
//    static public func contentsOfFile(path: String) -> Dictionary? {
//        guard let dic = NSDictionary(contentsOfFile: path) else { return nil }
//        return dic as? Dictionary
//    }
}

extension Array {
    public func  save(to path: String) -> Bool {
        let dic = self as NSArray
        return dic.save(to: path)
    }
    
//    static public func contentsOfFile(path: String) -> Array? {
//        guard let dic = NSArray(contentsOfFile: path) else { return nil }
//        return dic as? Array
//    }
//

}

