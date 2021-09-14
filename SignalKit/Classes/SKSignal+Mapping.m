//
//  SKSignal+Mapping.m
//  SignalKit
//
//  Created by xueqooy on 2021/9/4.
//  Copyright © 2021 xue03106991. All rights reserved.
//

#import "SKSignal+Mapping.h"
#import "SKAtomic.h"

@implementation SKSignal (Mapping)

- (SKSignal *)map:(id  _Nullable (^)(id _Nullable))block {
    return [[SKSignal alloc] initWithGenerator:^id<SKDisposable> _Nullable(SKSubscriber * _Nonnull subscriber) {
        return [self startWithNext:^(id  _Nullable value) {
            [subscriber putNext:block(value)];
        } error:^(id _Nullable error) {
            [subscriber putError:error];
        } completed:^{
            [subscriber putCompletion];
        }];
    }];
}

- (SKSignal *)mapError:(id  _Nullable (^)(id _Nullable))block {
    return [[SKSignal alloc] initWithGenerator:^id<SKDisposable> _Nullable(SKSubscriber * _Nonnull subscriber) {
        return [self startWithNext:^(id  _Nullable value) {
            [subscriber putNext:value];
        } error:^(id _Nullable error) {
            [subscriber putError:block(error)];
        } completed:^{
            [subscriber putCompletion];
        }];
    }];
}

- (SKSignal *)filter:(BOOL (^)(id _Nullable))block {
    return [[SKSignal alloc] initWithGenerator:^id<SKDisposable> _Nullable(SKSubscriber * _Nonnull subscriber) {
        return [self startWithNext:^(id  _Nullable value) {
            if (block(value)) {
                [subscriber putNext:value];
            }
        } error:^(id _Nullable error) {
            [subscriber putError:error];
        } completed:^{
            [subscriber putCompletion];
        }];
    }];
}

- (SKSignal *)distinctUntilChanged {
    return [[SKSignal alloc] initWithGenerator:^id<SKDisposable> _Nullable(SKSubscriber * _Nonnull subscriber) {
        __block id lastValue = nil;
        __block BOOL initial = YES;
        
        return [self startWithNext:^(id  _Nullable value) {
            if (!initial && (lastValue == value || [value isEqual:lastValue])) return;
            
            initial = NO;
            lastValue = value;
            [subscriber putNext:value];
        } error:^(id  _Nullable error) {
            [subscriber putError:error];
        } completed:^{
            [subscriber putCompletion];
        }];
    }];
}

- (SKSignal *)distinctUntilChangedWithBlock:(BOOL (^)(id _Nonnull, id _Nonnull))block {
    return [[SKSignal alloc] initWithGenerator:^id<SKDisposable> _Nullable(SKSubscriber * _Nonnull subscriber) {
        __block id lastValue = nil;
        __block BOOL initial = YES;
        
        return [self startWithNext:^(id  _Nullable value) {
            if (!initial && (lastValue == value || block(value, lastValue))) return;
            
            initial = NO;
            lastValue = value;
            [subscriber putNext:value];
        } error:^(id  _Nullable error) {
            [subscriber putError:error];
        } completed:^{
            [subscriber putCompletion];
        }];
    }];
}

@end
