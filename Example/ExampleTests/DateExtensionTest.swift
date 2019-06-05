//
//  DateExtensionTest.swift
//  ExampleTests
//
//  Created by 诸葛游 on 2018/9/5.
//  Copyright © 2018年 品驰医疗. All rights reserved.
//

import UIKit
import XCTest
@testable import Example

class DateExtensionTest: XCTestCase {

    func test() {
        print(Date().string(format: "yyyy-MM-dd HH:mm:ss"))
        print(Date(hour: 16).string(format: "yyyy-MM-dd HH:mm:ss"))
        
    }
    
    func testNestestMinute() -> Void {
        let now = Date()
        print(now.nearest(minutes: 5)?.string(format: "yyyy-MM-dd HH:mm:ss"))
        print(now.nearest(minutes: 10)?.string(format: "yyyy-MM-dd HH:mm:ss"))
        print(now.nearest(minutes: 30)?.string(format: "yyyy-MM-dd HH:mm:ss"))
        print(now.nearest(minutes: 60)?.string(format: "yyyy-MM-dd HH:mm:ss"))


    }
}
