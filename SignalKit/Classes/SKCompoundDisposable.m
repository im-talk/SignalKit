//
//  SKCompoundDisposable.m
//  SignalKit_Example
//
//  Created by xueqooy on 2021/9/11.
//  Copyright © 2021 xue03106991. All rights reserved.
//

#import "SKCompoundDisposable.h"
#import <pthread/pthread.h>

@implementation SKCompoundDisposable {
    pthread_mutex_t _lock;
    BOOL _disposed;
    NSMutableArray<id<SKDisposable>> *_disposables;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        pthread_mutex_init(&_lock, NULL);
        
        _disposables = @[].mutableCopy;
    }
    return self;
}

- (void)dealloc {
    pthread_mutex_destroy(&_lock);
}

- (void)addDisposable:(id<SKDisposable>)disposable {
    if (disposable == nil) {
        return;
    }
    
    BOOL disposeImmediately = NO;
    
    pthread_mutex_lock(&_lock);
    if (_disposed) {
        disposeImmediately = YES;
    } else {
        [_disposables addObject:disposable];
    }
    pthread_mutex_unlock(&_lock);

    if (disposeImmediately) {
        [disposable dispose];
    }
}

- (void)removeDisposable:(id<SKDisposable>)disposable {
    if (disposable == nil) {
        return;
    }
    
    pthread_mutex_lock(&_lock);
    [_disposables removeObject:disposable];
    pthread_mutex_unlock(&_lock);
}

- (void)dispose {
    NSArray<id<SKDisposable>> *disposables;
    pthread_mutex_lock(&_lock);
    if (!_disposed) {
        _disposed = YES;
        disposables = _disposables;
        _disposables = @[].mutableCopy;
    }
    pthread_mutex_unlock(&_lock);
    
    for (id<SKDisposable> disposable in disposables) {
        [disposable dispose];
    }

}

@end
