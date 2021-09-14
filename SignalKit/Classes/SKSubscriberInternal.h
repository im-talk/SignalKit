//
//  SKSubscriberInternal.h
//  SignalKit_Example
//
//  Created by xueqooy on 2021/9/3.
//  Copyright © 2021 xue03106991. All rights reserved.
//

#import "SKSubscriber.h"

NS_ASSUME_NONNULL_BEGIN

@interface SKSubscriber ()

- (void)assignDisposable:(id<SKDisposable>)disposable;
- (void)markTerminatedWithoutDisposal;

@end

NS_ASSUME_NONNULL_END
