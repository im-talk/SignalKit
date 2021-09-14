//
//  SKDisposable.h
//  SignalKit_Example
//
//  Created by xueqooy on 2021/9/3.
//  Copyright © 2021 xue03106991. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SKDisposable <NSObject>

- (void)dispose;

@end

NS_ASSUME_NONNULL_END
