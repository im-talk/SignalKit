//
//  SKTimer.m
//  SignalKit_Example
//
//  Created by xueqooy on 2021/9/11.
//  Copyright © 2021 xue03106991. All rights reserved.
//

#import "SKTimer.h"
#import "SKAtomic.h"

@implementation SKTimer { 
    SKAtomic<dispatch_source_t> *_timer;
    void (^_block)(SKTimer *);
    BOOL _repeat;
    SKQueue *_queue;
    NSTimeInterval _interval;
}

+ (instancetype)timerWithTimeInterval:(NSTimeInterval)interval repeat:(BOOL)repeat queue:(SKQueue *)queue block:(void (^)(SKTimer * _Nonnull))block {
    return [[self alloc] initWithTimeInterval:interval repeat:repeat queue:queue block:block];
}

- (instancetype)initWithTimeInterval:(NSTimeInterval)interval repeat:(BOOL)repeat queue:(SKQueue *)queue block:(void (^)(SKTimer * _Nonnull))block {
    self = [super init];
    if (self) {
        _timer = [SKAtomic new];
        _interval = interval;
        _repeat = repeat;
        _queue = queue ?: [SKQueue mainQueue];
        _block = [block copy];
    }
    return self;
}

- (void)dealloc {
    [self stop];
}

- (BOOL)isRunning {
    return !!_timer.value;
}

- (void)start {
    [self stop];
        
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, _queue.underlyingQueue);
    dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_interval * NSEC_PER_SEC)), _repeat ? (int64_t)(_interval * NSEC_PER_SEC) : DISPATCH_TIME_FOREVER, 0);
    
    __weak typeof(self) weakSelf = self;
    dispatch_source_set_event_handler(timer, ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf->_block) {
            strongSelf->_block(strongSelf);
        }

        if (!strongSelf->_repeat) {
            [strongSelf stop];
        }
    });
    
    [_timer modify:^id _Nullable(dispatch_source_t  _Nullable value) {
        return timer;
    }];
    
    dispatch_resume(timer);
}

- (void)fire {
    if (self.isRunning) {
        if (_block) {
            _block(self);
        }

        if (!_repeat) {
            [self stop];
        }
    }
}

- (void)stop {
    [_timer modify:^id _Nullable(dispatch_source_t  _Nullable value) {
        if (value) {
            dispatch_source_cancel(value);
        }
        return nil;
    }];
}

@end
