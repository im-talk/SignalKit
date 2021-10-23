//
//  SKSignal+Catch.h
//  SignalKit_Example
//
//  Created by xueqooy on 2021/9/18.
//  Copyright © 2021 xue03106991. All rights reserved.
//

#import "SKSignal.h"
#import "SKQueue.h"

NS_ASSUME_NONNULL_BEGIN

@interface SKSignal<__covariant ValueType, __covariant ErrorType> (Catch)

- (SKSignal *)catch:(SKSignal * (^)(ErrorType error))block;
- (SKSignal *)catchToSignal:(SKSignal *)signal;

- (SKSignal<ValueType, ErrorType> *)retry:(NSUInteger)retryCount;
- (SKSignal<ValueType, ErrorType> *)retry:(NSUInteger)retryCount delayIncrement:(NSTimeInterval)delayIncrement maxDelay:(NSTimeInterval)maxDelay onQueue:(SKQueue *)queue;

- (SKSignal<ValueType, ErrorType> *)retryIf:(BOOL (^)(ErrorType _Nullable error, NSUInteger currentRetryCount))predicate;
- (SKSignal<ValueType, ErrorType> *)retryIf:(BOOL (^)(ErrorType _Nullable error, NSUInteger currentRetryCount))predicate delayIncrement:(NSTimeInterval)delayIncrement maxDelay:(NSTimeInterval)maxDelay onQueue:(SKQueue *)queue;


@end  

NS_ASSUME_NONNULL_END
