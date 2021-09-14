//
//  SKAtomic.h
//  SignalKit_Example
//
//  Created by xueqooy on 2021/9/11.
//  Copyright © 2021 xue03106991. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKAnnotations.h"

NS_ASSUME_NONNULL_BEGIN

@interface SKAtomic<__covariant ValueType> : NSObject

@property (nonatomic, nullable, readonly) ValueType value;

- (instancetype)initWithValue:(ValueType _Nullable)value NS_DESIGNATED_INITIALIZER;

+ (instancetype)atomicWithValue:(ValueType _Nullable)value;

- (ValueType _Nullable)swap:(ValueType _Nullable)newValue SK_WARN_UNUSED_RESULT;
- (ValueType _Nullable)modify:(id _Nullable (^)(ValueType _Nullable value))block SK_WARN_UNUSED_RESULT;
- (id _Nullable)with:(id _Nullable (^)(ValueType _Nullable value))block SK_WARN_UNUSED_RESULT;

@end

NS_ASSUME_NONNULL_END
