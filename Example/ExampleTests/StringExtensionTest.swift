//
//  StringExtensionTest.swift
//  ExampleTests
//
//  Created by 诸葛游 on 2018/6/4.
//  Copyright © 2018年 品驰医疗. All rights reserved.
//

import UIKit
import XCTest
@testable import Example

class StringExtensionTest: XCTestCase {

    
    func testStringByRemovedWhitespacesAndNewlines() -> Void {
        var str = " 2 123 \n"
        str = str.stringByRemovedWhitespacesAndNewlines()
        
        print(str)
    }
    
    func testSubscript() -> Void {
        let temp = "hello world"
        XCTAssertNotNil(temp[1], "")
        XCTAssert(temp[1] == "e")
        XCTAssertNotNil(temp[1...2], "")
        XCTAssert(temp[1...2] == "el")
        XCTAssertNotNil(temp[1..<3], "")
        XCTAssert(temp[1..<3] == "el")
    }
    
    func testCommonSuffix() -> Void {
        let temp = "hello boy!"
        let result1 = temp.commonSuffix(with: "good boy!")
        let result2 = temp.commonSuffix(with: "boy")
        
        XCTAssert(result1 == " boy!")
        XCTAssert(result2.isEmpty)
    }
    
    func testBase64() -> Void {
        let temp = "Hello World!"
        let encoded = temp.base64
        XCTAssertNotNil(encoded, "")
        XCTAssert(encoded == "SGVsbG8gV29ybGQh")
        let decocded = String(base64: encoded!)
        XCTAssertNotNil(decocded, "")
        XCTAssert(decocded == temp)
    }
    
    func testVar_Number() -> Void {
        let s1 = "12"
        let s2 = "12.34"
        let s3 = "-0xFF"
        let s4 = ".23e99"

        print(s1.number ?? 0)
        print(s2.number ?? 0)
        print(s3.number ?? 0)
        print(s4.number ?? 0)
        
        print(s1.number?.intValue ?? 0)
        print(s2.number?.intValue ?? 0)
        print(s3.number?.intValue ?? 0)
        print(s4.number?.intValue ?? 0)
    }
    
}
