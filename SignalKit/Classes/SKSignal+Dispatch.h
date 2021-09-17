//
//  SKSignal+Dispatch.h
//  SignalKit_Example
//
//  Created by xueqooy on 2021/9/14.
//  Copyright © 2021 xue03106991. All rights reserved.
//

#import "SKSignal.h"
#import "SKQueue.h"
#import "SKThreadPool.h"

NS_ASSUME_NONNULL_BEGIN

@interface SKSignal<__covariant ValueType, __covariant ErrorType> (Dispatch)

- (SKSignal<ValueType, ErrorType> *)runOnQueue:(SKQueue *)queue;
- (SKSignal<ValueType, ErrorType> *)runOnThreadPool:(SKThreadPool *)threadPool;

- (SKSignal<ValueType, ErrorType> *)deliverOnQueue:(SKQueue *)queue;
- (SKSignal<ValueType, ErrorType> *)deliverOnMainQueue;
- (SKSignal<ValueType, ErrorType> *)deliverOnThreadPool:(SKThreadPool *)threadPool;

@end

NS_ASSUME_NONNULL_END
