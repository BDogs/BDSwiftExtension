//
//  ExampleTests.swift
//  ExampleTests
//
//  Created by 诸葛游 on 2018/5/30.
//  Copyright © 2018年 品驰医疗. All rights reserved.
//

import XCTest
@testable import Example
/*
 重要的事情说三遍 —— FIRST 原则：测试的最佳实践
 
 FIRST 是几个单词的缩写，简要描述了有效的单元测试需要什么条件，这些条件包括：
 
 Fast：测试的运行速度要快，这样人们就不介意你运行它们了。
 Independent/Isolated：一个测试不应当依赖于另一个测试。
 Repeatable：同一个测试，每次都应当获得相同的结果。外部数据提供者和并发问题会导致间歇性的出错。
 Self-validating：测试应当是完全自动化的，输出结果要么是 pass 要么是 fail，而不是依靠程序员对日志文件的解释。
 Timely：理想情况下，测试的编写，应当在编写要测试的产品代码之前。
 遵循 FIRST 原则会让你的测试清晰和有用，而不会成为 App 的渊薮。
 */

class ExampleTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.b
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        print(BD_SCREEN_WIDTH)

        print("12 2".trimmingCharacters(in: .whitespacesAndNewlines))

        print("12 3 ha 哈哈 👌".lengthOfBytes(using: .utf8))
        print("12 3 ha 哈哈 👌".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "")
        print(URL(string: "12 3 ha 哈👌".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!) ?? "")
        
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testUIViewNibInitalization() -> Void {
        measure {
            let crv = TestCollectionReusableView.nib()
            XCTAssertNotNil(crv)
        }
    }
    
}

