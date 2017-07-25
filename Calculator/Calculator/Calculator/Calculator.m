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
    CalculatorOperator _operator;
    NSMutableString *_display;
    BOOL _needsResetDisplay;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _fomatter = [[NSNumberFormatter alloc] init];
        _fomatter.numberStyle = NSNumberFormatterDecimalStyle;
        _operator = CalculatorOperatorNone;
        _display = [[NSMutableString alloc] init];
    }
    return self;
}

- (BOOL)inputDigitByString:(NSString *)string {
    if (_needsResetDisplay) {
        _display = [@"" mutableCopy];
        _needsResetDisplay = NO;
    }
    [_display appendString:string];
    [self didChangeDisplay];
    return YES;
}

- (void)inputOperator:(CalculatorOperator)operator {
    _operator = operator;
    _value1 = [[NSDecimalNumber alloc] initWithString:_display];
    _needsResetDisplay = YES;
    [self didChangeDisplay];
}

- (void)reverseSign {
    if ([_display hasPrefix:@"-"]) {
        _display = [[_display stringByReplacingOccurrencesOfString:@"-" withString:@""] mutableCopy];
    } else {
        _display = [[@"-" stringByAppendingString:_display] mutableCopy];
    }
    [self didChangeDisplay];
}

- (void)clear {
    _value1 = nil;
    _value2 = nil;
    _display = [@"" mutableCopy];
    _operator = CalculatorOperatorNone;
    [self didChangeDisplay];
}

- (NSDecimalNumber *)caluculate {
    _value2 = [[NSDecimalNumber alloc] initWithString:_display];
    NSDecimalNumber *result = NSDecimalNumber.notANumber;
    if (_value1 && _value2) {
        switch (_operator) {
            case CalculatorOperatorAdding:
                result = [_value1 decimalNumberByAdding:_value2];
                break;
            case CalculatorOperatorSubtracting:
                result = [_value1 decimalNumberBySubtracting:_value2];
                break;
            case CalculatorOperatorMultiplying:
                result = [_value1 decimalNumberByMultiplyingBy:_value2];
                break;
            case CalculatorOperatorDividing:
                result = [_value1 decimalNumberByDividingBy:_value2];
                break;
            default:
                break;
        }
    }
    _value1 = result;
    _value2 = nil;
    _operator = CalculatorOperatorNone;
    [_display setString:[_fomatter stringFromNumber:result]];
    [self didChangeDisplay];
    return result;
}

- (NSString *)display {
    return [_display copy];
}

- (void)didChangeDisplay {
    if (self.delegate) {
        [self.delegate calculator:self didChangeDisplay:self.display];
    }
}

@end
