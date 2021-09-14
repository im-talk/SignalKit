//
//  SKSubscriber.h
//  SignalKit_Example
//
//  Created by xueqooy on 2021/9/3.
//  Copyright © 2021 xue03106991. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKDisposable.h"

NS_ASSUME_NONNULL_BEGIN

@interface SKSubscriber<__covariant ValueType, __covariant ErrorType> : NSObject <SKDisposable>

- (instancetype)initWithNext:(void (^_Nullable)(ValueType _Nullable value))next error:(void (^_Nullable)(ErrorType _Nullable error))error completed:(void (^_Nullable)(void))completed NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

- (void)putNext:(ValueType _Nullable)next;
- (void)putError:(ErrorType _Nullable)error;
- (void)putCompletion;

@end

NS_ASSUME_NONNULL_END
