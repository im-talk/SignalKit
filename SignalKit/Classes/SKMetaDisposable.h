//
//  SKMetaDisposable.h
//  SignalKit_Example
//
//  Created by xueqooy on 2021/9/14.
//  Copyright © 2021 xue03106991. All rights reserved.
//

#import "SKDisposable.h"

NS_ASSUME_NONNULL_BEGIN

@interface SKMetaDisposable : NSObject<SKDisposable>

- (void)setDisposable:(id<SKDisposable>)disposable;

@end

NS_ASSUME_NONNULL_END
