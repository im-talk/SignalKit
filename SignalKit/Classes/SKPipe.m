//
//  SKPipe.m
//  SignalKit_Example
//
//  Created by xueqooy on 2021/9/11.
//  Copyright © 2021 xue03106991. All rights reserved.
//

#import "SKPipe.h"
#import "SKAtomic.h"
#import "SKBag.h"
#import "SKBlockDisposable.h"

@implementation SKPipe {
    SKAtomic *_subscribers;
    
    BOOL _hasReceivedValue;
    id _lastValue;
}
 
- (instancetype)init {
    self = [super init];
    if (self) {
        _subscribers = [SKAtomic atomicWithValue:[SKBag new]];
    }
    return self;
}

- (SKSignal *)signal {
    return [self _signalWithReplay:NO];
}

- (SKSignal *)signalWithReplay {
    return [self _signalWithReplay:YES];
}

- (SKSignal *)_signalWithReplay:(BOOL)replay {
    __weak typeof(self) weakSelf = self;
    return [SKSignal signalWithGenerator:^id<SKDisposable> _Nullable(SKSubscriber * _Nonnull subscriber) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            NSInteger key = [[strongSelf->_subscribers with:^id _Nullable(SKBag *_Nullable bag) {
                return @([bag addItem:^(id value){
                    [subscriber putNext:value];
                }]);
            }] integerValue];
            
            if (replay) {
                if (strongSelf->_hasReceivedValue) {
                    [subscriber putNext:strongSelf->_lastValue];
                }
            }
            
            return [SKBlockDisposable disposableWithBlock:^{
                __strong typeof(weakSelf) strongSelf = weakSelf;
                if (strongSelf) {
                    [strongSelf->_subscribers with:^id _Nullable(SKBag *_Nullable bag) {
                        [bag removeItemForKey:key];
                        return nil;
                    }];
                }
            }];
        } else {
            return nil;
        }
    }];
}

- (void)sink:(id)value {
    NSArray< void (^)(id)> *items = [self->_subscribers with:^id _Nullable(SKBag *_Nullable bag) {
        return bag.allItems;
    }];
    for (void (^block)(id) in items) {
        block(value);
    }
    
    _hasReceivedValue = YES;
    _lastValue = value;
}

@end
