//
//  SKSignal+Dispatch.m
//  SignalKit_Example
//
//  Created by xueqooy on 2021/9/14.
//  Copyright © 2021 xue03106991. All rights reserved.
//

#import "SKSignal+Dispatch.h"
#import "SKMetaDisposable.h"
#import "SKBlockDisposable.h"

@implementation SKSignal (Dispatch)

- (SKSignal *)runOnQueue:(SKQueue *)queue {
    return [[SKSignal alloc] initWithGenerator:^id<SKDisposable> _Nullable(SKSubscriber * _Nonnull subscriber) {
        __block BOOL isCancelled = NO;
        SKMetaDisposable *disposable = [[SKMetaDisposable alloc] init];
        [disposable setDisposable:[SKBlockDisposable disposableWithBlock:^{
            isCancelled = YES;
        }]];
        
        [queue async:^{
            if (isCancelled) {
                return;
            }
            
            [disposable setDisposable:[self startWithNext:^(id  _Nullable value) {
                [subscriber putNext:value];
            } error:^(id  _Nullable error) {
                [subscriber putError:error];
            } completed:^{
                [subscriber putCompletion];
            }]];
        }];
        
        return disposable;
    }];
}

- (SKSignal *)runOnThreadPool:(SKThreadPool *)threadPool {
    return [[SKSignal alloc] initWithGenerator:^id<SKDisposable> _Nullable(SKSubscriber * _Nonnull subscriber) {
        SKMetaDisposable *disposable = [[SKMetaDisposable alloc] init];
        
        SKThreadPoopTask *task = [[SKThreadPoopTask alloc] initWithBlock:^(SKThreadPoopTaskState * _Nonnull state) {
            if (state.isCancelled) {
                return;
            }
            
            [disposable setDisposable:[self startWithNext:^(id  _Nullable value) {
                [subscriber putNext:value];
            } error:^(id  _Nullable error) {
                [subscriber putError:error];
            } completed:^{
                [subscriber putCompletion];
            }]];
        }];
        
        [disposable setDisposable:[SKBlockDisposable disposableWithBlock:^{
            [task cancel];
        }]];
        
        [threadPool addTask:task];
        
        return disposable;
    }];
}

- (SKSignal *)deliverOnQueue:(SKQueue *)queue {
    return [[SKSignal alloc] initWithGenerator:^id<SKDisposable> _Nullable(SKSubscriber * _Nonnull subscriber) {
        return [self startWithNext:^(id  _Nullable value) {
            [queue async:^{
                [subscriber putNext:value];
            }];
        } error:^(id  _Nullable error) {
            [queue async:^{
                [subscriber putError:error];
            }];
        } completed:^{
            [queue async:^{
                [subscriber putCompletion];
            }];
        }];
    }];
}

- (SKSignal *)deliverOnMainQueue {
    return [self deliverOnQueue:SKQueue.mainQueue];
}

- (SKSignal *)deliverOnThreadPool:(SKThreadPool *)threadPool {
    return [[SKSignal alloc] initWithGenerator:^id<SKDisposable> _Nullable(SKSubscriber * _Nonnull subscriber) {
        SKThreadPoolQueue *queue = [threadPool nextQueue];
        return [self startWithNext:^(id  _Nullable value) {
            [queue addTask:[SKThreadPoopTask taskWithBlock:^(SKThreadPoopTaskState * _Nonnull state) {
                if (!state.isCancelled) {
                    [subscriber putNext:value];
                }
            }]];
        } error:^(id  _Nullable error) {
            [queue addTask:[SKThreadPoopTask taskWithBlock:^(SKThreadPoopTaskState * _Nonnull state) {
                if (!state.isCancelled) {
                    [subscriber putError:error];
                }
            }]];
        } completed:^{
            [queue addTask:[SKThreadPoopTask taskWithBlock:^(SKThreadPoopTaskState * _Nonnull state) {
                if (!state.isCancelled) {
                    [subscriber putCompletion];
                }
            }]];
        }];
    }];
}

@end
