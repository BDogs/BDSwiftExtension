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
    
}
