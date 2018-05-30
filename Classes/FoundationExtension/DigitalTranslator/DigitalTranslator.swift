//
//  DigitalTranslator.swift
//  PinsLife
//
//  Created by 诸葛游 on 2017/7/18.
//  Copyright © 2017年 品驰医疗. All rights reserved.
//

import UIKit

public class DigitalTranslator: NSObject {

    public static func translateUInt8IntoInt(byte: UInt8) -> Int {
        
        let temp: [UInt8] = [0, 0, 0, byte]
        var value : Int = 0
        for byte in temp {
            value = value << 8
            value = value | Int(byte)
        }
        return value
    }
    
    public static func translateLHBytesIntoUInt(bytes: ArraySlice<UInt8>) -> UInt {
        var value: UInt = 0
        for byte in bytes.reversed() {
            value = value << 8
            value = value | UInt(byte)
        }
        return value
    }
    
    public static func translateMinuteToTimeDescription(minute: UInt) -> String {
        if minute <= 0 {
            return "1分钟内"
        }
        var des = ""
        if minute % 60 != 0 {
            des = des + "\(minute % 60)" + "分钟"
        }
        if minute < 60 {
            return des
        }
        let h = minute / 60
        if h % 24 != 0 {
            des = "\(h % 24)" + "小时" + des
        }
        if h < 24 {
            return des
        }
        let d = h / 24
        if d > 10 {  //超过10天不显示小时了
            des = "\(d)" + "天"
        } else {
            des = "\(d)" + "天" + des
        }
        return des
    }

    
}
