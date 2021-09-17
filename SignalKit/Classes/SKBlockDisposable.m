//
//  SKBlockDisposable.m
//  SignalKit
//
//  Created by xueqooy on 2021/9/4.
//  Copyright © 2021 xue03106991. All rights reserved.
//

#import "SKBlockDisposable.h"
#import <pthread/pthread.h>

@implementation SKBlockDisposable {
    pthread_mutex_t _lock;
    void (^_block)(void);
}

+ (instancetype)disposableWithBlock:(void (^)(void))block {
    return [[self alloc] initWithBlock:block];
} 

- (instancetype)initWithBlock:(void (^)(void))block {
    self = [super init];
    if (self) {
        pthread_mutex_init(&_lock, NULL);
        _block = [block copy];
    }
    return self;
}

- (void)dealloc {
    pthread_mutex_destroy(&_lock);
}

- (void)dispose {
    void (^block)(void) = nil;
    pthread_mutex_lock(&_lock);
    block = _block;
    _block = nil;
    pthread_mutex_unlock(&_lock);
    if (block) {
        block();
    }
}

@end
