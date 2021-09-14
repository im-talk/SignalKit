//
//  SKSignal+Mapping.h
//  SignalKit
//
//  Created by xueqooy on 2021/9/4.
//  Copyright © 2021 xue03106991. All rights reserved.
//

#import "SKSignal.h"

NS_ASSUME_NONNULL_BEGIN

@interface SKSignal<__covariant ValueType, __covariant ErrorType> (Mapping)

- (SKSignal<id, ErrorType> *)map:(id _Nullable (^)(ValueType _Nullable value))block;

- (SKSignal<ValueType, id> *)mapError:(id _Nullable (^)(ErrorType _Nullable error))block;

- (SKSignal<ValueType, ErrorType> *)filter:(BOOL (^)(ValueType _Nullable value))block;

- (SKSignal<ValueType, ErrorType> *)distinctUntilChanged;

- (SKSignal<ValueType, ErrorType> *)distinctUntilChangedWithBlock:(BOOL (^)(id _Nullable value, id _Nullable lastValue))block;


@end

NS_ASSUME_NONNULL_END
