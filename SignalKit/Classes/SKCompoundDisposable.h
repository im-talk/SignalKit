//
//  SKCompoundDisposable.h
//  SignalKit_Example
//
//  Created by xueqooy on 2021/9/11.
//  Copyright © 2021 xue03106991. All rights reserved.
//

#import "SKDisposable.h"

NS_ASSUME_NONNULL_BEGIN

@interface SKCompoundDisposable : NSObject<SKDisposable>

- (void)addDisposable:(id<SKDisposable> _Nullable)disposable;
- (void)removeDisposable:(id<SKDisposable> _Nullable)disposable;

@end

NS_ASSUME_NONNULL_END
