//
//  SKQueue.m
//  SignalKit_Example
//
//  Created by xueqooy on 2021/9/11.
//  Copyright © 2021 xue03106991. All rights reserved.
//

#import "SKQueue.h"
#import <stdatomic.h>

static atomic_int keyCounter = 0;

@implementation SKQueue {
    dispatch_queue_t _underlyingQueue;
    CFNumberRef _specific;
}

+ (SKQueue *)mainQueue {
    static SKQueue *mainQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mainQueue = [[SKQueue alloc] initWithUnderlyingQueue:dispatch_get_main_queue()];
    });
    return mainQueue;
}

+ (SKQueue *)concurrentDefaultQueue {
    static SKQueue *concurrentDefaultQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        concurrentDefaultQueue = [[SKQueue alloc] initWithUnderlyingQueue:dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0)];
    });
    return concurrentDefaultQueue;
}

+ (SKQueue *)concurrentBackgroundQueue {
    static SKQueue *concurrentBackgroundQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        concurrentBackgroundQueue = [[SKQueue alloc] initWithUnderlyingQueue:dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)];
    });
    return concurrentBackgroundQueue;
}

- (instancetype)init {
    return [self initWithName:nil concurrent:NO qos:QOS_CLASS_DEFAULT];
}

- (instancetype)initWithName:(NSString *)name concurrent:(BOOL)concurrent qos:(dispatch_qos_class_t)qos{
    dispatch_queue_attr_t attr = dispatch_queue_attr_make_with_qos_class(concurrent ? DISPATCH_QUEUE_CONCURRENT : DISPATCH_QUEUE_SERIAL, qos, 0);
    dispatch_queue_t queue = dispatch_queue_create([name UTF8String], attr);
    
    return [self initWithUnderlyingQueue:queue];
}

- (instancetype)initWithUnderlyingQueue:(dispatch_queue_t)underlyingQueue {
    NSParameterAssert(underlyingQueue);
    
    self = [super init];
    if (self) {
        _underlyingQueue = underlyingQueue;
        
        _specific = (__bridge_retained CFNumberRef)@(atomic_fetch_add_explicit(&keyCounter, 1, memory_order_relaxed));
        dispatch_queue_set_specific(_underlyingQueue, _specific, (void *)_specific, NULL);
    }
    return self;
}

- (dispatch_queue_t)underlyingQueue {
    return _underlyingQueue;
}

- (void)dealloc {
    dispatch_queue_set_specific(_underlyingQueue, _specific, nil, NULL);
    CFRelease(_specific);
}

- (NSString *)name {
    return [NSString stringWithUTF8String:dispatch_queue_get_label(_underlyingQueue)];
}

- (dispatch_qos_class_t)qos {
    return dispatch_queue_get_qos_class(_underlyingQueue, NULL);
}

- (BOOL)isConcurrent {
    NSString *clsName = NSStringFromClass(_underlyingQueue.class);
    if ([clsName isEqualToString:@"OS_dispatch_queue_global"] || [clsName isEqualToString:@"OS_dispatch_queue_concurrent"]) {
        return YES;
    }
    return NO;
}

- (BOOL)isCurrent {
    BOOL isCurrent = dispatch_get_specific(_specific) == _specific;
    return isCurrent;
}

- (void)async:(void (^)(void))block {
    if (self.isCurrent) {
        block();
    } else {
        dispatch_async(_underlyingQueue, block);
    }
}

- (void)sync:(void (^NS_NOESCAPE)(void))block {
    if (self.isCurrent) {
        block();
    } else {
        dispatch_sync(_underlyingQueue, block);
    }
}

- (void)delay:(NSTimeInterval)seconds execute:(void (^)(void))block {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC)), _underlyingQueue, block);
}

#pragma mark - Description

- (NSString *)description {
    static NSDictionary<NSNumber *, NSString *> *qosDictionary;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        qosDictionary = @{
            @(QOS_CLASS_USER_INTERACTIVE) : @"USER_INTERACTIVE",
            @(QOS_CLASS_USER_INITIATED) : @"USER_INITIATED",
            @(QOS_CLASS_DEFAULT) : @"DEFAULT",
            @(QOS_CLASS_UTILITY) : @"UTILITY",
            @(QOS_CLASS_BACKGROUND) : @"BACKGROUND",
            @(QOS_CLASS_UNSPECIFIED) : @"USER_INTERACTIVE",
        };
    });
    
    return [NSString stringWithFormat:@"queue:%@,isConcurrent:%@,qos:%@,isCurrent:%@", self.underlyingQueue, self.isConcurrent ? @"YES" : @"NO", qosDictionary[@(self.qos)], self.isCurrent ? @"YES" : @"NO"];
}

@end
