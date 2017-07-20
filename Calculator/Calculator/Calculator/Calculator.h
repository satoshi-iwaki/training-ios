//
//  Calculator.h
//  Calculator
//
//  Created by Iwaki Satoshi on 2017/07/19.
//  Copyright © 2017年 Satoshi Iwaki. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, CalculatorOperation) {
    CalculatorOperationNone = 0,
    CalculatorOperationAdding,
    CalculatorOperationSubtracting,
    CalculatorOperationMultiplying,
    CalculatorOperationDividing,
};

@interface Calculator : NSObject

- (BOOL)inputDigitByString:(NSString *)string;
- (void)inputOperation:(CalculatorOperation)operation;
- (NSDecimalNumber *)caluculate;
- (NSString *)display;

@end

NS_ASSUME_NONNULL_END
