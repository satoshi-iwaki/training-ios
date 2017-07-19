//
//  Calculator.m
//  Calculator
//
//  Created by Iwaki Satoshi on 2017/07/19.
//  Copyright © 2017年 Satoshi Iwaki. All rights reserved.
//

#import "Calculator.h"

@implementation Calculator

- (nullable NSDecimalNumber *)caluculateWithOperation:(CalculatorOperation)operation
                                               value1:(NSDecimalNumber *)value1
                                               value2:(NSDecimalNumber *)value2 {
    switch (operation) {
        case CalculatorOperationAdding:
            return [value1 decimalNumberByAdding:value2];
        case CalculatorOperationSubtracting:
            return [value1 decimalNumberByAdding:value2];
        case CalculatorOperationMultiplying:
            return [value1 decimalNumberByMultiplyingBy:value2];
        case CalculatorOperationDividing:
            return [value1 decimalNumberByDividingBy:value2];
        default:
            break;
    }
    return nil;
}
@end
