//
//  SKSignal+Single.m
//  SignalKit_Example
//
//  Created by xueqooy on 2021/9/11.
//  Copyright © 2021 xue03106991. All rights reserved.
//

#import "SKSignal+Single.h"

@implementation SKSignal (Single)

+ (SKSignal *)single:(id)value {
    return [SKSignal signalWithGenerator:^id<SKDisposable> _Nullable(SKSubscriber * _Nonnull subscriber) {
        [subscriber putNext:value];
        [subscriber putCompletion];
        return nil;
    }];
}

+ (SKSignal *)fail:(id)error {
    return [SKSignal signalWithGenerator:^id<SKDisposable> _Nullable(SKSubscriber * _Nonnull subscriber) {
        [subscriber putError:error];
        return nil;
    }];
}

+ (SKSignal<NoValue,NoError> *)never {
    return [SKSignal signalWithGenerator:^id<SKDisposable> _Nullable(SKSubscriber * _Nonnull subscriber) {
        return nil;
    }];
}

+ (SKSignal<NoValue,NoError> *)complete {
    return [SKSignal signalWithGenerator:^id<SKDisposable> _Nullable(SKSubscriber * _Nonnull subscriber) {
        [subscriber putCompletion]; 
        return nil;

    }];
}

@end 
