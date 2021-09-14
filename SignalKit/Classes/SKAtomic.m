//
//  SKAtomic.m
//  SignalKit_Example
//
//  Created by xueqooy on 2021/9/11.
//  Copyright © 2021 xue03106991. All rights reserved.
//

#import "SKAtomic.h"
#import <pthread/pthread.h>

@implementation SKAtomic {
    pthread_mutex_t _lock;
    id _value;
}

- (instancetype)init {
    return [self initWithValue:nil];
}

- (instancetype)initWithValue:(id)value {
    self = [super init];
    if (self) {
        pthread_mutex_init(&_lock, NULL);
        _value = value;
    }
    return self;
}

+ (instancetype)atomicWithValue:(id)value {
    return [[self alloc] initWithValue:value];
}

- (void)dealloc {
    pthread_mutex_destroy(&_lock);
}

- (id)value {
    id value = nil;
    pthread_mutex_lock(&_lock);
    value = _value;
    pthread_mutex_unlock(&_lock);
    return value;
}

- (id)swap:(id)newValue {
    id previousValue = nil;
    pthread_mutex_lock(&_lock);
    previousValue = _value;
    _value = newValue;
    pthread_mutex_unlock(&_lock);
    return previousValue;
}

- (id)modify:(id  _Nullable (^)(id _Nullable))block {
    id newValue = nil;
    pthread_mutex_lock(&_lock);
    newValue = block(_value);
    _value = newValue;
    pthread_mutex_unlock(&_lock);
    return newValue;
}

- (id)with:(id  _Nullable (^)(id _Nullable))block {
    id result = nil;
    pthread_mutex_lock(&_lock);
    result = block(_value);
    pthread_mutex_unlock(&_lock);
    return result;
}

@end
