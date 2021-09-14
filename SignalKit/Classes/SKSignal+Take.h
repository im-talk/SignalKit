//
//  SKSignal+Take.h
//  SignalKit_Example
//
//  Created by mac on 2021/9/14.
//  Copyright © 2021 xue03106991. All rights reserved.
//

#import "SKSignal.h"

NS_ASSUME_NONNULL_BEGIN

@interface SKSignalTakeAction : NSObject

@property (nonatomic) BOOL passthrough;
@property (nonatomic) BOOL complete;

+ (instancetype)actionWithPassthrough:(BOOL)passthrough complete:(BOOL)complete;

@end

@interface SKSignal<__covariant ValueType, __covariant ErrorType> (Take)

- (SKSignal<ValueType, ErrorType> *)take:(NSUInteger)count;
- (SKSignal<ValueType, ErrorType> *)takeLast;
- (SKSignal<ValueType, ErrorType> *)takeWhile:(SKSignalTakeAction * (^)(ValueType _Nullable value))predicate;

@end

NS_ASSUME_NONNULL_END
