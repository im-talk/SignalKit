//
//  SKSignal+SideEffects.h
//  SignalKit_Example
//
//  Created by xueqooy on 2021/9/11.
//  Copyright © 2021 xue03106991. All rights reserved.
//

#import "SKSignal.h"

NS_ASSUME_NONNULL_BEGIN

@interface SKSignal<__covariant ValueType, __covariant ErrorType> (SideEffects)

- (SKSignal<ValueType, ErrorType> *)onStart:(void (^)(void))block;
- (SKSignal<ValueType, ErrorType> *)onNext:(void (^)(ValueType _Nullable value))block;
- (SKSignal<ValueType, ErrorType> *)afterNext:(void (^)(ValueType _Nullable value))block;
- (SKSignal<ValueType, ErrorType> *)onError:(void (^)(ErrorType _Nullable error))block;
- (SKSignal<ValueType, ErrorType> *)afterError:(void (^)(ErrorType _Nullable error))block;
- (SKSignal<ValueType, ErrorType> *)onCompletion:(void (^)(void))block;
- (SKSignal<ValueType, ErrorType> *)afterCompletion:(void (^)(void))block;
- (SKSignal<ValueType, ErrorType> *)onDispose:(void (^)(void))block;

@end

NS_ASSUME_NONNULL_END
