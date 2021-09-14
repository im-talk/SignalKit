//
//  SKSignal+Timing.m
//  SignalKit_Example
//
//  Created by xueqooy on 2021/9/14.
//  Copyright © 2021 xue03106991. All rights reserved.
//

#import "SKSignal+Timing.h"
#import "SKTimer.h"
#import "SKMetaDisposable.h"
#import "SKBlockDisposable.h"

@implementation SKSignal (Timing)

- (SKSignal *)delay:(NSTimeInterval)seconds onQueue:(SKQueue *)queue {
    return [[SKSignal alloc] initWithGenerator:^id<SKDisposable> _Nullable(SKSubscriber * _Nonnull subscriber) {
        SKMetaDisposable *disposable = [[SKMetaDisposable alloc] init];
        
        SKTimer *timer = [[SKTimer alloc] initWithTimeInterval:seconds repeat:NO queue:queue block:^(SKTimer * _Nonnull timer) {
            [disposable setDisposable:[self startWithNext:^(id  _Nullable value) {
                [subscriber putNext:value];
            } error:^(id  _Nullable error) {
                [subscriber putError:error];
            } completed:^{
                [subscriber putCompletion];
            }]];
        }];
        
        [timer start];
        
        [disposable setDisposable:[SKBlockDisposable disposableWithBlock:^{
            [timer stop];
        }]];
        
        return disposable;
    }]; 
}

@end
