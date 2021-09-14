//
//  SKMetaDisposable.m
//  SignalKit_Example
//
//  Created by xueqooy on 2021/9/14.
//  Copyright © 2021 xue03106991. All rights reserved.
//

#import "SKMetaDisposable.h"
#import <pthread/pthread.h>

@implementation SKMetaDisposable {
    pthread_mutex_t _lock;
    BOOL _disposed;
    id<SKDisposable> _disposable;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        pthread_mutex_init(&_lock, NULL);
    }
    return self;
}

- (void)dealloc {
    pthread_mutex_destroy(&_lock);
}

- (void)setDisposable:(id<SKDisposable>)disposable {
    id<SKDisposable> previousDisposable = nil;
    BOOL dispose = NO;
    
    pthread_mutex_lock(&_lock);
    dispose = _disposed;
    if (!dispose) {
        previousDisposable = _disposable;
        _disposable = disposable;
    }
    pthread_mutex_unlock(&_lock);
    
    if (previousDisposable) {
        [previousDisposable dispose];
    }
    
    if (dispose) {
        [disposable dispose];
    }
}

- (void)dispose {
    id <SKDisposable> disposable = nil;
    
    pthread_mutex_lock(&_lock);
    if (!_disposed) {
        disposable = _disposable;
        _disposed = YES;
    }
    pthread_mutex_unlock(&_lock);
    
    if (disposable) {
        [disposable dispose];
    }
}

@end
