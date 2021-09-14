//
//  SKSignal+Single.h
//  SignalKit_Example
//
//  Created by xueqooy on 2021/9/11.
//  Copyright © 2021 xue03106991. All rights reserved.
//

#import "SKSignal.h"

NS_ASSUME_NONNULL_BEGIN

@interface SKSignal<__covariant ValueType, __covariant ErrorType> (Single)

+ (SKSignal<ValueType, NoError> *)single:(ValueType _Nullable)value;
+ (SKSignal<NoValue, ErrorType> *)fail:(ErrorType _Nullable)error;
+ (SKSignal<NoValue, NoError> *)never;
+ (SKSignal<NoValue, NoError> *)complete;

@end

NS_ASSUME_NONNULL_END
