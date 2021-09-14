//
//  SKSignal.h
//  SignalKit
//
//  Created by xueqooy on 2021/9/3.
//  Copyright © 2021 xue03106991. All rights reserved.
//

#import "SKSubscriber.h"

NS_ASSUME_NONNULL_BEGIN

typedef id NoValue;
typedef id NoError;

@interface SKSignal<__covariant ValueType, __covariant ErrorType> : NSObject

- (instancetype)initWithGenerator:(id<SKDisposable>_Nullable (^)(SKSubscriber *subscriber))generator NS_DESIGNATED_INITIALIZER;

+ (instancetype)signalWithGenerator:(id<SKDisposable>_Nullable (^)(SKSubscriber *subscriber))generator;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

- (id<SKDisposable> _Nullable)startWithNext:(void (^)(ValueType _Nullable value))next;
- (id<SKDisposable> _Nullable)startWithError:(void (^)(ErrorType _Nullable error))error;
- (id<SKDisposable> _Nullable)startWithCompleted:(void (^)(void))completed;
- (id<SKDisposable> _Nullable)startWithNext:(void (^)(ValueType _Nullable value))next error:(void (^)(ErrorType _Nullable error))error;
- (id<SKDisposable> _Nullable)startWithNext:(void (^)(ValueType _Nullable value))next completed:(void (^)(void))completed;
- (id<SKDisposable> _Nullable)startWithError:(void (^)(ErrorType _Nullable error))error completed:(void (^)(void))completed;
- (id<SKDisposable> _Nullable)startWithNext:(void (^)(ValueType _Nullable value))next error:(void (^)(ErrorType _Nullable error))error completed:(void (^)(void))completed;

@end

NS_ASSUME_NONNULL_END
