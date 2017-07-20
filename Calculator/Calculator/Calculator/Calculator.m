//
//  Calculator.m
//  Calculator
//
//  Created by Iwaki Satoshi on 2017/07/19.
//  Copyright © 2017年 Satoshi Iwaki. All rights reserved.
//

#import "Calculator.h"

@implementation Calculator {
    NSNumberFormatter *_fomatter;
    NSDecimalNumber *_value1;
    NSDecimalNumber *_value2;
    CalculatorOperation _operation;
    NSMutableString *_inputString;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _fomatter = [[NSNumberFormatter alloc] init];
        _fomatter.numberStyle = NSNumberFormatterDecimalStyle;
        _operation = CalculatorOperationNone;
        _inputString = [[NSMutableString alloc] init];
    }
    return self;
}

- (BOOL)inputDigitByString:(NSString *)string {
    [_inputString appendString:string];
    return YES;
}

- (void)inputDecimalNumber:(NSDecimalNumber *)decimalNumber {
    if (_value1) {
        _value2 = decimalNumber;
    } else {
        _value1 = decimalNumber;
    }
}
- (void)inputOperation:(CalculatorOperation)operation {
    _operation = operation;
    [self inputDecimalNumber:[[NSDecimalNumber alloc] initWithString:_inputString]];
    [_inputString setString:@""];
}

- (NSDecimalNumber *)caluculate {
    [self inputDecimalNumber:[[NSDecimalNumber alloc] initWithString:_inputString]];
    NSDecimalNumber *result = NSDecimalNumber.notANumber;
    if (_value1 && _value2) {
        switch (_operation) {
            case CalculatorOperationAdding:
                result = [_value1 decimalNumberByAdding:_value2];
                break;
            case CalculatorOperationSubtracting:
                result = [_value1 decimalNumberByAdding:_value2];
                break;
            case CalculatorOperationMultiplying:
                result = [_value1 decimalNumberByMultiplyingBy:_value2];
                break;
            case CalculatorOperationDividing:
                result = [_value1 decimalNumberByDividingBy:_value2];
                break;
            default:
                break;
        }
    }
    _value1 = _value2;
    [_inputString setString:[_fomatter stringFromNumber:result]];
    return result;
}

- (NSString *)display {
    return [_inputString copy];
}

@end
