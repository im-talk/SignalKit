//
//  SKPipe.h
//  SignalKit_Example
//
//  Created by xueqooy on 2021/9/11.
//  Copyright © 2021 xue03106991. All rights reserved.
//

#import "SKSignal.h"

NS_ASSUME_NONNULL_BEGIN

@interface SKPipe<__covariant ValueType> : NSObject

- (SKSignal<ValueType, NoError> *)signal;

- (SKSignal<ValueType, NoError> *)signalWithReplay;

- (void)sink:(ValueType _Nullable)value;

@end

NS_ASSUME_NONNULL_END
