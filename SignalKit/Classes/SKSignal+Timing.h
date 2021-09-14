//
//  SKSignal+Timing.h
//  SignalKit_Example
//
//  Created by xueqooy on 2021/9/14.
//  Copyright © 2021 xue03106991. All rights reserved.
//

#import "SKSignal.h"
#import "SKQueue.h"

NS_ASSUME_NONNULL_BEGIN

@interface SKSignal<__covariant ValueType, __covariant ErrorType> (Timing)

- (SKSignal<ValueType, ErrorType> *)delay:(NSTimeInterval)seconds onQueue:(SKQueue *_Nullable)queue;

@end

NS_ASSUME_NONNULL_END
