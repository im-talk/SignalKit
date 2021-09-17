//
//  SKBlockDisposable.h
//  SignalKit
//
//  Created by xueqooy on 2021/9/4.
//  Copyright © 2021 xue03106991. All rights reserved.
//

#import "SKDisposable.h"

NS_ASSUME_NONNULL_BEGIN

@interface SKBlockDisposable : NSObject<SKDisposable>

+ (instancetype)disposableWithBlock:(void (^)(void))block;

- (instancetype)initWithBlock:(void (^)(void))block NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
