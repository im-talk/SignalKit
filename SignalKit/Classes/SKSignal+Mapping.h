//
//  SKSignal+Mapping.h
//  SignalKit
//
//  Created by xueqooy on 2021/9/4.
//  Copyright © 2021 xue03106991. All rights reserved.
//

#import "SKSignal.h"
#import "SKAnnotations.h"

NS_ASSUME_NONNULL_BEGIN

@interface SKSignal<__covariant ValueType, __covariant ErrorType> (Mapping)

- (SKSignal<id, ErrorType> *)map:(id _Nullable (^)(ValueType _Nullable value))block SK_WARN_UNUSED_RESULT;

- (SKSignal<ValueType, id> *)mapError:(id _Nullable (^)(ErrorType _Nullable error))block SK_WARN_UNUSED_RESULT;

- (SKSignal<ValueType, ErrorType> *)filter:(BOOL (^)(ValueType _Nullable value))block SK_WARN_UNUSED_RESULT;

- (SKSignal<ValueType, ErrorType> *)distinctUntilChanged SK_WARN_UNUSED_RESULT;

- (SKSignal<ValueType, ErrorType> *)distinctUntilChangedWithBlock:(BOOL (^)(id _Nullable value, id _Nullable lastValue))block SK_WARN_UNUSED_RESULT;


@end

NS_ASSUME_NONNULL_END
