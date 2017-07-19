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

- (nullable NSDecimalNumber *)caluculateWithOperation:(CalculatorOperation)operation
                                               value1:(NSNumber *)value1
                                               value2:(NSNumber *)value2;

@end

NS_ASSUME_NONNULL_END
