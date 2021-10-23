//
//  SKSignal+Meta.h
//  SignalKit_Example
//
//  Created by mac on 2021/10/18.
//  Copyright © 2021 xue03106991. All rights reserved.
//

#import <SignalKit/SignalKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SKSignal<__covariant ValueType, __covariant ErrorType> (Meta)

- (SKSignal<ValueType, ErrorType> *)switchToLatest;

+ (SKSignal<ValueType, ErrorType> *)defer:(SKSignal<ValueType, ErrorType> *(^)(void))block;

@end

NS_ASSUME_NONNULL_END
