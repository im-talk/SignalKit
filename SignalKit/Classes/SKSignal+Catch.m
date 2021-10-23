//
//  SKSignal+Catch.m
//  SignalKit_Example
//
//  Created by xueqooy on 2021/9/18.
//  Copyright © 2021 xue03106991. All rights reserved.
//

#import "SKSignal+Catch.h"
#import "SKMetaDisposable.h"
#import "SKCompoundDisposable.h"
#import "SKBlockDisposable.h"
#import "SKAtomic.h"

@implementation SKSignal (Catch)

- (SKSignal *)catch:(SKSignal * _Nonnull (^)(id _Nonnull))block {
    NSParameterAssert(block);
    
    return [[SKSignal alloc] initWithGenerator:^id<SKDisposable> _Nullable(SKSubscriber * _Nonnull subscriber) {
        SKCompoundDisposable *disposable = [[SKCompoundDisposable alloc] init];
        
        [disposable addDisposable:[self startWithNext:^(id  _Nullable value) {
            [subscriber putNext:value];
        } error:^(id  _Nullable error) {
            SKSignal *signal = block(error);
            [disposable addDisposable:[signal startWithNext:^(id  _Nullable value) {
                [subscriber putNext:value];
            } error:^(id  _Nullable error) {
                [subscriber putError:error];
            } completed:^{
                [subscriber putCompletion];
            }]];
        } completed:^{
            [subscriber putCompletion];
        }]];
        
        return disposable;
    }];
}

- (SKSignal *)catchToSignal:(SKSignal *)signal {
    NSParameterAssert(signal);
    
    return [[SKSignal alloc] initWithGenerator:^id<SKDisposable> _Nullable(SKSubscriber * _Nonnull subscriber) {
        SKCompoundDisposable *disposable = [[SKCompoundDisposable alloc] init];
        
        [disposable addDisposable:[self startWithNext:^(id  _Nullable value) {
            [subscriber putNext:value];
        } error:^(id  _Nullable error) {
            [disposable addDisposable:[signal startWithNext:^(id  _Nullable value) {
                [subscriber putNext:value];
            } error:^(id  _Nullable error) {
                [subscriber putError:error];
            } completed:^{
                [subscriber putCompletion];
            }]];
        } completed:^{
            [subscriber putCompletion];
        }]];
        
        return disposable;
    }];
}

static dispatch_block_t recursiveBlock(void (^block)(dispatch_block_t recurse)) {
    return ^{
        block(recursiveBlock(block));
    };
}

- (SKSignal *)retry:(NSUInteger)retryCount {
    return [self retryIf:^BOOL(id  _Nullable error, NSUInteger currentRetryCount) {
        return retryCount == 0 || currentRetryCount < retryCount;
    }];
}

- (SKSignal *)retry:(NSUInteger)retryCount delayIncrement:(NSTimeInterval)delayIncrement maxDelay:(NSTimeInterval)maxDelay onQueue:(SKQueue *)queue {
    return [self retryIf:^BOOL(id  _Nullable error, NSUInteger currentRetryCount) {
        return retryCount == 0 || currentRetryCount < retryCount;
    } delayIncrement:delayIncrement maxDelay:maxDelay onQueue:queue];
}

- (SKSignal *)retryIf:(BOOL (^)(id _Nullable, NSUInteger))predicate {
    return [[SKSignal alloc] initWithGenerator:^id<SKDisposable> _Nullable(SKSubscriber * _Nonnull subscriber) {
        SKAtomic<NSNumber *> *currentRetryCount = [SKAtomic atomicWithValue:@0];
        
        SKMetaDisposable *disposable = [[SKMetaDisposable alloc] init];
        
        dispatch_block_t start = recursiveBlock(^(dispatch_block_t recurse) {
            [disposable setDisposable: [self startWithNext:^(id  _Nullable value) {
                [subscriber putNext:value];
            } error:^(id  _Nullable error) {
                if (predicate(error, currentRetryCount.value.unsignedIntegerValue)) {
                    [currentRetryCount modify:^id _Nullable(NSNumber * _Nullable value) {
                        return @(value.unsignedIntegerValue + 1);
                    }];
                    recurse();
                } else {
                    [subscriber putError:error];
                }
            } completed:^{
                [subscriber putCompletion];
            }]];
        });
        
        start();
        
        return [SKBlockDisposable disposableWithBlock:^{
            [disposable dispose];
        }];
    }];
}

- (SKSignal *)retryIf:(BOOL (^)(id _Nullable, NSUInteger))predicate delayIncrement:(NSTimeInterval)delayIncrement maxDelay:(NSTimeInterval)maxDelay onQueue:(SKQueue *)queue {
    return [[SKSignal alloc] initWithGenerator:^id<SKDisposable> _Nullable(SKSubscriber * _Nonnull subscriber) {
        SKAtomic<NSNumber *> *currentRetryCount = [SKAtomic atomicWithValue:@0];
        SKAtomic<NSNumber *> *currentDelay = [SKAtomic atomicWithValue:@(0)];
        
        SKMetaDisposable *disposable = [[SKMetaDisposable alloc] init];
        
        dispatch_block_t start = recursiveBlock(^(dispatch_block_t recurse) {
            if (disposable.isDisposed) return;
             
            [disposable setDisposable: [self startWithNext:^(id  _Nullable value) {
                [subscriber putNext:value];
            } error:^(id  _Nullable error) {
                NSUInteger currentCount = currentRetryCount.value.unsignedIntegerValue;
                if (predicate(error, currentCount)) {
                    NSTimeInterval delay = [[currentDelay modify:^id _Nullable(NSNumber * _Nullable value) {
                        return @(MIN(maxDelay, value.doubleValue + delayIncrement));
                    }] doubleValue];
                    
                    [currentRetryCount modify:^id _Nullable(NSNumber * _Nullable value) {
                        return @(value.unsignedIntegerValue + 1);
                    }];
                    [queue delay:delay execute:recurse];
                } else {
                    [subscriber putError:error];
                }
            } completed:^{
                [subscriber putCompletion];
            }]];
        });
        
        start();
        
        return [SKBlockDisposable disposableWithBlock:^{
            [disposable dispose];
        }];
    }];
}

@end
