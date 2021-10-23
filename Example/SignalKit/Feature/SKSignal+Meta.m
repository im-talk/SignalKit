//
//  SKSignal+Meta.m
//  SignalKit_Example
//
//  Created by mac on 2021/10/18.
//  Copyright © 2021 xue03106991. All rights reserved.
//

#import "SKSignal+Meta.h"
#import <pthread/pthread.h>

@interface SKSignalQueueState : NSObject <SKDisposable>

@end

@implementation SKSignalQueueState {
    pthread_mutex_t _lock;
    BOOL _executingSignal;
    BOOL _terminated;
    
    id<SKDisposable> _disposable;
    SKMetaDisposable *_currentDisposable;
    SKSubscriber *_subscriber;
    
    NSMutableArray<SKSignal *> *_queuedSignals;
    BOOL _queueMode;
    BOOL _throttleMode;
}

- (instancetype)initWithSubscriber:(SKSubscriber *)subscriber queueMode:(BOOL)queueMode throttleMode:(BOOL)throttleMode {
    self = [super init];
    if (self) {
        _subscriber = subscriber;
        _currentDisposable = [[SKMetaDisposable alloc] init];
        _queuedSignals = queueMode ? @[].mutableCopy : nil;
        _queueMode = queueMode;
        _throttleMode = throttleMode;
        
        pthread_mutex_init(&_lock, NULL);
    }
    return self;
}

- (void)dealloc {
    pthread_mutex_destroy(&_lock);
}

- (void)beginWithDisposable:(id<SKDisposable>)disposable {
    _disposable = disposable;
}

- (void)enqueueSignal:(SKSignal *)signal {
    BOOL startSignal = NO;
    pthread_mutex_lock(&_lock);
    if (_queueMode && _executingSignal) {
        if (_throttleMode) {
            [_queuedSignals removeAllObjects];
        }
        [_queuedSignals addObject:signal];
    } else {
        _executingSignal = YES;
        startSignal = YES;
    }
    pthread_mutex_unlock(&_lock);
    
    if (startSignal) {
        __weak typeof(self) weakSelf = self;
        id<SKDisposable> disposable = [signal startWithNext:^(id  _Nullable value) {
            [self->_subscriber putNext:value];
        } error:^(id  _Nullable error) {
            [self->_subscriber putError:error];
        } completed:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf) {
                [strongSelf headCompleted];
            }
        }];
        
        [_currentDisposable setDisposable:disposable];
    }
}

- (void)headCompleted {
    SKSignal *nextSignal = nil;
    
    BOOL terminated = NO;
    pthread_mutex_lock(&_lock);
    _executingSignal = NO;
    
    if (_queueMode) {
        if (_queuedSignals.count != 0) {
            nextSignal = _queuedSignals.firstObject;
            [_queuedSignals removeObjectAtIndex:0];
            _executingSignal = YES;
        } else {
            terminated = _terminated;
        }
    } else {
        terminated = _terminated;
    }
    pthread_mutex_unlock(&_lock);
    
    if (terminated) {
        [_subscriber putCompletion];
    } else if (nextSignal) {
        __weak typeof(self) weakSelf = self;
        id<SKDisposable> disposable = [nextSignal startWithNext:^(id  _Nullable value) {
            [self->_subscriber putNext:value];
        } error:^(id  _Nullable error) {
            [self->_subscriber putError:error];
        } completed:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (strongSelf) {
                [strongSelf headCompleted];
            }
        }];
        
        [_currentDisposable setDisposable:disposable];
    }
}

- (void)beginCompletion {
    BOOL executingSignal = NO;
    pthread_mutex_lock(&_lock);
    executingSignal = _executingSignal;
    _terminated = YES;
    pthread_mutex_unlock(&_lock);
    
    if (!executingSignal) {
        [_subscriber putCompletion];
    }
}

- (void)dispose {
    [_currentDisposable dispose];
    [_disposable dispose];
}

@end

@implementation SKSignal (Meta)

- (SKSignal *)switchToLatest {
    return [[SKSignal alloc] initWithGenerator:^id<SKDisposable> _Nullable(SKSubscriber * _Nonnull subscriber) {
        SKSignalQueueState *state = [[SKSignalQueueState alloc] initWithSubscriber:subscriber queueMode:NO throttleMode:NO];
        [state beginWithDisposable:[self startWithNext:^(id  _Nullable value) {
            NSAssert(value == nil || [value isKindOfClass:SKSignal.class], nil);
            [state enqueueSignal:value];
        } error:^(id  _Nullable error) {
            [subscriber putError:error];
        } completed:^{
            [state beginCompletion];
        }]];
        return state;
    }];
}

+ (SKSignal *)defer:(SKSignal<id, id> * _Nonnull (^)(void))block {
    return [[SKSignal alloc] initWithGenerator:^id<SKDisposable> _Nullable(SKSubscriber * _Nonnull subscriber) {
        return [block() startWithNext:^(id  _Nullable value) {
            [subscriber putNext:value]; 
        } error:^(id  _Nullable error) {
            [subscriber putError:error];
        } completed:^{
            [subscriber putCompletion];
        }];
    }];
}

@end
