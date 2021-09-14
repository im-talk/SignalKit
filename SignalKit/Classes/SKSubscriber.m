//
//  SKSubscriber.m
//  SignalKit_Example
//
//  Created by xueqooy on 2021/9/3.
//  Copyright © 2021 xue03106991. All rights reserved.
//

#import "SKSubscriber.h"
#import "SKSubscriberInternal.h"
#import <pthread/pthread.h>

@interface SKSubscriberBlocks : NSObject {
    @public
    void (^_next)(id value) ;
    void (^_error)(id error);
    void (^_completed)(void);
}

@end

@implementation SKSubscriberBlocks

- (instancetype)initWithNext:(void (^)(id value))next error:(void (^)(id error))error completed:(void (^)(void))completed {
    self = [super init];
    if (self) {
        _next = [next copy];
        _error = [error copy];
        _completed = [completed copy];
    }
    return self;
}

@end

@implementation SKSubscriber {
    @protected
    pthread_mutex_t _lock;
    bool _terminated;
    id<SKDisposable> _disposable;
    SKSubscriberBlocks *_blocks;
}

- (instancetype)initWithNext:(void (^)(id _Nullable))next error:(void (^)(id _Nullable))error completed:(void (^)(void))completed {
    self = [super init];
    if (self) {
        pthread_mutex_init(&_lock, NULL);
        
        _blocks = [[SKSubscriberBlocks alloc] initWithNext:next error:error completed:completed];
    }
    return self;
}

- (void)dealloc {
    pthread_mutex_destroy(&_lock);
}

- (void)putNext:(id)next {
    SKSubscriberBlocks *blocks = nil;
    
    pthread_mutex_lock(&_lock);
    if (!_terminated) {
        blocks = _blocks;
    }
    pthread_mutex_unlock(&_lock);
    
    if (blocks && blocks->_next) {
        blocks->_next(next);
    }
}

- (void)putError:(id)error {
    SKSubscriberBlocks *blocks = nil;
    id<SKDisposable> disposable = nil;

    pthread_mutex_lock(&_lock);
    if (!_terminated) {
        blocks = _blocks;
        _blocks = nil;
        
        disposable = _disposable;
        _disposable = nil;
        
        _terminated = true;
    }
    pthread_mutex_unlock(&_lock);
    
    if (blocks && blocks->_error) {
        blocks->_error(error);
    }
    
    if (disposable) {
        [disposable dispose];
    }
}

- (void)putCompletion {
    SKSubscriberBlocks *blocks = nil;
    id<SKDisposable> disposable = nil;
    
    pthread_mutex_lock(&_lock);
    if (!_terminated) {
        blocks = _blocks;
        _blocks = nil;
        
        disposable = _disposable;
        _disposable = nil;
        
        _terminated = true;
    }
    pthread_mutex_unlock(&_lock);
    
    if (blocks && blocks->_completed)
        blocks->_completed();
    
    if (disposable) {
        [disposable dispose];
    }
}

- (void)dispose {
    [self->_disposable dispose];
}

#pragma mark - Internal

- (void)assignDisposable:(id<SKDisposable>)disposable {
    bool shouldDispose = false;
    pthread_mutex_lock(&_lock);
    if (_terminated) {
        shouldDispose = true;
    } else {
        _disposable = disposable;
    }
    pthread_mutex_unlock(&_lock);
    
    if (shouldDispose) {
        [disposable dispose];
    }
}

- (void)markTerminatedWithoutDisposal {
    pthread_mutex_lock(&_lock);
    SKSubscriberBlocks *blocks = nil;
    if (!_terminated) {
        blocks = _blocks;
        _blocks = nil;
        
        _terminated = true;
    }
    pthread_mutex_unlock(&_lock);
    
    if (blocks) {
        blocks = nil;
    }
}

@end
