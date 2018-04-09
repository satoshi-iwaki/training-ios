//
//  CalculatorTests.swift
//  CalculatorTests
//
//  Created by Iwaki Satoshi on 2017/07/18.
//  Copyright © 2017年 Satoshi Iwaki. All rights reserved.
//

import XCTest
@testable import Calculator

class CalculatorTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAdding() {
        struct Parameter {
            let digits1: [String]
            let digits2: [String]
            let expect1: NSDecimalNumber
            let expect2: String
        }
        let parameters: [Parameter] = [
            Parameter(digits1: ["0"], digits2: ["0"], expect1: 0, expect2: "0"),
            Parameter(digits1: ["0"], digits2: ["1"], expect1: 1, expect2: "1"),
            Parameter(digits1: ["1"], digits2: ["0"], expect1: 1, expect2: "1"),
            Parameter(digits1: ["1"], digits2: ["2"], expect1: 3, expect2: "3"),
            Parameter(digits1: ["1", "2"], digits2: ["2", "3"], expect1: 35, expect2: "35"),
            ]
        for parameter in parameters {
            let calculator = Calculator()
            for digit1 in parameter.digits1 {
                calculator.inputDigit(by: digit1)
            }
            calculator.inputOperator(.adding)
            for digit2 in parameter.digits2 {
                calculator.inputDigit(by: digit2)
            }
            XCTAssertEqual(calculator.caluculate(), parameter.expect1)
            XCTAssertEqual(calculator.display, parameter.expect2)
        }
    }

    func testSubtracting() {
        let calculator = Calculator()
        calculator.inputDigit(by: "1")
        calculator.inputOperator(.subtracting)
        calculator.inputDigit(by: "2")
        XCTAssertEqual(calculator.caluculate(), -1)
        XCTAssertEqual(calculator.display, "-1")
    }

    
}
