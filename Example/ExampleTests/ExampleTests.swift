//
//  ExampleTests.swift
//  ExampleTests
//
//  Created by 诸葛游 on 2018/5/30.
//  Copyright © 2018年 品驰医疗. All rights reserved.
//

import XCTest
@testable import Example


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
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testUIViewNibInitalization() -> Void {
        let crv = TestCollectionReusableView.nib()
        print(crv)
    }
    
}

