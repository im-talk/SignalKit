//
//  SKSignal+SideEffects.h
//  SignalKit_Example
//
//  Created by xueqooy on 2021/9/11.
//  Copyright © 2021 xue03106991. All rights reserved.
//

#import "SKSignal.h"
#import "SKAnnotations.h"

NS_ASSUME_NONNULL_BEGIN

@interface SKSignal<__covariant ValueType, __covariant ErrorType> (SideEffects)

- (SKSignal<ValueType, ErrorType> *)onStart:(void (^)(void))block SK_WARN_UNUSED_RESULT;
- (SKSignal<ValueType, ErrorType> *)onNext:(void (^)(ValueType _Nullable value))block SK_WARN_UNUSED_RESULT;
- (SKSignal<ValueType, ErrorType> *)afterNext:(void (^)(ValueType _Nullable value))block SK_WARN_UNUSED_RESULT;
- (SKSignal<ValueType, ErrorType> *)onError:(void (^)(ErrorType _Nullable error))block SK_WARN_UNUSED_RESULT;
- (SKSignal<ValueType, ErrorType> *)afterError:(void (^)(ErrorType _Nullable error))block SK_WARN_UNUSED_RESULT;
- (SKSignal<ValueType, ErrorType> *)onCompletion:(void (^)(void))block SK_WARN_UNUSED_RESULT;
- (SKSignal<ValueType, ErrorType> *)afterCompletion:(void (^)(void))block SK_WARN_UNUSED_RESULT;
- (SKSignal<ValueType, ErrorType> *)onDispose:(void (^)(void))block SK_WARN_UNUSED_RESULT;

@end

NS_ASSUME_NONNULL_END
