//
//  Calculator.h
//  Calculator
//
//  Created by Iwaki Satoshi on 2017/07/19.
//  Copyright © 2017年 Satoshi Iwaki. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, CalculatorOperator) {
    CalculatorOperatorNone = 0,
    CalculatorOperatorAdding,
    CalculatorOperatorSubtracting,
    CalculatorOperatorMultiplying,
    CalculatorOperatorDividing,
};

@protocol CalculatorDelegate;

@interface Calculator : NSObject

@property (nonatomic, weak) id<CalculatorDelegate> delegate;
@property (nonatomic, readonly) CalculatorOperator operator;
@property (nonatomic, copy, readonly) NSString *display;

- (BOOL)inputDigitByString:(NSString *)string;
- (void)inputOperator:(CalculatorOperator)operator;
- (void)clear;
- (void)reverseSign;
- (NSDecimalNumber *)caluculate;

@end

@protocol CalculatorDelegate <NSObject>

- (void)calculator:(Calculator *)calculator didChangeDisplay:(NSString *)display;

@end


NS_ASSUME_NONNULL_END
